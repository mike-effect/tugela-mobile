import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/applications/applications_list.dart';
import 'package:tugela/utils.dart';

class ApplicationsCompany extends StatelessWidget {
  final Company company;
  const ApplicationsCompany({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: AppColors.greyElevatedBackgroundColor(context),
    );

    void navigate(
      String? mapId, [
      Map<String, dynamic>? params,
      String? title,
    ]) {
      push(
        context: context,
        rootNavigator: true,
        builder: (_) => ApplicationList(
          mapId: mapId,
          params: params ?? {},
          title: title,
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: Padding(
        padding: ContentPaddingZeroTop,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  navigate(
                    company.id ?? '',
                    {"company": company.id},
                    "All Applications",
                  );
                },
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
                      Text(
                        "${company.totalApplications}",
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text("All Applications"),
                    ],
                  ),
                ),
              ),
            ),
            HSizedBox12,
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigate(
                          "${company.id}_accepted",
                          {
                            "company": company.id,
                            "status": "accepted",
                          },
                          "Accepted Applications",
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
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
                          // title: Text(
                          //   "${company.assignedJobs}",
                          //   style: const TextStyle(
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          title: const Text("Accepted"),
                        ),
                      ),
                    ),
                  ),
                  VSizedBox12,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigate(
                          "${company.id}_rejected",
                          {
                            "company": company.id,
                            "status": "rejected",
                          },
                          "Rejected Applications",
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
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
                          // title: Text(
                          //   "${company.completedJobs}",
                          //   style: const TextStyle(
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          title: const Text("Rejected"),
                        ),
                      ),
                    ),
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
