import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/forms/options_field.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class ProfileEdit extends StatefulWidget {
  final bool onboarding;
  const ProfileEdit({super.key, this.onboarding = false});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final nationalityController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dobController = TextEditingController();
  final countryController = TextEditingController();
  final currencyController = TextEditingController();

  DateTime? dob;
  String? errorMessage;
  ApiError? apiError;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    final profile = user?.profile;
    if (profile != null) {
      emailController.text = user!.email ?? "";
      firstNameController.text = profile.firstName ?? "";
      lastNameController.text = profile.lastName ?? "";
      genderController.text = Profile.getGender(profile.gender) ?? "";
      phoneNumberController.text = profile.phoneNumber ?? "";
      dob = profile.dob;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        hasScrollBody: false,
        pageAppBar: const PageAppBar(
          largeTitle: Text("Profile"),
        ),
        bodyPadding: ContentPadding,
        bodyListDelegate: SliverChildListDelegate([
          FormInput(
            title: const Text("Email"),
            child: TextFormField(
              enabled: false,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              autofillHints: const [AutofillHints.email],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(
                color: context.textTheme.bodyMedium?.color,
              ),
              decoration: const InputDecoration(
                hintText: "Email",
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.lock, size: 18),
                  onPressed: null,
                ),
              ),
              validator: (v) {
                if (v!.isEmpty) return "Email is required";
                return apiError?.forKey('email');
              },
              onChanged: (_) => setState(() {
                errorMessage = null;
              }),
            ),
          ),
          FormInput(
            title: const Text("First Name"),
            child: TextFormField(
              controller: firstNameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              autofillHints: const [AutofillHints.givenName],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "First Name",
              ),
              validator: (v) {
                if (v!.isEmpty) return "First name is required";
                return apiError?.forKey('first_name');
              },
              onChanged: (_) => setState(() {
                errorMessage = null;
              }),
            ),
          ),
          FormInput(
            title: const Text("Last name"),
            child: TextFormField(
              controller: lastNameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              autofillHints: const [AutofillHints.familyName],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "Last Name",
              ),
              validator: (v) {
                if (v!.isEmpty) return "Last name is required";
                return apiError?.forKey('last_name');
              },
              onChanged: (_) => setState(() {
                errorMessage = null;
              }),
            ),
          ),
          FormInput(
            title: const Text("Gender"),
            child: OptionsField(
              hint: "Select your gender",
              controller: genderController,
              validator: (value) {
                if (value?.isEmpty ?? false) return "Select your gender";
                return apiError?.forKey('gender');
              },
              onTap: () async {
                final res = await showAppBottomSheet<String>(
                  context: context,
                  children: (context) {
                    return [
                      VSizedBox16,
                      ...['Male', 'Female', 'Other'].map((gender) {
                        return RadioListTile<String>(
                          value: gender,
                          groupValue: genderController.text,
                          visualDensity: VisualDensity.compact,
                          title: Text(gender),
                          activeColor: context.colorScheme.secondary,
                          onChanged: (value) {
                            rootNavigator(context).pop(gender);
                          },
                        );
                      }),
                      VSizedBox8,
                    ];
                  },
                );
                if (res != null) {
                  setState(() {
                    genderController.text = res;
                  });
                }
              },
            ),
          ),
          FormInput(
            title: const Text("Date of Birth"),
            child: OptionsField(
              hint: "Select date of birth",
              suffixIcon: const Icon(Icons.calendar_today),
              controller: dobController
                ..text =
                    dob == null ? "" : formatDate(dob, format: 'MMMM d, yyyy'),
              validator: (value) {
                if (value?.isEmpty ?? false) return "Set your date of birth";
                return apiError?.forKey('dob');
              },
              onTap: () async {
                context.unfocus();
                final res = await showDatePicker(
                  context: context,
                  helpText: "DATE OF BIRTH",
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  initialDatePickerMode: DatePickerMode.year,
                  initialDate:
                      dob ?? now.subtract(const Duration(days: 365 * 13)),
                  lastDate: now.subtract(const Duration(days: 365 * 13)),
                  firstDate: now.subtract(const Duration(days: 365 * 90)),
                  builder: (context, child) {
                    return Theme(
                      data: AppTheme.datePickerTheme(context.theme),
                      child: child ?? const SizedBox(),
                    );
                  },
                );
                if (res != null) {
                  setState(() {
                    dob = res;
                  });
                }
              },
            ),
          ),
          FormInput(
            title: const Text("Phone Number"),
            child: TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              autofillHints: const [AutofillHints.telephoneNumber],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\+?1?\d{9,15}$')),
              ],
              decoration: const InputDecoration(
                hintText: "Phone Number",
              ),
              validator: (v) {
                if (v!.isEmpty) return "Phone Number is required";
                return apiError?.forKey('phone_number');
              },
              onChanged: (_) => setState(() {
                errorMessage = null;
              }),
            ),
          ),
        ]),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              save();
            },
          ),
        ),
      ),
    );
  }

  void save() async {
    // final provider = context.read<UserProvider>();
    if (!formKey.currentState!.validate()) return;
    // await ProviderRequest.api(
    //   context: context,
    //   request: provider.updateProfile(Profile(
    //     uuid: provider.user?.profile?.uuid,
    //     firstName: firstNameController.text,
    //     lastName: lastNameController.text,
    //     gender: genderController.text.toLowerCase().split('').first,
    //     dob: dob,
    //     nationality: nationalityController.text,
    //     phoneNumber: phoneNumberController.text,
    //     currencyCode: currency?.code,
    //     country: country,
    //   )),
    //   onApiError: (context, error) {
    //     setState(() {
    //       apiError = error;
    //     });
    //     formKey.currentState!.validate();
    //   },
    //   onSuccess: (context, result) async {
    //     await showAppDialog(
    //       context,
    //       title: "Profile Updated",
    //       message: "Your profile was successfully updated!",
    //       onDismiss: (ctx) {
    //         Navigator.pop(context);
    //       },
    //     );
    //     // if (mounted) Navigator.pop(context);
    //   },
    // );
  }
}
