import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/applications/applications_list.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/section_header.dart';

class ApplicationsFreelancer extends StatelessWidget {
  final Freelancer freelancer;
  const ApplicationsFreelancer({super.key, required this.freelancer});

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
                          "${freelancer.totalApplications}",
                          style: const TextStyle(
                            fontSize: 64,
                            height: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      VSizedBox8,
                      const Text("Total Applications"),
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
                            "${freelancer.acceptedApplications}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text("Accepted"),
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
                            child: const Icon(PhosphorIconsRegular.xCircle),
                          ),
                          title: Text(
                            "${freelancer.rejectedApplications}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text("Rejected"),
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
        SectionHeader(
          padding: ContentPadding,
          title: "My Job Applications",
          list: List.generate(freelancer.totalApplications, (i) => i),
          onViewAll: (context) {
            push(
              context: context,
              builder: (_) => ApplicationList(
                title: "My Job Applications",
                mapId: freelancer.id,
                params: {"freelancer": freelancer.id},
              ),
              rootNavigator: true,
            );
          },
        ),
        // const Divider(),
      ],
    );
  }
}
