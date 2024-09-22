import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/freelancer/freelancer_skills.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerCreate extends StatefulWidget {
  final Freelancer? freelancer;
  const FreelancerCreate({
    super.key,
    this.freelancer,
  });

  @override
  State<FreelancerCreate> createState() => _FreelancerCreateState();
}

class _FreelancerCreateState extends State<FreelancerCreate> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bioController = TextEditingController();
  final fullnameController = TextEditingController();
  final locationController = TextEditingController();
  final contactController = TextEditingController();
  final websiteController = TextEditingController();
  final phoneController = TextEditingController();
  HowYouFoundUs? howYouFoundUs;
  List<Skill> skills = [];
  ApiError? apiError;
  String? errorMessage;
  String? avatarUrl;
  XFile? avatarFile;

  bool get isEditing => freelancer != null;

  Freelancer? get freelancer => widget.freelancer;

  @override
  void initState() {
    super.initState();
    final c = freelancer;
    if (c != null) {
      avatarUrl = c.profileImage;
      titleController.text = c.title ?? "";
      bioController.text = c.bio ?? "";
      fullnameController.text = c.fullname ?? "";
      locationController.text = c.location ?? "";
      contactController.text = c.contact ?? "";
      websiteController.text = c.website ?? "";
      phoneController.text = c.phoneNumber ?? "";
      skills = c.skills;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        appBar: AppBar(
          title: const Text("Freelancer Profile"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final image = await showImagePickerOptions(
                    context,
                    onDelete: (avatarUrl != null || avatarFile != null)
                        ? () {
                            setState(() {
                              avatarUrl = null;
                              avatarFile = null;
                            });
                            Navigator.pop(context);
                          }
                        : null,
                  );
                  if (context.mounted && image?.path != null) {
                    await showAppBottomSheet(
                      context: context,
                      padding: ContentPadding,
                      children: (context) {
                        return [
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(image!.path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          VSizedBox12,
                          ElevatedButton(
                            child: const Text("Continue"),
                            onPressed: () async {
                              setState(() {
                                avatarFile = image;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ];
                      },
                    );
                  }
                },
                child: Column(
                  children: [
                    avatarFile != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(File(avatarFile!.path)),
                          )
                        : AppAvatar(
                            radius: 50,
                            imageUrl: avatarUrl,
                            overlayWidget: const CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.black,
                              child: Icon(
                                Icons.camera_alt,
                                size: 17,
                                color: AppColors.white,
                              ),
                            ),
                            child: Icon(
                              PhosphorIconsRegular.user,
                              color: context.primaryColor,
                              size: 40,
                            ),
                          ),
                    VSizedBox10,
                    Text(
                      "Change Picture",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VSizedBox24,
            FormInput(
              title: const Text("Display name"),
              child: TextFormField(
                controller: fullnameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your Full Name",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Full Name is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("What do you do?"),
              child: TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: "Designer, Software Engineer, etc",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Title is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("About you"),
              child: TextFormField(
                controller: bioController,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                minLines: 1,
                maxLines: null,
                // autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Describe yourself in a few lines",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Bio is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Skills"),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: ContentPadding,
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.formBorderRadius,
                    border: Border.all(
                      color: context.inputTheme.enabledBorder!.borderSide.color,
                    ),
                  ),
                  child: skills.isEmpty
                      ? Row(
                          children: [
                            Text(
                              "Select up to 10 skills",
                              style: TextStyle(
                                fontSize: 15,
                                color: context.textTheme.bodySmall?.color,
                              ),
                            ),
                            Space,
                            const RightChevron(),
                          ],
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 8,
                          children: skills.map((v) {
                            return RawChip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(v.name ?? ''),
                            );
                          }).toList(),
                        ),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusScopeNode());
                  final res = await push(
                    context: context,
                    builder: (_) => FreelancerSkills(selected: skills),
                    rootNavigator: true,
                  );
                  if (res != null && res is List<Skill>) {
                    setState(() {
                      skills = res;
                    });
                  }
                },
              ),
            ),
            FormInput(
              title: const Text("Location"),
              child: TextFormField(
                controller: locationController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autofillHints: const [AutofillHints.addressCityAndState],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your current location",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Location is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Contact email"),
              child: TextFormField(
                controller: contactController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your contact email",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Email is required";
                  if (!isValidEmail(v)) return "Enter a valid email";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Phone number"),
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                autocorrect: false,
                autofillHints: const [AutofillHints.telephoneNumber],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your phone number",
                ),
                validator: (v) {
                  if (v!.isEmpty) return null;
                  if (!RegExp(r'^\+?1?\d{9,15}$').hasMatch(v)) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Website"),
              child: TextFormField(
                controller: websiteController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                autofillHints: const [AutofillHints.url],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your website",
                ),
                validator: (v) {
                  if (v!.isEmpty) return null;
                  if (!urlRegex.hasMatch(v)) {
                    return "Enter a valid url";
                  }
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            onPressed: skills.isNotEmpty ? submit : null,
            child: const Text("Save"),
          ),
        ),
      ),
    );
  }

  void submit() async {
    errorMessage = null;
    apiError = null;
    final userProvider = context.read<UserProvider>();
    final freelancerProvider = context.read<FreelancerProvider>();
    if (mounted) setState(() {});
    if (!formKey.currentState!.validate()) return;
    final input = Freelancer(
      id: freelancer?.id,
      user: userProvider.user?.id,
      title: titleController.text.trim(),
      bio: bioController.text.trim(),
      fullname: fullnameController.text.trim(),
      location: locationController.text.trim(),
      contact: contactController.text.trim(),
      website: websiteController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      // howYouFoundUs: howYouFoundUs,
      skills: skills,
    );
    final multipart = avatarFile == null
        ? null
        : await multipartFileFromPath(avatarFile!.path, field: "profile_image");
    if (!mounted) return;
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Saving",
      request: isEditing
          ? freelancerProvider.updateFreelancer(
              freelancer!.id!,
              input,
              imageUpload: multipart,
            )
          : freelancerProvider.createFreelancer(input, imageUpload: multipart),
      // onError: (context) {
      //   setState(() => errorMessage = 'An error occurred');
      // },
      // onApiError: (context, error) {
      //   setState(() => apiError = error);
      //   formKey.currentState!.validate();
      // },
      onSuccess: (context, res) async {
        ProviderRequest.api(
          context: context,
          request: userProvider.getUserMe(),
          onSuccess: (context, res) {
            freelancerProvider.getFreelancers(mapId: "");
            if (isEditing) {
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
                content: Text("Saved"),
              ));
              Navigator.pop(context);
            } else {
              rootNavigator(context).pushNamedAndRemoveUntil(
                  userProvider.getRouteForUser(), (_) => false);
            }
          },
        );
      },
    );
  }
}
