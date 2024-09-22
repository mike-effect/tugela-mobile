import 'package:flutter/material.dart';
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
import 'package:tugela/widgets/forms/options_field.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerPortfolioCreate extends StatefulWidget {
  final PortfolioItem? portfolioItem;
  const FreelancerPortfolioCreate({
    super.key,
    this.portfolioItem,
  });

  @override
  State<FreelancerPortfolioCreate> createState() =>
      _FreelancerPortfolioCreateState();
}

class _FreelancerPortfolioCreateState extends State<FreelancerPortfolioCreate> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final projectUrlController = TextEditingController();
  final videoUrlController = TextEditingController();
  Category? category;
  List<Skill> skills = [];
  // PlatformFile? portfolioFile;
  ApiError? apiError;
  String? errorMessage;
  DateTime? startDate;
  DateTime? endDate;

  bool get isEditing => widget.portfolioItem != null;

  Freelancer? get freelancer {
    final provider = context.read<UserProvider>();
    return provider.user?.freelancer;
  }

  @override
  void initState() {
    super.initState();
    final p = widget.portfolioItem;
    if (p != null) {
      titleController.text = p.title ?? "";
      descriptionController.text = p.description ?? "";
      projectUrlController.text = p.projectUrl ?? "";
      videoUrlController.text = p.videoUrl ?? "";
      startDate = p.startDate;
      endDate = p.endDate;
      // category = p.category;
      // skills = p.skills;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        appBar: AppBar(
          title: const Text("Project"),
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
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "eg. Mobile App Redesign",
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
                  hintText: "Describe this portfolio item",
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
              title: const Text("Project Link"),
              child: TextFormField(
                controller: projectUrlController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                autofillHints: const [AutofillHints.url],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "https://",
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
            FormInput(
              title: const Text("Video Link"),
              child: TextFormField(
                controller: videoUrlController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                autofillHints: const [AutofillHints.url],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "https://",
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
            FormInput(
              title: const Text("Start Date"),
              child: OptionsField(
                hint: "Start Date",
                text: formatDate(startDate, format: 'MMMM d, y'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTap: () async {
                  final res = await showDatePicker(
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    context: context,
                    helpText: "Start Date",
                    initialDate: startDate ?? now,
                    lastDate: now,
                    firstDate: now.subtract(const Duration(days: 365 * 90)),
                  );
                  if (res != null) {
                    setState(() {
                      startDate = res;
                    });
                  }
                },
                validator: (v) {
                  if (v!.isEmpty) return "Start Date is required";
                  return null;
                },
              ),
            ),
            FormInput(
              title: const Text("End Date"),
              child: OptionsField(
                hint: "End Date",
                text: formatDate(endDate, format: 'MMMM d, y'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTap: () async {
                  final res = await showDatePicker(
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (res != null) {
                    setState(() {
                      endDate = res;
                    });
                  }
                },
                validator: (v) {
                  // if (v!.isEmpty) return "End Date is required";
                  return null;
                },
              ),
            ),
            // FormInput(
            //   title: const Text("Portfolio File"),
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
            //       child: portfolioFile == null
            //           ? Row(
            //               children: [
            //                 Text(
            //                   "Select a file",
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
            //                 Text(portfolioFile?.name ?? ''),
            //                 Space,
            //                 const RightChevron(),
            //               ],
            //             ),
            //     ),
            //     onTap: () async {
            //       final res = await FilePicker.platform.pickFiles();
            //       if (res != null) {
            //         setState(() {
            //           portfolioFile = res.files.first;
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
    final input = PortfolioItem(
      id: widget.portfolioItem?.id,
      freelancer: freelancer?.id,
      title: titleController.text,
      description: descriptionController.text,
      category: category?.id,
      skills: skills,
      projectUrl: projectUrlController.text,
      videoUrl: videoUrlController.text,
      startDate: startDate,
      endDate: endDate,
    );
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Saving",
      request: isEditing
          ? freelancerProvider.updateFreelancerPortfolioItem(
              widget.portfolioItem!.id!,
              input,
              // portfolioFile: portfolioFile,
            )
          : freelancerProvider.createFreelancerPortfolioItem(
              input,
              // portfolioFile: portfolioFile,
            ),
      // onError: (context) {
      //   setState(() => errorMessage = 'An error occurred');
      // },
      // onApiError: (context, error) {
      //   setState(() => apiError = error);
      //   formKey.currentState!.validate();
      // },
      onSuccess: (context, res) async {
        context.read<UserProvider>().getUserMe();
        Navigator.pop(context, true);
      },
    );
  }
}
