import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:tugela/models/job_application.dart';
import 'package:tugela/models/job_submission.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/forms/options_field.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class ApplicationSubmission extends StatefulWidget {
  final JobApplication application;
  const ApplicationSubmission({
    super.key,
    required this.application,
  });

  @override
  State<ApplicationSubmission> createState() => _ApplicationSubmissionState();
}

class _ApplicationSubmissionState extends State<ApplicationSubmission> {
  final formKey = GlobalKey<FormState>();
  final projectUrlController = TextEditingController();
  XFile? file;

  @override
  void initState() {
    super.initState();
    final provider = context.read<JobProvider>();
    final mapId = widget.application.id ?? "";
    provider.getJobSubmissions(
      mapId: mapId,
      params: {"application": mapId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final application = widget.application;
    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        pageAppBar: const PageAppBar(
          largeTitle: Text("Job Submission"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          children: [
            FormInput(
              title: const Text("Document"),
              child: OptionsField(
                hint: "Choose file",
                text: path.basename(file?.path ?? ""),
                validator: (v) {
                  if (v!.isEmpty && projectUrlController.text.isEmpty) {
                    return "File is required";
                  }
                  return null;
                },
                onTap: () async {
                  final res = await openFile(
                    acceptedTypeGroups: [
                      imagesTypeGroup,
                      pdfTypeGroup,
                      docTypeGroup,
                    ],
                  );
                  if (res != null) {
                    file = res;
                    if (mounted) setState(() {});
                  }
                },
              ),
            ),
            FormInput(
              title: const Text("Project link"),
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
                  if (!urlRegex.hasMatch(v!) && file == null) {
                    return "Enter a valid url";
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            onPressed: () async {
              dio.MultipartFile? multipart;
              try {
                if (formKey.currentState?.validate() ?? false) {
                  multipart = file == null
                      ? null
                      : await multipartFileFromPath(file!.path, field: "file");
                }
              } on PathNotFoundException catch (e, s) {
                handleError(e, stackTrace: s);
                final res = await openFile(
                  acceptedTypeGroups: [
                    imagesTypeGroup,
                    pdfTypeGroup,
                    docTypeGroup,
                  ],
                );
                if (res != null) {
                  file = res;
                  if (mounted) setState(() {});
                }
              }
              if (!(formKey.currentState?.validate() ?? false)) return;
              if (!context.mounted) return;
              ProviderRequest.api(
                context: context,
                request: jobProvider.createJobSubmission(
                  JobSubmission(
                    application: application,
                    freelancer: application.freelancer,
                    link: projectUrlController.text,
                  ),
                  multipart,
                ),
                onSuccess: (context, result) {
                  final mapId = application.id ?? "";
                  jobProvider.getJobSubmissions(
                    mapId: mapId,
                    params: {"application": mapId},
                  );
                  Navigator.pop(context);
                },
              );
            },
            child: const Text("Continue"),
          ),
        ),
      ),
    );
  }
}
