import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/jobs/job_list.dart';
import 'package:tugela/utils.dart';

class HomeCompany extends StatelessWidget {
  final Company company;
  const HomeCompany({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: AppColors.greyElevatedBackgroundColor(context),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
          padding: ContentPaddingZeroTop,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: ContentPadding,
                  decoration: boxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: context.colorScheme.surface,
                        foregroundColor: context.colorScheme.secondary,
                        child: const Icon(PhosphorIconsRegular.briefcase),
                      ),
                      Space,
                      FittedBox(
                        child: Text(
                          "${company.totalJobs}",
                          style: const TextStyle(
                            fontSize: 64,
                            height: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      VSizedBox8,
                      const Text("Total Jobs"),
                    ],
                  ),
                ),
              ),
              HSizedBox12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: ContentPadding,
                        decoration: boxDecoration,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: context.colorScheme.surface,
                            foregroundColor: context.colorScheme.secondary,
                            child: const Icon(PhosphorIconsRegular.checkCircle),
                          ),
                          title: Text(
                            "${company.activeJobs}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text("Active Jobs"),
                        ),
                      ),
                    ),
                    VSizedBox12,
                    Expanded(
                      child: Container(
                        padding: ContentPadding,
                        decoration: boxDecoration,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: context.colorScheme.surface,
                            foregroundColor: context.colorScheme.secondary,
                            child: const Icon(PhosphorIconsRegular.fileText),
                          ),
                          title: Text(
                            "${company.totalApplications}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text("Applications"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        VSizedBox12,
        Padding(
          padding: ContentPadding,
          child: Row(
            children: [
              Text(
                "My Job Listings",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  height: 1,
                ),
              ),
              Space,
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
        ),
        // const Divider(),
      ],
    );
  }
}
