import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:tugela/constants/app_assets.dart';
import 'package:tugela/extensions/build_context.extension.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/jobs/job_details.dart';
import 'package:tugela/ui/jobs/job_list.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/app_image.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/section_header.dart';

class ProfileCompany extends StatelessWidget {
  final Company company;
  const ProfileCompany({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    // ignore: no_leading_underscores_for_local_identifiers
    const chipStyle = TextStyle(height: 1.2, fontSize: 13);
    final jobs = (jobProvider.jobs[company.id]?.data ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppImage(
              width: 110,
              height: 110,
              borderRadius: AppTheme.avatarBorderRadius,
              imageUrl: company.logo,
              child: (company.logo ?? "").isNotEmpty
                  ? null
                  : Image.asset(
                      AppAssets.images.appIconForegroundPng,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.2),
                    ),
            ),
            HSizedBox16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name ?? 'Company',
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  if ((company.tagline ?? '').isNotEmpty) ...[
                    VSizedBox4,
                    Text(
                      company.tagline ?? '',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: context.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                  if ((company.website ?? '').isNotEmpty) ...[
                    VSizedBox8,
                    RawChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        (company.website ?? '')
                            .replaceAll(RegExp(r'^http(s)?://(www.)?'), ''),
                        style:
                            context.textTheme.bodyMedium?.copyWith(height: 1),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if ((company.description ?? '').isNotEmpty) ...[
          VSizedBox24,
          Text(
            (company.description ?? ''),
            style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
          ),
        ],
        if ((company.location ?? '').isNotEmpty) ...[
          VSizedBox8,
          Text(
            (company.location ?? ''),
            style: context.textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
        ],
        VSizedBox12,
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            if (company.industry?.name != null)
              Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIconsFill.houseSimple,
                      size: 15,
                      color: context.textTheme.bodySmall?.color,
                    ),
                    HSizedBox4,
                    Text(
                      company.industry?.name ?? '',
                      style: chipStyle,
                    ),
                  ],
                ),
              ),
            ...(company.values).map((v) {
              return Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIconsFill.heart,
                      size: 15,
                      color: context.textTheme.bodySmall?.color,
                    ),
                    HSizedBox4,
                    Text(
                      v.name ?? '',
                      style: chipStyle,
                      textScaler: maxTextScale(context, 1.07),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        VSizedBox48,
        SectionHeader(
          title: "Job Listings",
          list: jobs,
          onViewAll: (context) {
            push(
              context: context,
              builder: (_) => JobList(
                title: "My Job Listings",
                mapId: company.id,
                params: {"company": company.id},
              ),
              rootNavigator: true,
            );
          },
        ),
        if (jobs.isEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            child: const EmptyState(
              title: "No open roles yet 🍃",
              subtitle: "Job listings will show up there.",
            ),
          )
        else
          ...jobs.take(6).map((job) {
            final sub = [
              (job.roleType?.name ?? ''),
              (job.location?.name ?? '').toLowerCase()
            ];
            sub.removeWhere((t) => t.isEmpty);
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                job.title ?? '',
                style: const TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                sub.join(', ').sentenceCase,
                style: const TextStyle(fontSize: 13.5),
              ),
              trailing: const RightChevron(),
              onTap: () {
                push(
                  context: context,
                  builder: (_) => JobDetail(job: job),
                  rootNavigator: true,
                );
              },
            );
          }),
        VSizedBox48,
        const SectionHeader(title: "Company Information"),
        VSizedBox8,
        if (company.organizationType != null)
          item(
            context,
            title: 'Organization Type',
            subtitle: company.organizationType?.name.titleCase ?? '',
          ),
        if (company.phoneNumber != null)
          item(
            context,
            title: 'Phone',
            subtitle: company.phoneNumber ?? "",
          ),
        if (company.email != null)
          item(
            context,
            title: 'Email',
            subtitle: company.email ?? "",
          ),
        if (company.website != null)
          item(
            context,
            title: 'Website',
            subtitle: company.website ?? "",
          ),
      ],
    );
  }

  Widget item(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(vertical: 6),
      prefix: Text(
        title,
        style: context.textTheme.bodySmall?.copyWith(fontSize: 14),
      ),
      child: Text(
        subtitle,
        style: context.textTheme.bodyMedium?.copyWith(fontSize: 14),
      ),
    );
  }
}
