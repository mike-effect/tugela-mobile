import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/models/user.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/freelancer/freelancer_experience_create.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio_create.dart';
import 'package:tugela/ui/freelancer/freelancer_services_create.dart';
import 'package:tugela/ui/settings/settings_payments.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/section_header.dart';

class HomeFreelancer extends StatelessWidget {
  final Freelancer freelancer;
  const HomeFreelancer({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    final experiences = freelancer.workExperiences;
    final portfolio = freelancer.portfolioItem;
    final services = freelancer.services;
    final userProvider = context.watch<UserProvider>();
    final address = userProvider.user?.xrpAddress;
    final balance = userProvider.balance?.xrpBalance;
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: AppColors.greyElevatedBackgroundColor(context),
    );

    if (services.isNotEmpty && portfolio.isNotEmpty && services.isNotEmpty) {
      return GestureDetector(
        onTap: () async {
          await push(
            context: context,
            rootNavigator: true,
            builder: (_) => const SettingsPayments(
              accountType: AccountType.freelancer,
            ),
          );
          userProvider.getBalance(address!);
        },
        child: Container(
          margin: ContentPaddingZeroTop,
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
              TextButton.icon(
                style: AppTheme.compactTextButtonStyle(context),
                onPressed: () async {
                  await pushNamed(
                    context,
                    Routes.xrpWithdrawal,
                    rootNavigator: true,
                  );
                  if (address != null) userProvider.getBalance(address);
                },
                icon: const Icon(PhosphorIconsRegular.wallet),
                label: const Text(
                  "Withdraw",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          const SectionHeader(
            padding: ContentPadding,
            title: "Complete your profile",
          ),
          Container(
            margin: ContentPaddingH,
            padding: ContentPaddingV / 3,
            decoration: BoxDecoration(
              borderRadius: AppTheme.cardBorderRadius,
              border: Border.all(
                color: context.inputTheme.enabledBorder!.borderSide.color,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity.compact,
                  minLeadingWidth: 18,
                  title: const Text("List a service you offer"),
                  leading: Icon(
                    services.isNotEmpty
                        ? PhosphorIconsFill.checkCircle
                        : PhosphorIconsRegular.circle,
                    color: services.isNotEmpty
                        ? AppColors.green
                        : context.textTheme.bodySmall?.color?.withOpacity(0.3),
                  ),
                  trailing: const RightChevron(),
                  onTap: () {
                    push(
                      context: context,
                      rootNavigator: true,
                      builder: (_) => const FreelancerServiceCreate(),
                    );
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity.compact,
                  minLeadingWidth: 18,
                  title: const Text("Add your work experience"),
                  leading: Icon(
                    experiences.isNotEmpty
                        ? PhosphorIconsFill.checkCircle
                        : PhosphorIconsRegular.circle,
                    color: experiences.isNotEmpty
                        ? AppColors.green
                        : context.textTheme.bodySmall?.color?.withOpacity(0.3),
                  ),
                  trailing: const RightChevron(),
                  onTap: () {
                    push(
                      context: context,
                      rootNavigator: true,
                      builder: (_) => const FreelancerExperienceCreate(),
                    );
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity.compact,
                  minLeadingWidth: 18,
                  title: const Text("Add projects to your portfolio"),
                  leading: Icon(
                    portfolio.isNotEmpty
                        ? PhosphorIconsFill.checkCircle
                        : PhosphorIconsRegular.circle,
                    color: portfolio.isNotEmpty
                        ? AppColors.green
                        : context.textTheme.bodySmall?.color?.withOpacity(0.3),
                  ),
                  trailing: const RightChevron(),
                  onTap: () {
                    push(
                      context: context,
                      rootNavigator: true,
                      builder: (_) => const FreelancerPortfolioCreate(),
                    );
                  },
                ),
              ],
            ),
          ),
          VSizedBox40,
        ],
      );
    }
  }
}
