import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/settings/settings_payments_topup.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_scope.dart';

class ApplicationAcceptance extends StatefulWidget {
  final JobApplication application;
  const ApplicationAcceptance({super.key, required this.application});

  @override
  State<ApplicationAcceptance> createState() => _ApplicationAcceptanceState();
}

class _ApplicationAcceptanceState extends State<ApplicationAcceptance> {
  final formKey = GlobalKey<FormState>();
  final projectUrlController = TextEditingController();
  int _index = 0;
  double stepIconSize = 30;
  // XFile? file;

  JobApplication get application => widget.application;

  double get compensation {
    return double.tryParse(application.job?.price ?? "0") ?? 0;
  }

  bool get validBalance {
    final userProvider = context.read<UserProvider>();
    final b = userProvider.balance?.xrpBalance ?? 0;
    return b >= compensation;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final balance = userProvider.balance?.xrpBalance ?? 0;

    const stepperTitleStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
    const stepperContentStyle = TextStyle(
      fontSize: 15,
    );

    return FormScope(
      formKey: formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Accept Application"),
        ),
        body: Stepper(
          currentStep: _index,
          physics: const ClampingScrollPhysics(),
          stepIconHeight: stepIconSize,
          stepIconWidth: stepIconSize,
          stepIconBuilder: (stepIndex, stepState) {
            return CircleAvatar(
              backgroundColor: stepState == StepState.complete
                  ? AppColors.green
                  : AppColors.greyElevatedBackgroundColor(context),
              foregroundColor: stepState == StepState.complete
                  ? AppColors.white
                  : context.theme.textTheme.bodyMedium?.color,
              child: stepState == StepState.complete
                  ? const Icon(Icons.check, size: 22)
                  : Text(
                      "${stepIndex + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            );
          },
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            proceed(_index);
          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: <Widget>[
                  if (validBalance)
                    ElevatedButton(
                      style: AppTheme.compactElevatedButtonStyle(context),
                      onPressed: details.onStepContinue,
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  else
                    ElevatedButton(
                      style: AppTheme.compactElevatedButtonStyle(context),
                      onPressed: () {
                        push(
                          context: context,
                          rootNavigator: true,
                          builder: (_) => const SettingsPaymentsTopup(),
                        );
                      },
                      child: const Text(
                        'Top up',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  if (details.stepIndex > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                ],
              ),
            );
          },
          steps: <Step>[
            Step(
              state: validBalance ? StepState.complete : StepState.indexed,
              title: const Text(
                'XRP Wallet Balance',
                style: stepperTitleStyle,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "To assign this job, you need to have enough balance in your wallet for "
                    "${formatAmount(compensation, symbol: application.job?.currency)}. "
                    "The job compensation will be escrowed until the job has been marked completed, and the funds will be released to the freelancer automatically.",
                    style: stepperContentStyle,
                  ),
                  VSizedBox12,
                  Container(
                    width: double.infinity,
                    padding: ContentPadding * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.greyElevatedBackgroundColor(context),
                    ),
                    child: Text(
                      "Current balance: ${formatAmount(balance, symbol: "XRP", isCrypto: true)}",
                    ),
                  ),
                ],
              ),
            ),
            // Step(
            //   state: validBalance ? StepState.indexed : StepState.disabled,
            //   title: const Text(
            //     'Attachments',
            //     style: stepperTitleStyle,
            //   ),
            //   content: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Upload a file (image or document) of the contract and add a link to the project. The freelancer will need to have access to the link.',
            //         style: stepperContentStyle,
            //       ),
            //       VSizedBox24,
            //       FormInput(
            //         title: const Text("Document"),
            //         child: OptionsField(
            //           hint: "Choose file",
            //           text: path.basename(file?.path ?? ""),
            //           validator: (v) {
            //             if (v!.isEmpty) return "File is required";
            //             return null;
            //           },
            //           onTap: () async {
            //             final res = await openFile(
            //               acceptedTypeGroups: [
            //                 imagesTypeGroup,
            //                 pdfTypeGroup,
            //                 docTypeGroup,
            //               ],
            //             );
            //             if (res != null) {
            //               file = res;
            //               if (mounted) setState(() {});
            //             }
            //           },
            //         ),
            //       ),
            //       FormInput(
            //         title: const Text("Project link"),
            //         child: TextFormField(
            //           controller: projectUrlController,
            //           keyboardType: TextInputType.url,
            //           autocorrect: false,
            //           autofillHints: const [AutofillHints.url],
            //           autovalidateMode: AutovalidateMode.onUserInteraction,
            //           decoration: const InputDecoration(
            //             hintText: "https://",
            //           ),
            //           validator: (v) {
            //             if (!urlRegex.hasMatch(v!)) {
            //               return "Enter a valid url";
            //             }
            //             return null;
            //           },
            //           onChanged: (_) => setState(() {}),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Step(
              state: validBalance ? StepState.indexed : StepState.disabled,
              title: const Text(
                'Confirmation',
                style: stepperTitleStyle,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Proceed to assign the job to ${application.freelancer?.fullname ?? 'the freelancer'}. The escrow will be created from your wallet balance.",
                    style: stepperContentStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void proceed(int stepIndex) async {
    final userProvider = context.read<UserProvider>();
    final jobProvider = context.read<JobProvider>();
    switch (stepIndex) {
      case 0:
        ProviderRequest.api(
          context: context,
          request: userProvider.getBalance(userProvider.user?.xrpAddress ?? ""),
          onSuccess: (context, result) {
            if (validBalance) _index++;
            if (mounted) setState(() {});
          },
        );
        break;
      case 1:
        // dio.MultipartFile? multipart;
        // try {
        //   if (formKey.currentState?.validate() ?? false) {
        //     multipart = file == null
        //         ? null
        //         : await multipartFileFromPath(file!.path, field: "file");
        //   }
        // } on PathNotFoundException catch (e, s) {
        //   handleError(e, stackTrace: s);
        //   final res = await openFile(
        //     acceptedTypeGroups: [
        //       imagesTypeGroup,
        //       pdfTypeGroup,
        //       docTypeGroup,
        //     ],
        //   );
        //   if (res != null) {
        //     file = res;
        //     if (mounted) setState(() {});
        //   }
        // }
        // if (!mounted) return;

        ProviderRequest.api(
          context: context,
          request: jobProvider.updateApplicationStatus(
            application.id!,
            ApplicationStatus.accepted,
          ),
          onSuccess: (context, result) {
            final mapId = jobProvider.user?.company?.id ?? "";
            jobProvider.getJobs(mapId: mapId, params: {"company": mapId});
            jobProvider.getJobApplications(
              mapId: mapId,
              params: {"company": mapId},
            );
            Navigator.pop(context);
          },
        );
      default:
    }
  }
}
