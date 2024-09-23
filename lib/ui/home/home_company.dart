import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/models/user.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/jobs/job_list.dart';
import 'package:tugela/ui/settings/settings_payments.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/layout/section_header.dart';

class HomeCompany extends StatelessWidget {
  final Company company;
  const HomeCompany({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final balance = userProvider.balance?.xrpBalance;
    final address = userProvider.user?.xrpAddress;

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
        builder: (_) => JobList(
          mapId: mapId,
          params: params ?? {},
          title: title,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () async {
            await push(
              context: context,
              rootNavigator: true,
              builder: (_) => const SettingsPayments(
                accountType: AccountType.company,
              ),
            );
            userProvider.getBalance(address!);
          },
          child: Container(
            margin: ContentPaddingH,
            padding: ContentPadding,
            decoration: boxDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VSizedBox16,
                Text(
                  "Wallet Balance",
                  style: TextStyle(
                    color: context.textTheme.bodySmall?.color,
                  ),
                ),
                VSizedBox12,
                Text(
                  formatAmount(
                    (balance ?? 0),
                    symbol: "XRP",
                    isCrypto: true,
                    truncate: true,
                  ),
                  textScaler: maxTextScale(context, 1),
                  style: const TextStyle(
                    height: 1,
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      style: AppTheme.compactTextButtonStyle(context),
                      onPressed: () async {
                        await pushNamed(
                          context,
                          Routes.xrpTopup,
                          rootNavigator: true,
                        );
                        userProvider.getBalance(address!);
                      },
                      icon: const Icon(PhosphorIconsRegular.wallet, size: 20),
                      label: Text(
                        "Top Up".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // TextButton(
                    //   style: AppTheme.compactTextButtonStyle(context),
                    //   onPressed: () async {
                    //     if (address != null) await copyToClipboard(address);
                    //     if (context.mounted) {
                    //       ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    //         const SnackBar(content: Text("Copied")),
                    //       );
                    //     }
                    //   },
                    //   child: Text(
                    //     "COPY ADDRESS".toUpperCase(),
                    //     style: const TextStyle(
                    //       fontSize: 13,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        VSizedBox12,
        Padding(
          padding: ContentPaddingH,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    navigate(company.id, null, "My Jobs");
                  },
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
                        child: const Icon(PhosphorIconsRegular.briefcase),
                      ),
                      title: Text(
                        "${company.totalJobs}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text("Total Jobs"),
                    ),
                  ),
                ),
              ),
              HSizedBox12,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    navigate(
                        "${company.id}_active",
                        {
                          "company": company.id,
                          "status": "active",
                        },
                        "My Active Jobs");
                  },
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
                        child: const Icon(PhosphorIconsRegular.clock),
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
              ),
            ],
          ),
        ),
        VSizedBox12,
        Padding(
          padding: ContentPaddingZeroTop,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    navigate(
                      "${company.id}_assigned",
                      {
                        "company": company.id,
                        "status": "assigned",
                      },
                      "My Assigned Jobs",
                    );
                  },
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
                        child: const Icon(PhosphorIconsRegular.tag),
                      ),
                      title: Text(
                        "${company.assignedJobs}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text("Assigned"),
                    ),
                  ),
                ),
              ),
              HSizedBox12,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    navigate(
                      "${company.id}_completed",
                      {
                        "company": company.id,
                        "status": "completed",
                      },
                      "My Completed Jobs",
                    );
                  },
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
                        "${company.completedJobs}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text("Completed"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SectionHeader(
          padding: ContentPadding,
          title: "My Job Listings",
          list: List.generate(company.totalJobs, (i) => i),
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

        // const Divider(),
      ],
    );
  }
}
