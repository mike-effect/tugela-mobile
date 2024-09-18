import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/job.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/jobs/job_details.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/skeleton.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final company = job.company;
    const chipStyle = TextStyle(height: 1, fontSize: 12.5);
    final (Color background, Color foreground) statusColors =
        switch (job.status) {
      JobStatus.completed => (
          AppColors.dynamic(
            context: context,
            light: Colors.green.shade50.withOpacity(0.7),
            dark: const Color.fromARGB(255, 21, 69, 24),
          )!,
          AppColors.dynamic(
            context: context,
            light: Colors.lightGreen.shade900,
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
          builder: (_) => JobDetail(job: job),
          rootNavigator: true,
        );
      },
      child: Container(
        padding: ContentPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAvatar(
              radius: 28,
              imageUrl: job.company?.logo,
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
                          job.title ?? '',
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
                    (company?.address) ?? (company?.name ?? ''),
                    style:
                        context.textTheme.bodySmall?.copyWith(fontSize: 13.5),
                  ),
                  VSizedBox8,
                  if (job.compensation > 0) ...[
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
                            text: "${job.currency ?? ''} ${formatAmount(
                              job.price,
                              factor: 1,
                            )}"
                                    " ${job.priceType?.name.sentenceCase.toLowerCase()}"
                                .trim(),
                          ),
                        ],
                      ),
                    ),
                    VSizedBox4,
                  ],
                  if (job.isOnsite) ...[
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
                            text: (job.address ?? '').trim(),
                          ),
                        ],
                      ),
                    ),
                    VSizedBox4,
                  ],
                  if (job.createdAt != null) ...[
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                PhosphorIconsRegular.clock,
                                size: 20,
                                color: context.textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                          TextSpan(
                            text:
                                "Posted on ${formatDate(job.createdAt)}".trim(),
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
                      ...[
                        if (job.roleType != null)
                          "${job.roleType?.name.sentenceCase}",
                        if (job.location != null)
                          "${job.location?.name.sentenceCase}",
                      ].map((t) {
                        return RawChip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: -2,
                          ),
                          label: Text(t, style: chipStyle),
                        );
                      }),
                      if (job.status == JobStatus.assigned ||
                          job.status == JobStatus.completed)
                        RawChip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: -2,
                          ),
                          backgroundColor: statusColors.$1,
                          label: Text(
                            "${job.status?.name.sentenceCase}",
                            style: chipStyle.copyWith(color: statusColors.$2),
                          ),
                        )
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

class JobCardPlaceholder extends StatelessWidget {
  const JobCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ContentPadding,
      child: Row(
        children: [
          const AppAvatar(radius: 28),
          HSizedBox12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(context).rect(height: 12),
                VSizedBox8,
                Skeleton(context).rect(height: 10, width: 100),
                VSizedBox12,
                Row(
                  children: [
                    Skeleton(context).rect(
                      height: 20,
                      width: 60,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    HSizedBox10,
                    Skeleton(context).rect(
                      height: 20,
                      width: 80,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    HSizedBox10,
                    Skeleton(context).rect(
                      height: 20,
                      width: 60,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
