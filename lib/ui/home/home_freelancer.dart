import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/freelancer/freelancer_experience_create.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio_create.dart';
import 'package:tugela/ui/freelancer/freelancer_services_create.dart';
import 'package:tugela/utils.dart';
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

    if (services.isNotEmpty && portfolio.isNotEmpty && services.isNotEmpty) {
      return const SizedBox.shrink();
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
                    color: services.isNotEmpty
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
                    services.isNotEmpty
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