import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/forms/options_field.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerExperienceCreate extends StatefulWidget {
  final WorkExperience? workExperience;
  const FreelancerExperienceCreate({
    super.key,
    this.workExperience,
  });

  @override
  State<FreelancerExperienceCreate> createState() =>
      _FreelancerExperienceCreateState();
}

class _FreelancerExperienceCreateState
    extends State<FreelancerExperienceCreate> {
  final formKey = GlobalKey<FormState>();
  final jobTitleController = TextEditingController();
  final companyNameController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  bool currentlyWorkingHere = true;
  ApiError? apiError;
  String? errorMessage;
  DateTime? startDate;
  DateTime? endDate;

  bool get isEditing => widget.workExperience != null;

  Freelancer? get freelancer {
    final provider = context.read<UserProvider>();
    return provider.user?.freelancer;
  }

  @override
  void initState() {
    super.initState();
    final w = widget.workExperience;
    if (w != null) {
      jobTitleController.text = w.jobTitle ?? "";
      companyNameController.text = w.companyName ?? "";
      jobDescriptionController.text = w.jobDescription ?? "";
      startDateController.text = w.startDate?.toIso8601String() ?? "";
      endDateController.text = w.endDate?.toIso8601String() ?? "";
      currentlyWorkingHere = w.currentlyWorkingHere ?? false;
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
          title: const Text("Work Experience"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormInput(
              title: const Text("Job Title"),
              child: TextFormField(
                controller: jobTitleController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textCapitalization: TextCapitalization.words,
                // maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "eg. Software Engineer",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Job Title is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Company Name"),
              child: TextFormField(
                controller: companyNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "eg. Google",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Company Name is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Job Description"),
              child: TextFormField(
                controller: jobDescriptionController,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                minLines: 1,
                maxLines: null,
                // autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Describe your role and responsibilities",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Job Description is required";
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
                text: formatDate(startDate, format: 'MMMM y'),
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
            ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              title: const Text("Currently working here"),
              trailing: CupertinoSwitch(
                value: currentlyWorkingHere,
                onChanged: (value) {
                  setState(() {
                    currentlyWorkingHere = value;
                  });
                },
              ),
            ),
            if (!currentlyWorkingHere)
              FormInput(
                title: const Text("End Date"),
                child: OptionsField(
                  hint: "End Date",
                  text: formatDate(endDate, format: 'MMMM y'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () async {
                    final res = await showDatePicker(
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      context: context,
                      helpText: "End Date",
                      initialDate: endDate ?? now,
                      firstDate: now.subtract(const Duration(days: 365 * 90)),
                      lastDate: now,
                    );
                    if (res != null) {
                      setState(() {
                        endDate = res;
                      });
                    }
                  },
                  validator: (v) {
                    if (!currentlyWorkingHere && v!.isEmpty) {
                      return "End Date is required";
                    }
                    return null;
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            onPressed: submit,
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
    final input = WorkExperience(
      id: widget.workExperience?.id,
      freelancer: freelancer?.id,
      jobTitle: jobTitleController.text,
      companyName: companyNameController.text,
      jobDescription: jobDescriptionController.text,
      startDate: startDate,
      endDate: endDate,
      currentlyWorkingHere: currentlyWorkingHere,
    );
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Saving",
      request: isEditing
          ? freelancerProvider.updateFreelancerWorkExperience(
              widget.workExperience!.id!,
              input,
            )
          : freelancerProvider.createFreelancerWorkExperience(
              input,
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
