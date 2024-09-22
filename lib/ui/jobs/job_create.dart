import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/freelancer/freelancer_skills.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/forms/options_field.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class JobCreate extends StatefulWidget {
  final Job? job;
  const JobCreate({super.key, this.job});

  @override
  State<JobCreate> createState() => _JobCreateState();
}

class _JobCreateState extends State<JobCreate> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final externalApplyLinkController = TextEditingController();
  final priceController = TextEditingController();
  // final minPriceController = TextEditingController();
  // final maxPriceController = TextEditingController();
  final addressController = TextEditingController();
  final responsibilitiesController = TextEditingController();
  final experienceController = TextEditingController();
  PriceType priceType = PriceType.perProject;
  JobLocation jobLocation = JobLocation.remote;
  JobApplicationType applicationType = JobApplicationType.internal;
  JobStatus jobStatus = JobStatus.active;
  JobRoleType roleType = JobRoleType.fullTime;
  List<Tag> selectedTags = [];
  ApiError? apiError;
  String? errorMessage;
  List<Skill> skills = [];
  String currency = "USD";

  bool get isEditing => widget.job != null;

  @override
  void initState() {
    if (widget.job != null) {
      final j = widget.job!;
      skills = j.skills;
      titleController.text = j.title ?? "";
      descriptionController.text = j.description ?? "";
      externalApplyLinkController.text = j.externalApplyLink ?? "";
      currency = j.currency ?? "USD";
      priceController.text = j.price ?? "";
      // minPriceController.text = j.minPrice ?? "";
      // maxPriceController.text = j.maxPrice ?? "";
      addressController.text = j.address ?? "";
      responsibilitiesController.text = j.responsibilities ?? "";
      experienceController.text = j.experience ?? "";
      if (j.priceType != null) priceType = j.priceType!;
      if (j.location != null) jobLocation = j.location!;
      if (j.applicationType != null) applicationType = j.applicationType!;
      if (j.status != null) jobStatus = j.status!;
      if (j.roleType != null) roleType = j.roleType!;
      // if (j.tags != null && j.tags!.isNotEmpty) {
      //   selectedTags = j.tags!.map((e) => Tag(id: e)).toList();
      // }
      if (mounted) setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final appProvider = context.watch<AppProvider>();
    // final currencies = appProvider.currencies;

    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        appBar: AppBar(
          title: Text("${isEditing ? 'Edit' : 'New'} Job Listing"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormInput(
              title: const Text("Job Title"),
              child: TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "What's the role name?",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Job title is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FormInput(
                    title: const Text("Work Style"),
                    child: OptionsField(
                      hint: "Select style",
                      text: jobLocation.name.sentenceCase,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return "Work style is required";
                        }
                        return apiError?.forKey('location');
                      },
                      onTap: () async {
                        final res = await showAppBottomSheet<JobLocation>(
                          context: context,
                          title: "Work Style",
                          children: (context) {
                            return [
                              ...JobLocation.values.map((type) {
                                return RadioListTile<JobLocation>(
                                  value: type,
                                  groupValue: jobLocation,
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
                            jobLocation = res;
                          });
                        }
                      },
                    ),
                  ),
                ),
                HSizedBox16,
                Expanded(
                  child: FormInput(
                    title: const Text("Role Type"),
                    child: OptionsField(
                      hint: "Select type",
                      text: roleType.name.sentenceCase,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return "Select role type";
                        }
                        return apiError?.forKey('role_type');
                      },
                      onTap: () async {
                        final res = await showAppBottomSheet<JobRoleType>(
                          context: context,
                          title: "Role Type",
                          children: (context) {
                            return [
                              ...JobRoleType.values.map((type) {
                                return RadioListTile<JobRoleType>(
                                  value: type,
                                  groupValue: roleType,
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
                            roleType = res;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (jobLocation == JobLocation.onsite)
              FormInput(
                title: const Text("Location"),
                child: TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Where will they work?",
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return "Job address is required";
                    return null;
                  },
                  onChanged: (_) => setState(() {
                    errorMessage = null;
                  }),
                ),
              ),
            FormInput(
              title: const Text("Compensation Frequency"),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded(
                  //   child: OptionsField(
                  //     hint: "Currency",
                  //     text: currency,
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     onTap: () async {
                  //       final res = await showAppBottomSheet<Currency?>(
                  //         context: context,
                  //         title: "Currency",
                  //         children: (context) {
                  //           return currencies.map((c) {
                  //             return RadioListTile(
                  //               title: Text(c.code ?? ""),
                  //               value: c.code,
                  //               groupValue: currency,
                  //               onChanged: (_) {
                  //                 Navigator.pop(context, c);
                  //               },
                  //             );
                  //           }).toList();
                  //         },
                  //       );
                  //       if (res != null) {
                  //         setState(() => currency = res.code ?? "");
                  //       }
                  //     },
                  //     validator: (v) {
                  //       if (v!.isEmpty) return "Currency required";
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  // HSizedBox16,
                  Expanded(
                    child: OptionsField(
                      hint: "Select frequency",
                      text: priceType.name.sentenceCase,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return "Select frequency";
                        }
                        return apiError?.forKey('price_type');
                      },
                      onTap: () async {
                        final res = await showAppBottomSheet<PriceType>(
                          context: context,
                          title: "Compensation Frequency",
                          children: (context) {
                            return [
                              ...PriceType.values.map((type) {
                                return RadioListTile<PriceType>(
                                  value: type,
                                  groupValue: priceType,
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
                            priceType = res;
                            apiError?.details?.remove('price');
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            FormInput(
              title: const Text("Compensation"),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'([0-9]+)')),
                      ],
                      decoration: InputDecoration(
                        hintText: "0.00",
                        prefixIcon: Container(
                          width: 80,
                          padding: ContentPaddingH,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "USD",
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),
                      validator: (v) {
                        // if (v!.isEmpty) return "Base amount is required";
                        return null;
                      },
                      onChanged: (_) => setState(() {
                        errorMessage = null;
                      }),
                    ),
                  ),
                  // if (priceType != PriceType.perProject) ...[
                  //   HSizedBox8,
                  //   const Text(
                  //     "–",
                  //     style: TextStyle(fontSize: 38, height: 1.2),
                  //   ),
                  //   HSizedBox8,
                  //   Expanded(
                  //     child: TextFormField(
                  //       enabled: minPriceController.text.isNotEmpty,
                  //       controller: maxPriceController,
                  //       keyboardType: TextInputType.number,
                  //       textInputAction: TextInputAction.next,
                  //       autocorrect: false,
                  //       autovalidateMode: AutovalidateMode.onUserInteraction,
                  //       inputFormatters: [
                  //         FilteringTextInputFormatter.allow(
                  //             RegExp(r'([0-9]+)')),
                  //       ],
                  //       decoration: const InputDecoration(
                  //         hintText: "Max amount",
                  //       ),
                  //       // validator: (v) {
                  //       //   if (v!.isEmpty) return "Amount is required";
                  //       //   return null;
                  //       // },
                  //       onChanged: (_) => setState(() {
                  //         errorMessage = null;
                  //       }),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
            // FormInput(
            //   title: const Text("Tags"),
            //   child: MultiSelectChip<Tag>(
            //     items: jobProvider.tags,
            //     selectedItems: selectedTags,
            //     labelBuilder: (context, item) {
            //       return Text(item.name ?? "");
            //     },
            //     onChanged: (items) {
            //       setState(() {
            //         selectedTags = items;
            //       });
            //     },
            //     validator: (items) {
            //       if (items?.isEmpty ?? true) {
            //         return "Select at least one tag";
            //       }
            //       return null;
            //     },
            //   ),
            // ),
            FormInput(
              title: const Text("Overview"),
              child: TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                minLines: 1,
                maxLines: null,
                // autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Briefly talk about the role",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Job description is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Responsibilities"),
              child: TextFormField(
                controller: responsibilitiesController,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                minLines: 1,
                maxLines: null,
                // autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Describe what they'll do",
                ),
                validator: (v) {
                  // if (v!.isEmpty) return "Job responsibilities is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Experience"),
              child: TextFormField(
                controller: experienceController,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                minLines: 1,
                maxLines: null,
                // autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Describe their requirements",
                ),
                validator: (v) {
                  // if (v!.isEmpty) return "Job experience is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),

            FormInput(
              title: const Text("Application Type"),
              child: OptionsField(
                hint: "Select application type",
                text: applicationType.name.sentenceCase,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return "Select application type";
                  }
                  return apiError?.forKey('application_type');
                },
                onTap: () async {
                  final res = await showAppBottomSheet<JobApplicationType>(
                    context: context,
                    title: "Application Type",
                    children: (context) {
                      return [
                        ...JobApplicationType.values.map((type) {
                          return RadioListTile<JobApplicationType>(
                            value: type,
                            groupValue: applicationType,
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
                      applicationType = res;
                    });
                  }
                },
              ),
            ),
            if (applicationType == JobApplicationType.external)
              FormInput(
                title: const Text("External Apply Link"),
                child: TextFormField(
                  controller: externalApplyLinkController,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.url],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Enter job apply link",
                  ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "External Apply Link is required";
                    }
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
            if (isEditing)
              FormInput(
                title: const Text("Status"),
                child: OptionsField(
                  hint: "Select job status",
                  text: jobStatus.name.sentenceCase,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return "Select job status";
                    }
                    return apiError?.forKey('status');
                  },
                  onTap: () async {
                    final res = await showAppBottomSheet<JobStatus>(
                      context: context,
                      title: "Job Status",
                      children: (context) {
                        return [
                          ...JobStatus.values.map((type) {
                            return RadioListTile<JobStatus>(
                              value: type,
                              groupValue: jobStatus,
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
                        jobStatus = res;
                      });
                    }
                  },
                ),
              ),
            VSizedBox16
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            onPressed: skills.isEmpty ? null : submit,
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
    final companyProvider = context.read<CompanyProvider>();
    final jobProvider = context.read<JobProvider>();
    if (mounted) setState(() {});
    if (!formKey.currentState!.validate()) return;
    final input = Job(
      id: widget.job?.id,
      title: titleController.text.trim(),
      company: userProvider.user?.company,
      description: descriptionController.text.trim(),
      externalApplyLink: externalApplyLinkController.text.trim(),
      priceType: priceType,
      price: double.tryParse(priceController.text.trim())?.toString(),
      // maxPrice: double.tryParse(maxPriceController.text.trim())?.toString(),
      // minPrice: double.tryParse(minPriceController.text.trim())?.toString(),
      location: jobLocation,
      applicationType: applicationType,
      status: jobStatus,
      address: addressController.text.trim(),
      roleType: roleType,
      responsibilities: responsibilitiesController.text.trim(),
      experience: experienceController.text.trim(),
      tags: selectedTags.map((e) => e.id!).toList(),
      skills: skills,
      currency: currency,
    );
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Saving Job",
      request: isEditing
          ? jobProvider.updateJob(widget.job!.id!, input)
          : jobProvider.createJob(input),
      // onError: (context) {
      //   setState(() => errorMessage = 'An error occurred');
      // },
      // onApiError: (context, error) {
      //   setState(() => apiError = error);
      //   formKey.currentState!.validate();
      // },
      onSuccess: (context, res) async {
        final companyId = jobProvider.user?.company?.id;
        if (isEditing) jobProvider.getJob(widget.job!.id!);
        jobProvider.getJobs(mapId: companyId, params: {"company": companyId});
        if (companyId != null) companyProvider.getCompany(companyId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Job saved"),
          ));
          rootNavigator(context).pop();
        }
      },
    );
  }
}
