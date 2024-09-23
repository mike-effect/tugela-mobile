import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/company/company_card.dart';
import 'package:tugela/ui/jobs/job_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/feedback/dialog.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/section_header.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JobDetail extends StatelessWidget {
  final Job job;
  const JobDetail({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final userProvider = context.watch<UserProvider>();
    const chipStyle = TextStyle(height: 1, fontSize: 13.5);
    final textStyle =
        context.textTheme.bodyMedium?.copyWith(height: 1.4, fontSize: 14.5);
    final job = jobProvider.job[this.job.id] ?? this.job;

    int score() {
      int count = 0;
      final fs = (jobProvider.user?.freelancer?.skills ?? [])
          .map((e) => e.name?.toLowerCase() ?? "");
      final js = job.skills.map((e) => e.name?.toLowerCase() ?? "");
      for (final j in js) {
        if (fs.contains(j)) count++;
      }
      return count;
    }

    return SliverScaffold(
      onRefresh: () => Future.wait([
        jobProvider.getJob(job.id!),
      ]),
      appBar: AppBar(
        title: const Text("Job Details"),
        actions: [
          if (options(context, job).isNotEmpty)
            IconButton(
              icon: const Icon(PhosphorIconsRegular.dotsThreeCircle),
              onPressed: () {
                showAppBottomSheet(
                  context: context,
                  children: (context) {
                    return options(context, job);
                  },
                );
              },
            ),
          HSizedBox10,
        ],
      ),
      bodyPadding: ContentPadding,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VSizedBox8,
          Center(
            child: AppAvatar(
              radius: 44,
              imageUrl: job.company?.logo,
            ),
          ),
          VSizedBox24,
          Text(
            job.title ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if ((job.address ?? '').isNotEmpty) ...[
            VSizedBox4,
            Text(
              job.address ?? '',
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
              if (job.location != null)
                Chip(
                  label: Text(
                    "${job.location?.name.sentenceCase}",
                    style: chipStyle,
                  ),
                ),
              if (job.compensation > 0)
                Chip(
                  label: Text(
                    "${job.currency ?? ''} ${formatAmount(
                      job.price,
                      factor: 1,
                      customFormat: NumberFormat.compact(),
                    )} ${job.priceType?.name.sentenceCase.toLowerCase()}"
                        .trim(),
                  ),
                ),
              if (job.roleType != null)
                Chip(
                  label: Text(
                    "${job.roleType?.name.sentenceCase}",
                    style: chipStyle,
                  ),
                ),
            ],
          ),
          if (jobProvider.isFreelancer && (score() > 0))
            Container(
              margin: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.inputTheme.enabledBorder!.borderSide.color
                      .withOpacity(0.6),
                ),
              ),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.comfortable,
                minLeadingWidth: 24,
                leading: const Icon(
                  PhosphorIconsRegular.sparkle,
                  color: AppColors.amber,
                ),
                title: Text(
                  "${score()} ${pluralFor("skill", count: score())} ${score() == 1 ? 'matches' : 'match'} your profile",
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "You may ${score() < 5 ? 'apply' : 'be a good fit'} for this role",
                  style: const TextStyle(fontSize: 12.5),
                ),
              ),
            ),
          VSizedBox32,
          if ((job.description ?? '').isNotEmpty) ...[
            const SectionHeader(title: "Overview"),
            VSizedBox8,
            Text(
              job.description ?? '',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            VSizedBox32,
          ],
          if ((job.responsibilities ?? '').isNotEmpty) ...[
            const SectionHeader(title: "Responsibilities"),
            VSizedBox8,
            Text(
              job.responsibilities ?? '',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            VSizedBox32,
          ],
          if ((job.experience ?? '').isNotEmpty) ...[
            const SectionHeader(title: "Experience"),
            VSizedBox8,
            Text(
              job.experience ?? '',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            VSizedBox32,
          ],
          if (job.skills.isNotEmpty) ...[
            const SectionHeader(title: "Job Skills"),
            VSizedBox8,
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: job.skills.map((v) {
                return RawChip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(v.name ?? ''),
                );
              }).toList(),
            ),
            VSizedBox32,
          ],
          if (job.company != null) ...[
            const SectionHeader(title: "About the company"),
            VSizedBox12,
            CompanyCard(company: job.company!),
          ],
          VSizedBox40,
        ],
      ),
      bottomNavigationBar: userProvider.isCompany
          ? null
          : (job.status == JobStatus.active &&
                      (job.applicationType == JobApplicationType.external &&
                          job.externalApplyLink != null) ||
                  job.applicationType == JobApplicationType.internal)
              ? BottomAppBar(
                  child: ElevatedButton(
                    onPressed: () => apply(context),
                    child: const Text("Apply for role"),
                  ),
                )
              : null,
    );
  }

  void apply(BuildContext context) async {
    if (job.applicationType == JobApplicationType.external) {
      try {
        launchUrlString(job.externalApplyLink ?? "");
      } catch (e, s) {
        handleError(e, stackTrace: s);
      }
    } else {
      final res = await showAppBottomSheet(
        context: context,
        physics: const NeverScrollableScrollPhysics(),
        padding: ContentPadding,
        title: "Apply for role",
        centerTitleText: true,
        children: (context) {
          return [
            Text(
              "You are about to apply for ${job.title ?? 'a role'}, ${job.roleType?.name.sentenceCase.toLowerCase()} at ${job.company?.name ?? 'this company'}. "
              "The recruiter will go through your freelancer profile to see your work experiences, services and portfolio. Always keep your profile detailed and updated for the best outcomes ✨",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Submit Application"),
            ),
          ];
        },
      );
      if ((res ?? false) && context.mounted) {
        final provider = context.read<JobProvider>();
        ProviderRequest.api(
          context: context,
          request: provider.createApplication(JobApplication(
            freelancer: provider.user?.freelancer,
            job: job,
          )),
          onSuccess: (context, res) {
            // Navigator.pop(context);
            provider.getJobApplications(
              mapId: provider.user?.freelancer?.id,
              params: {"freelancer": provider.user?.freelancer?.id},
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Application submitted"),
              ));
              // rootNavigator(context).pop();
            }
          },
        );
      }
    }
  }

  List<Widget> options(BuildContext context, Job job) {
    final userProvider = context.read<UserProvider>();
    final jobProvider = context.read<JobProvider>();
    final user = userProvider.user;
    return [
      if (user?.accountType == AccountType.company &&
          user?.company?.id == job.company?.id) ...[
        VSizedBox24,
        ListTile(
          title: const Text("Edit job listing"),
          onTap: () {
            Navigator.pop(context);
            push(
              context: context,
              builder: (_) => JobCreate(job: job),
            );
          },
        ),
        ListTile(
          textColor: context.colorScheme.error,
          title: const Text("Delete this job"),
          onTap: () async {
            Navigator.pop(context);
            final res = await showAppDialog(
              context,
              title: "Delete Job",
              message:
                  "Are you sure you want to continue? Deleting a job is permanent and cannot be reversed.",
              confirmationText: Text(
                "Yes, delete",
                style: TextStyle(color: context.colorScheme.error),
              ),
              onConfirm: (context) {
                Navigator.pop(context, true);
              },
            );
            if ((res ?? false) && context.mounted) {
              ProviderRequest.api(
                context: context,
                request: jobProvider.deleteJob(job.id!),
                onSuccess: (context, res) {
                  if (res.data ?? false) {
                    Navigator.pop(context);
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        const SnackBar(content: Text("Job deleted")));
                  }
                },
              );
            }
          },
        ),
      ]
    ];
  }
}
