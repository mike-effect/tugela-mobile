import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/company/company_industries.dart';
import 'package:tugela/ui/company/company_values.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/forms/options_field.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class CompanyCreate extends StatefulWidget {
  final Company? company;
  const CompanyCreate({super.key, this.company});

  @override
  State<CompanyCreate> createState() => _CompanyCreateState();
}

class _CompanyCreateState extends State<CompanyCreate> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final taglineController = TextEditingController();
  final websiteController = TextEditingController();
  final orgController = TextEditingController();
  final sizeController = TextEditingController();
  CompanySize companySize = CompanySize.small;
  HowYouFoundUs? howYouFoundUs;
  OrganizationType organizationType = OrganizationType.soleProprietorship;
  List<CompanyValue> companyValues = [];
  Industry? industry;
  ApiError? apiError;
  String? errorMessage;

  bool get isEditing => widget.company != null;

  @override
  void initState() {
    // final companyProvider = context.read<CompanyProvider>();
    // companyProvider.getCompanyIndustries();
    // companyProvider.getCompanyValues();
    if (widget.company != null) {
      final c = widget.company!;
      nameController.text = c.name ?? "";
      descriptionController.text = c.description ?? "";
      emailController.text = c.email ?? "";
      phoneController.text = c.phoneNumber ?? "";
      taglineController.text = c.tagline ?? "";
      websiteController.text = c.website ?? "";
      orgController.text = c.organizationType?.name ?? "";
      if (c.organizationType != null) organizationType = c.organizationType!;
      sizeController.text = c.companySize?.name ?? "";
      if (c.companySize != null) companySize = c.companySize!;
      industry = c.industry;
      companyValues = c.values;
      if (mounted) setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        appBar: AppBar(
          title: const Text("Company Profile"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormInput(
              title: const Text("Name"),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your company name",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Name is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Tagline"),
              child: TextFormField(
                controller: taglineController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: "One line description of your company",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Tagline is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Organization Type"),
              child: OptionsField(
                hint: "Select your organization type",
                text: organizationType.name.sentenceCase,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return "Select your organization type";
                  }
                  return apiError?.forKey('organization_type');
                },
                onTap: () async {
                  final res = await showAppBottomSheet<OrganizationType>(
                    context: context,
                    title: "Organization Size",
                    physics: const NeverScrollableScrollPhysics(),
                    children: (context) {
                      return [
                        ...OrganizationType.values.map((type) {
                          return RadioListTile<OrganizationType>(
                            value: type,
                            groupValue: organizationType,
                            visualDensity: VisualDensity.compact,
                            title: Text(type.name.sentenceCase),
                            activeColor: context.colorScheme.secondary,
                            onChanged: (value) {
                              rootNavigator(context).pop(type);
                            },
                          );
                        }),
                        VSizedBox8,
                      ];
                    },
                  );
                  if (res != null) {
                    setState(() {
                      organizationType = res;
                    });
                  }
                },
              ),
            ),
            FormInput(
              title: const Text("Industry"),
              child: OptionsField(
                hint: "Select your industry",
                text: industry?.name,
                suffixIcon: const RightChevron(),
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return "Select your industry";
                  }
                  return apiError?.forKey('industry');
                },
                onTap: () async {
                  final res = await push(
                    context: context,
                    builder: (_) => CompanyIndustries(selected: industry),
                    rootNavigator: true,
                  );
                  if (res != null && res is Industry) {
                    setState(() {
                      industry = res;
                    });
                  }
                },
              ),
            ),
            // FormInput(
            //   title: const Text("Company Size"),
            //   child: OptionsField(
            //     hint: "Select your company size",
            //     text: companySize.name.sentenceCase,
            //     validator: (value) {
            //       if (value?.isEmpty ?? false) {
            //         return "Select your company size";
            //       }
            //       return apiError?.forKey('company_size');
            //     },
            //     onTap: () async {
            //       final res = await showAppBottomSheet<OrganizationType>(
            //         context: context,
            //         title: "Company Size",
            //         children: (context) {
            //           return [
            //             ...[
            //               ...[...CompanySize.values]
            //                 ..remove(CompanySize.unknown)
            //             ].map((type) {
            //               return RadioListTile<CompanySize>(
            //                 value: type,
            //                 groupValue: companySize,
            //                 visualDensity: VisualDensity.compact,
            //                 title: Text(type.name.sentenceCase),
            //                 activeColor: context.colorScheme.secondary,
            //                 onChanged: (value) {
            //                   rootNavigator(context).pop(type);
            //                 },
            //               );
            //             }),
            //             VSizedBox8,
            //           ];
            //         },
            //       );
            //       if (res != null) {
            //         setState(() {
            //           organizationType = res;
            //         });
            //       }
            //     },
            //   ),
            // ),
            FormInput(
              title: const Text("Description"),
              child: TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                minLines: 1,
                maxLines: null,
                // autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Describe your company in a few lines",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Description is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Company Values"),
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
                  child: companyValues.isEmpty
                      ? Row(
                          children: [
                            Text(
                              "Select up to 6 values",
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
                          runSpacing: 0,
                          children: companyValues
                              .map((v) => RawChip(label: Text(v.name ?? '')))
                              .toList(),
                        ),
                ),
                onTap: () async {
                  final res = await push(
                    context: context,
                    builder: (_) => CompanyValues(selected: companyValues),
                    rootNavigator: true,
                  );
                  if (res != null && res is List<CompanyValue>) {
                    setState(() {
                      companyValues = res;
                    });
                  }
                },
              ),
            ),
            FormInput(
              title: const Text("Email"),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your company email",
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
            // FormInput(
            //   title: const Text("Phone number"),
            //   child: TextFormField(
            //     controller: phoneController,
            //     keyboardType: TextInputType.phone,
            //     autocorrect: false,
            //     autofillHints: const [AutofillHints.telephoneNumber],
            //     autovalidateMode: AutovalidateMode.onUserInteraction,
            //     decoration: const InputDecoration(
            //       hintText: "Your company phone number",
            //     ),
            //     validator: (v) {
            //       if (v!.isEmpty) return null;
            //       if (!RegExp(r'^\+?1?\d{9,15}$').hasMatch(v)) {
            //         return "Enter a valid phone number";
            //       }
            //       return null;
            //     },
            //     onChanged: (_) => setState(() {
            //       errorMessage = null;
            //     }),
            //   ),
            // ),
            FormInput(
              title: const Text("Website"),
              child: TextFormField(
                controller: websiteController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                autofillHints: const [AutofillHints.url],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your company website",
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
            child: const Text("Save"),
            onPressed: () {
              submit();
            },
          ),
        ),
      ),
    );
  }

  void submit() async {
    errorMessage = null;
    apiError = null;
    final userProvider = context.read<UserProvider>();
    final companyProvider = context.read<CompanyProvider>();
    if (mounted) setState(() {});
    if (!formKey.currentState!.validate()) return;
    final input = Company(
      id: widget.company?.id,
      xrpAddress: companyProvider.user?.id,
      name: nameController.text,
      description: descriptionController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      tagline: taglineController.text,
      website: websiteController.text,
      organizationType: organizationType,
      companySize: companySize,
      howYouFoundUs: howYouFoundUs,
      values: companyValues,
      industry: industry,
    );
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Setting up",
      request: isEditing
          ? companyProvider.updateCompany(widget.company!.id!, input)
          : companyProvider.createCompany(input),
      onError: (context) {
        setState(() => errorMessage = 'An error occurred');
      },
      onApiError: (context, error) {
        setState(() => apiError = error);
        formKey.currentState!.validate();
      },
      onSuccess: (context, res) async {
        ProviderRequest.api(
          context: context,
          request: userProvider.getUserMe(),
          onSuccess: (context, res) {
            if (isEditing) {
              Navigator.pop(context);
            } else {
              rootNavigator(context).pushNamedAndRemoveUntil(
                  userProvider.getRouteForUser(res.data), (_) => false);
            }
          },
        );
      },
    );
  }
}
