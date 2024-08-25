import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/job.dart';
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
            const AppAvatar(radius: 28),
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
                              job.minPrice,
                              factor: 1,
                              customFormat: NumberFormat.compact(),
                            )}"
                                    "${job.isCompensationRange ? '–${formatAmount(
                                        job.maxPrice,
                                        factor: 1,
                                        customFormat: NumberFormat.compact(),
                                      )}' : ''}"
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
                  VSizedBox8,
                  Wrap(
                    spacing: 5,
                    runSpacing: 0,
                    alignment: WrapAlignment.start,
                    children: [
                      if (job.createdAt != null)
                        "Posted on ${formatDate(job.createdAt)}",
                      if (job.roleType != null)
                        "${job.roleType?.name.sentenceCase}",
                      if (job.location != null)
                        "${job.location?.name.sentenceCase}",
                    ].map((t) {
                      return RawChip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        label: Text(t, style: chipStyle),
                      );
                    }).toList(),
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
