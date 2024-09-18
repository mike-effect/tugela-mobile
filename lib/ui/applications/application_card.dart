import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/job_application.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/applications/application_details.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplication application;
  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JobProvider>();
    final job = application.job;
    final company = job?.company;
    final freelancer = application.freelancer;
    const chipStyle = TextStyle(height: 1, fontSize: 12.5);
    final (Color background, Color foreground) colors =
        switch (application.status) {
      ApplicationStatus.rejected => (
          AppColors.dynamic(
            context: context,
            light: Colors.red.shade50,
            dark: const Color.fromARGB(255, 97, 19, 19),
          )!,
          AppColors.dynamic(
            context: context,
            light: Colors.red.shade900,
            dark: Colors.red.shade50,
          )!,
        ),
      ApplicationStatus.accepted => (
          AppColors.dynamic(
            context: context,
            light: Colors.green.shade50.withOpacity(0.7),
            dark: const Color.fromARGB(255, 21, 69, 24),
          )!,
          AppColors.dynamic(
            context: context,
            light: Colors.green.shade800,
            dark: Colors.green.shade50,
          )!,
        ),
      _ => (
          AppColors.dynamic(
            context: context,
            light: Colors.amber.shade100,
            dark: Colors.brown.shade800,
          )!,
          AppColors.dynamic(
            context: context,
            light: Colors.brown.shade800,
            dark: Colors.amber.shade100,
          )!,
        ),
    };

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        push(
          context: context,
          builder: (_) => ApplicationDetails(application: application),
          rootNavigator: true,
        );
      },
      child: Container(
        padding: ContentPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAvatar(
              radius: 24,
              imageUrl: provider.isFreelancer
                  ? job?.company?.logo
                  : application.freelancer?.profileImage,
            ),
            HSizedBox12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          (provider.isFreelancer
                                  ? job?.title
                                  : freelancer?.fullname) ??
                              '',
                          style: const TextStyle(
                            fontSize: 15,
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
                    provider.isFreelancer
                        ? ((company?.address) ?? (company?.name ?? ''))
                        : (job?.title ?? ''),
                    style:
                        context.textTheme.bodySmall?.copyWith(fontSize: 13.5),
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
                      if (application.status != null)
                        RawChip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: -2,
                          ),
                          backgroundColor: colors.$1,
                          label: Text(
                            "${application.status?.name.sentenceCase}",
                            style: chipStyle.copyWith(color: colors.$2),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
