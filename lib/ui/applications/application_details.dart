import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/job.dart';
import 'package:tugela/models/job_application.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/applications/application_submission.dart';
import 'package:tugela/ui/freelancer/freelancer_details.dart';
import 'package:tugela/ui/jobs/job_details.dart';
import 'package:tugela/ui/profile/profile_freelancer.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ApplicationDetails extends StatefulWidget {
  final JobApplication application;
  const ApplicationDetails({super.key, required this.application});

  @override
  State<ApplicationDetails> createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
  JobApplication get application => widget.application;

  @override
  void initState() {
    super.initState();
    final provider = context.read<JobProvider>();
    provider.getJobSubmissions(
      mapId: application.id!,
      params: {"application": application.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final application = widget.application;
    const chipStyle = TextStyle(height: 1, fontSize: 13.5);
    final textStyle =
        context.textTheme.bodyMedium?.copyWith(height: 1.4, fontSize: 14.5);
    final job = application.job;
    final company = job?.company;
    final freelancer = application.freelancer;
    final submissions = jobProvider.jobSubmissions[application.id]?.data ?? [];

    if (application.status == ApplicationStatus.accepted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Job Application"),
        ),
        body: SingleChildScrollView(
          padding: ContentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: ContentPadding,
                decoration: BoxDecoration(
                  borderRadius: AppTheme.cardBorderRadius,
                  border: Border.all(
                    color: context.inputTheme.enabledBorder!.borderSide.color,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RawChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: -2,
                      ),
                      backgroundColor: AppColors.dynamic(
                        context: context,
                        light: Colors.green.shade50.withOpacity(0.7),
                        dark: const Color.fromARGB(255, 21, 69, 24),
                      )!,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: AppColors.dynamic(
                              context: context,
                              light: Colors.green.shade600,
                              dark: Colors.green.shade50,
                            )!,
                          ),
                          HSizedBox4,
                          Text(
                            "${application.status?.name.sentenceCase}",
                            style: chipStyle.copyWith(
                              height: 1,
                              color: AppColors.dynamic(
                                context: context,
                                light: Colors.green.shade800,
                                dark: Colors.green.shade50,
                              )!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VSizedBox12,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                (jobProvider.isFreelancer
                                        ? job?.title
                                        : freelancer?.fullname) ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // HSizedBox12,
                            // Text(
                            //   formatDate(job.createdAt),
                            //   style:
                            //       context.textTheme.bodySmall?.copyWith(fontSize: 13),
                            // ),
                          ],
                        ),
                        VSizedBox4,
                        Text(
                          jobProvider.isFreelancer
                              ? ((company?.address) ?? (company?.name ?? ''))
                              : (job?.title ?? ''),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    VSizedBox8,
                    if ((job?.compensation ?? 0) > 0) ...[
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(
                                  PhosphorIconsRegular.wallet,
                                  size: 20,
                                  color: context.textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: "${(job?.currency ?? '').trim()} ${formatAmount(
                                job?.price,
                                factor: 1,
                              )}"
                                      " ${job?.priceType?.name.sentenceCase.toLowerCase()}"
                                  .trim(),
                            ),
                          ],
                        ),
                      ),
                      VSizedBox4,
                    ],
                    if ((job?.isOnsite ?? false)) ...[
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(
                                  PhosphorIconsRegular.mapPin,
                                  size: 20,
                                  color: context.textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: (job?.address ?? '').trim(),
                            ),
                          ],
                        ),
                      ),
                      VSizedBox4,
                    ],
                    VSizedBox8,
                    Wrap(
                      spacing: 5,
                      runSpacing: 0,
                      alignment: WrapAlignment.start,
                      children: [
                        if (application.createdAt != null)
                          RawChip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: -2,
                            ),
                            label: Text(
                              "Applied on ${formatDate(application.createdAt)}",
                              style: chipStyle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              VSizedBox12,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: AppTheme.smallOutlinedButtonStyle(context),
                      onPressed: () {
                        push(
                          context: context,
                          builder: (_) => JobDetail(
                            job: job!,
                          ),
                        );
                      },
                      label: const Text(
                        "Job Details",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  HSizedBox12,
                  Expanded(
                    child: OutlinedButton.icon(
                      style: AppTheme.smallOutlinedButtonStyle(context),
                      onPressed: () {
                        push(
                          context: context,
                          builder: (_) => FreelancerDetails(
                            freelancer: application.freelancer!,
                          ),
                        );
                      },
                      label: const Text(
                        "Freelancer Profile",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              VSizedBox40,
              FormInput(
                title: const Text("Project Submissions"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (submissions.isEmpty)
                      const EmptyState(
                        subtitle:
                            "Submissions for the project will appear here",
                      )
                    else
                      ...submissions.map((s) {
                        return Container(
                          padding: ContentPadding / 1.2,
                          margin: ContentPaddingV / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                AppColors.greyElevatedBackgroundColor(context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((s.file ?? '').isNotEmpty)
                                InkWell(
                                  onTap: () {
                                    launchUrlString(s.file!);
                                  },
                                  child: Text(
                                    "File: ${path.basename(s.file ?? "")}"
                                        .trim(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              if ((s.link ?? '').isNotEmpty)
                                InkWell(
                                  onTap: () {
                                    launchUrlString(s.link!);
                                  },
                                  child: Text(
                                    "Link: ${s.link}".trim(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: jobProvider.isCompany
              ? ElevatedButton(
                  onPressed: job?.status == JobStatus.completed
                      ? null
                      : () {
                          ProviderRequest.api(
                            context: context,
                            request: jobProvider.updateJob(
                              job!.id!,
                              job..status = JobStatus.completed,
                            ),
                            onSuccess: (context, result) {
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                  const SnackBar(content: Text("Job updated")));
                              final mapId = jobProvider.user?.company?.id;
                              context.read<UserProvider>().getUserMe();
                              jobProvider.getJobs(
                                mapId: mapId ?? "",
                                params: {"company": mapId},
                              );
                              jobProvider.getJobApplications(
                                mapId: mapId ?? "",
                                params: {"company": mapId ?? ""},
                              );
                            },
                          );
                        },
                  child: Text(
                    job?.status == JobStatus.completed
                        ? "Job Completed"
                        : "Mark as completed",
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    push(
                      context: context,
                      builder: (_) =>
                          ApplicationSubmission(application: application),
                    );
                  },
                  child: const Text("Add Submission"),
                ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          title: const Text("Job Application"),
          bottom: const TabBar(tabs: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Profile"),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Job"),
            ),
          ]),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            padding: ContentPadding.copyWith(top: 32, bottom: 32),
            child: ProfileFreelancer(freelancer: application.freelancer!),
          ),
          ListView(
            padding: ContentPadding,
            children: [
              VSizedBox24,
              Center(
                child: AppAvatar(
                  radius: 44,
                  imageUrl: job?.company?.logo,
                ),
              ),
              VSizedBox24,
              Text(
                job?.title ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if ((job?.address ?? '').isNotEmpty) ...[
                VSizedBox4,
                Text(
                  job?.address ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: context.textTheme.bodySmall?.color,
                  ),
                ),
              ],
              VSizedBox12,
              Wrap(
                spacing: 8,
                runSpacing: 0,
                alignment: WrapAlignment.center,
                children: [
                  if (job?.location != null)
                    Chip(
                      label: Text(
                        "${job?.location?.name.sentenceCase}",
                        style: chipStyle,
                      ),
                    ),
                  if ((job?.compensation ?? 0) > 0)
                    Chip(
                      label: Text(
                        "${job?.currency ?? ''} ${formatAmount(
                          job?.price,
                          factor: 1,
                          customFormat: NumberFormat.compact(),
                        )}"
                                " ${job?.priceType?.name.sentenceCase.toLowerCase()}"
                            .trim(),
                      ),
                    ),
                  if (job?.roleType != null)
                    Chip(
                      label: Text(
                        "${job?.roleType?.name.sentenceCase}",
                        style: chipStyle,
                      ),
                    ),
                ],
              ),
              VSizedBox32,
              if ((job?.description ?? '').isNotEmpty) ...[
                Text(
                  "Overview",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.primary,
                  ),
                ),
                VSizedBox8,
                Text(
                  job?.description ?? '',
                  textAlign: TextAlign.left,
                  style: textStyle,
                ),
                VSizedBox32,
              ],
              if ((job?.responsibilities ?? '').isNotEmpty) ...[
                Text(
                  "Responsibilities",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.primary,
                  ),
                ),
                VSizedBox8,
                Text(
                  job?.responsibilities ?? '',
                  textAlign: TextAlign.left,
                  style: textStyle,
                ),
                VSizedBox32,
              ],
              if ((job?.experience ?? '').isNotEmpty) ...[
                Text(
                  "Experience",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.primary,
                  ),
                ),
                VSizedBox8,
                Text(
                  job?.experience ?? '',
                  textAlign: TextAlign.left,
                  style: textStyle,
                ),
                VSizedBox32,
              ],
              if ((job?.skills ?? []).isNotEmpty) ...[
                Text(
                  "Skills",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.primary,
                  ),
                ),
                VSizedBox8,
                Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  children: (job?.skills ?? []).map((v) {
                    return RawChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(v.name ?? ''),
                    );
                  }).toList(),
                ),
                VSizedBox32,
              ],
              VSizedBox40,
            ],
          ),
        ]),
        bottomNavigationBar: BottomAppBar(
          child: (jobProvider.isCompany &&
                  application.status == ApplicationStatus.pending)
              ? ElevatedButton(
                  onPressed: () async {
                    final res = await showAppBottomSheet<ApplicationStatus>(
                      context: context,
                      title: "Application Status",
                      physics: const NeverScrollableScrollPhysics(),
                      children: (context) {
                        return [
                          VSizedBox16,
                          ...ApplicationStatus.values.map((e) {
                            return RadioListTile<ApplicationStatus>(
                              value: e,
                              groupValue: application.status,
                              visualDensity: VisualDensity.compact,
                              title: Text(e.name.sentenceCase),
                              activeColor: context.colorScheme.secondary,
                              onChanged: (value) {
                                rootNavigator(context).pop(e);
                              },
                            );
                          }),
                          VSizedBox8,
                        ];
                      },
                    );
                    if (res != null) {
                      changeStatus(res);
                    }
                  },
                  child: const Text("Review Application"),
                )
              : ElevatedButton(
                  onPressed: null,
                  child: Text(
                    "Application ${application.status?.name.sentenceCase ?? ''}",
                  ),
                ),
        ),
      ),
    );
  }

  void changeStatus(ApplicationStatus status) async {
    final application = widget.application;
    if (status == ApplicationStatus.rejected) {
      final res = await showAppBottomSheet(
        context: context,
        physics: const NeverScrollableScrollPhysics(),
        padding: ContentPadding,
        title: "Reject Applicant",
        centerTitleText: true,
        children: (context) {
          return [
            Text(
              "You are about to reject the submission by ${application.freelancer?.fullname ?? 'this freelancer'} for ${application.job?.title ?? 'this job'}. "
              "They will be notified about the status of their application",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Update Application"),
            ),
          ];
        },
      );
      if ((res ?? false) && mounted) {
        final provider = context.read<JobProvider>();
        ProviderRequest.api(
          context: context,
          request: provider.updateApplicationStatus(
            application.id!,
            ApplicationStatus.rejected,
          ),
          onSuccess: (context, res) {
            // Navigator.pop(context);
            provider.getJobApplications(
              mapId: provider.user?.company?.id ?? "",
              params: {"company": provider.user?.company?.id ?? ""},
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Application updated"),
              ));
              rootNavigator(context).pop();
            }
          },
        );
      }
    } else if (status == ApplicationStatus.accepted) {
      // push(
      //   context: context,
      //   rootNavigator: true,
      //   builder: (_) => ApplicationAcceptance(application: application),
      // );
      final res = await showAppBottomSheet(
        context: context,
        physics: const NeverScrollableScrollPhysics(),
        padding: ContentPadding,
        title: "Accept Applicant",
        centerTitleText: true,
        children: (context) {
          return [
            Text(
              "Proceed to assign the job to ${application.freelancer?.fullname ?? 'the freelancer'}. The escrow will be created from your wallet balance.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Update Application"),
            ),
          ];
        },
      );
      if ((res ?? false) && mounted) {
        final provider = context.read<JobProvider>();
        ProviderRequest.api(
          context: context,
          request: provider.updateApplicationStatus(
            application.id!,
            ApplicationStatus.accepted,
          ),
          onSuccess: (context, res) {
            final mapId = provider.user?.company?.id ?? "";
            provider.getJobs(mapId: mapId, params: {"company": mapId});
            provider.getJobApplications(
              mapId: mapId,
              params: {"company": mapId},
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Application updated"),
              ));
              // rootNavigator(context).pop();
            }
          },
        );
      }
    }
  }
}
