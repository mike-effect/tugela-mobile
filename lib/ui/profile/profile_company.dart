import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:tugela/extensions/build_context.extension.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/jobs/job_details.dart';
import 'package:tugela/ui/jobs/job_list.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/app_image.dart';
import 'package:tugela/widgets/layout/empty_state.dart';

class ProfileCompany extends StatelessWidget {
  final Company company;
  const ProfileCompany({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();
    final jobProvider = context.watch<JobProvider>();
    // ignore: no_leading_underscores_for_local_identifiers
    final _company = companyProvider.company[company.id] ?? company;
    const chipStyle = TextStyle(height: 1.2, fontSize: 13);
    final jobs = (jobProvider.jobs[_company.id]?.data ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // AppAvatar(radius: 55),
            AppImage(
              width: 110,
              height: 110,
              borderRadius: AppTheme.avatarBorderRadius,
            ),
            HSizedBox16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _company.name ?? 'Company',
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  if ((_company.tagline ?? '').isNotEmpty) ...[
                    VSizedBox4,
                    Text(
                      _company.tagline ?? '',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: context.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                  if ((_company.website ?? '').isNotEmpty) ...[
                    VSizedBox8,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.greyElevatedBackgroundColor(context),
                      ),
                      child: Text(
                        (_company.website ?? '').replaceAll(
                          RegExp(r'^http(s)?://(www.)?'),
                          '',
                        ),
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
        if ((_company.description ?? '').isNotEmpty) ...[
          VSizedBox24,
          Text(
            (_company.description ?? ''),
            style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
          ),
        ],
        VSizedBox12,
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            if (_company.industry?.name != null)
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
                      _company.industry?.name ?? '',
                      style: chipStyle,
                    ),
                  ],
                ),
              ),
            ...(_company.values).map((v) {
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
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        VSizedBox48,
        Row(
          children: [
            const Text(
              "Job Listings",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Space,
            if (jobs.length > 3)
              GestureDetector(
                onTap: () {
                  push(
                    context: context,
                    builder: (_) => JobList(
                      title: "My Jobs Listings",
                      mapId: company.id,
                      params: {"company": company.id},
                    ),
                    rootNavigator: true,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: context.theme.dividerColor.withOpacity(0.4),
                    ),
                  ),
                  child: const Text(
                    "View all",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
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
          ...jobs.take(3).map((job) {
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
        const Text(
          "Company Information",
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 0.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        VSizedBox8,
        if (_company.organizationType != null)
          item(
            context,
            title: 'Organization Type',
            subtitle: _company.organizationType?.name.titleCase ?? '',
          ),
        if (_company.phoneNumber != null)
          item(
            context,
            title: 'Phone',
            subtitle: _company.phoneNumber ?? "",
          ),
        if (_company.email != null)
          item(
            context,
            title: 'Email',
            subtitle: _company.email ?? "",
          ),
        if (_company.website != null)
          item(
            context,
            title: 'Website',
            subtitle: _company.website ?? "",
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
