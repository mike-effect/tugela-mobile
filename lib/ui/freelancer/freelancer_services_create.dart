import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/freelancer_provider.dart';
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

class FreelancerServiceCreate extends StatefulWidget {
  final FreelancerService? service;
  const FreelancerServiceCreate({
    super.key,
    this.service,
  });

  @override
  State<FreelancerServiceCreate> createState() =>
      _FreelancerServiceCreateState();
}

class _FreelancerServiceCreateState extends State<FreelancerServiceCreate> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deliveryTimeController = TextEditingController();
  final startingPriceController = TextEditingController();
  Category? category;
  List<Skill> skills = [];
  String currency = "USD";
  PriceType priceType = PriceType.perProject;
  DeliveryDuration duration = DeliveryDuration.week;
  ApiError? apiError;
  String? errorMessage;

  bool get isEditing => widget.service != null;

  Freelancer? get freelancer {
    final provider = context.read<UserProvider>();
    return provider.user?.freelancer;
  }

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    if (s != null) {
      titleController.text = s.title ?? "";
      descriptionController.text = s.description ?? "";
      deliveryTimeController.text = s.deliveryTime ?? "";
      startingPriceController.text = s.startingPrice ?? "";
      currency = s.currency ?? "";
      priceType = s.priceType ?? PriceType.perProject;
      // category = s.category;
      // skills = s.skills;
    }
    if (mounted) setState(() {});
    context.read<AppProvider>().getCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final currencies = appProvider.currencies;

    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        appBar: AppBar(
          title: const Text("Service"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormInput(
              title: const Text("Title"),
              child: TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "eg. Mobile App Development",
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
                  hintText: "Describe this service",
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
            // FormInput(
            //   title: const Text("Category"),
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.opaque,
            //     child: Container(
            //       width: double.infinity,
            //       padding: ContentPadding,
            //       decoration: BoxDecoration(
            //         borderRadius: AppTheme.formBorderRadius,
            //         border: Border.all(
            //           color: context.inputTheme.enabledBorder!.borderSide.color,
            //         ),
            //       ),
            //       child: category == null
            //           ? Row(
            //               children: [
            //                 Text(
            //                   "Select a category",
            //                   style: TextStyle(
            //                     fontSize: 15,
            //                     color: context.textTheme.bodySmall?.color,
            //                   ),
            //                 ),
            //                 Space,
            //                 const RightChevron(),
            //               ],
            //             )
            //           : Row(
            //               children: [
            //                 Text(category?.name ?? ''),
            //                 Space,
            //                 const RightChevron(),
            //               ],
            //             ),
            //     ),
            //     onTap: () async {
            //       final res = await push(
            //         context: context,
            //         builder: (_) => const FreelancerCategories(),
            //         rootNavigator: true,
            //       );
            //       if (res != null && res is Category) {
            //         setState(() {
            //           category = res;
            //         });
            //       }
            //     },
            //   ),
            // ),
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
            FormInput(
              title: const Text("Delivery Time"),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: OptionsField(
                      hint: "Period",
                      text: pluralFor(
                        duration.name.sentenceCase,
                        count: int.tryParse(deliveryTimeController.text) ?? 0,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTap: () async {
                        final res = await showAppBottomSheet(
                          context: context,
                          title: "Delivery Period",
                          physics: const NeverScrollableScrollPhysics(),
                          children: (context) {
                            return DeliveryDuration.values.map((p) {
                              return RadioListTile<DeliveryDuration>(
                                value: p,
                                groupValue: duration,
                                visualDensity: VisualDensity.compact,
                                title: Text(p.name.sentenceCase),
                                activeColor: context.colorScheme.secondary,
                                onChanged: (value) {
                                  rootNavigator(context).pop(p);
                                },
                              );
                            }).toList();
                          },
                        );
                        if (res != null) {
                          setState(() {
                            duration = res;
                          });
                        }
                      },
                    ),
                  ),
                  HSizedBox16,
                  Expanded(
                    child: TextFormField(
                      controller: deliveryTimeController,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'([0-9]+)'))
                      ],
                      decoration: InputDecoration(
                        hintText: "Number of ${pluralFor(
                          duration.name,
                          count: int.tryParse(deliveryTimeController.text) ?? 0,
                        )}",
                      ),
                      validator: (v) {
                        if (double.tryParse(v ?? "0") == 0) {
                          return "Enter a number above 0";
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
            ),
            FormInput(
              title: const Text("Starting Price"),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: OptionsField(
                      hint: "Currency",
                      text: currency,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTap: () async {
                        final res = await showAppBottomSheet<Currency?>(
                          context: context,
                          title: "Currency",
                          children: (context) {
                            return currencies.map((c) {
                              return RadioListTile(
                                title: Text(c.code ?? ""),
                                value: c.code,
                                groupValue: currency,
                                onChanged: (_) {
                                  Navigator.pop(context, c);
                                },
                              );
                            }).toList();
                          },
                        );
                        if (res != null) {
                          setState(() => currency = res.code ?? "");
                        }
                      },
                      validator: (v) {
                        if (v!.isEmpty) return "Currency required";
                        return null;
                      },
                    ),
                  ),
                  HSizedBox16,
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: startingPriceController,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: "0.00",
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Starting Price is required";
                        return null;
                      },
                      onChanged: (_) => setState(() {
                        errorMessage = null;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            FormInput(
              title: const Text("Price Type"),
              child: OptionsField(
                hint: "Price Type",
                text: priceType.name.sentenceCase,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTap: () async {
                  final res = await showAppBottomSheet(
                    context: context,
                    title: "Pricing",
                    physics: const NeverScrollableScrollPhysics(),
                    children: (context) {
                      return PriceType.values.map((p) {
                        return RadioListTile<PriceType>(
                          value: p,
                          groupValue: priceType,
                          visualDensity: VisualDensity.compact,
                          title: Text(p.name.sentenceCase),
                          activeColor: context.colorScheme.secondary,
                          onChanged: (value) {
                            rootNavigator(context).pop(p);
                          },
                        );
                      }).toList();
                    },
                  );
                  if (res != null) {
                    setState(() {
                      priceType = res;
                    });
                  }
                },
                validator: (v) {
                  if (v!.isEmpty) return "Price Type is required";
                  return null;
                },
              ),
            ),
            // FormInput(
            //   title: const Text("Service Image"),
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.opaque,
            //     child: Container(
            //       width: double.infinity,
            //       padding: ContentPadding,
            //       decoration: BoxDecoration(
            //         borderRadius: AppTheme.formBorderRadius,
            //         border: Border.all(
            //           color: context.inputTheme.enabledBorder!.borderSide.color,
            //         ),
            //       ),
            //       child: serviceImage == null
            //           ? Row(
            //               children: [
            //                 Text(
            //                   "Select an image",
            //                   style: TextStyle(
            //                     fontSize: 15,
            //                     color: context.textTheme.bodySmall?.color,
            //                   ),
            //                 ),
            //                 Space,
            //                 const RightChevron(),
            //               ],
            //             )
            //           : Row(
            //               children: [
            //                 Text(serviceImage?.name ?? ''),
            //                 Space,
            //                 const RightChevron(),
            //               ],
            //             ),
            //     ),
            //     onTap: () async {
            //       final res = await FilePicker.platform.pickFiles(
            //         type: FileType.image,
            //       );
            //       if (res != null) {
            //         setState(() {
            //           serviceImage = res.files.first;
            //         });
            //       }
            //     },
            //   ),
            // ),
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
    final freelancerProvider = context.read<FreelancerProvider>();
    if (mounted) setState(() {});
    if (!formKey.currentState!.validate()) return;
    final input = FreelancerService(
      id: widget.service?.id,
      freelancer: freelancer?.id,
      title: titleController.text,
      description: descriptionController.text,
      category: category?.id,
      skills: skills.map((e) => e.id ?? "").where((e) => e.isNotEmpty).toList(),
      deliveryTime: "${deliveryTimeController.text} ${pluralFor(
        duration.name,
        count: int.tryParse(deliveryTimeController.text) ?? 0,
      )}",
      startingPrice: startingPriceController.text,
      currency: currency,
      priceType: priceType,
    );
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Saving",
      request: isEditing
          ? freelancerProvider.updateFreelancerService(
              widget.service!.id!,
              input,
              // serviceImage: serviceImage,
            )
          : freelancerProvider.createFreelancerService(
              input,
              // serviceImage: serviceImage,
            ),
      onError: (context) {
        setState(() => errorMessage = 'An error occurred');
      },
      onApiError: (context, error) {
        setState(() => apiError = error);
        formKey.currentState!.validate();
      },
      onSuccess: (context, res) async {
        context.read<UserProvider>().getUserMe();
        Navigator.pop(context, true);
      },
    );
  }
}
