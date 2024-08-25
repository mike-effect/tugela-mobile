import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/ui/company/company_details.dart';
import 'package:tugela/ui/jobs/job_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class JobDetail extends StatelessWidget {
  final Job job;
  const JobDetail({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final company = job.company;
    const chipStyle = TextStyle(
      height: 1,
      fontSize: 13.5,
    );
    final textStyle =
        context.textTheme.bodyMedium?.copyWith(height: 1.4, fontSize: 14.5);
    return SliverScaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        actions: [
          if (options(context).isNotEmpty)
            IconButton(
              icon: const Icon(PhosphorIconsRegular.dotsThreeCircle),
              onPressed: () {
                showAppBottomSheet(
                  context: context,
                  children: (context) {
                    return options(context);
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
          const AppAvatar(radius: 44),
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
                      job.minPrice,
                      factor: 1,
                      customFormat: NumberFormat.compact(),
                    )}"
                            "–${job.isCompensationRange ? formatAmount(
                                job.maxPrice,
                                factor: 1,
                                customFormat: NumberFormat.compact(),
                              ) : ''}"
                            " ${job.priceType?.name.sentenceCase.toLowerCase()}"
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
          if (company != null)
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
                leading: const AppAvatar(radius: 22),
                title: Text(
                  "${company.name}",
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  company.industry?.name ?? "View Company",
                  style: const TextStyle(fontSize: 12.5),
                ),
                trailing: const RightChevron(),
                onTap: () {
                  push(
                    context: context,
                    builder: (_) => CompanyDetails(company: company),
                    rootNavigator: true,
                  );
                },
              ),
            ),
          VSizedBox32,
          if ((job.description ?? '').isNotEmpty) ...[
            const Text(
              "Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            VSizedBox8,
            Text(
              job.description ?? '',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            VSizedBox32,
          ],
          if ((job.responsibilities ?? '').isNotEmpty) ...[
            const Text(
              "Responsibilities",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            VSizedBox8,
            Text(
              job.responsibilities ?? '',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            VSizedBox32,
          ],
          if ((job.experience ?? '').isNotEmpty) ...[
            const Text(
              "Experience",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            VSizedBox8,
            Text(
              job.experience ?? '',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            VSizedBox32,
          ],
        ],
      ),
    );
  }

  List<Widget> options(BuildContext context) {
    return [
      if (context.read<UserProvider>().user?.company?.id == job.company?.id)
        ListTile(
          title: const Text("Edit Job Listing"),
          onTap: () {
            Navigator.pop(context);
            push(
              context: context,
              builder: (_) => JobCreate(job: job),
            );
          },
        ),
    ];
  }
}
