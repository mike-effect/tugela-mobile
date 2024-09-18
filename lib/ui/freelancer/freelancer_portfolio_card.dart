import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/portfolio_item.dart';
import 'package:tugela/models/user.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/skeleton.dart';
import 'package:url_launcher/url_launcher.dart';

class FreelancerPortfolioCard extends StatelessWidget {
  final PortfolioItem portfolio;
  const FreelancerPortfolioCard({
    super.key,
    required this.portfolio,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final isOwner = provider.user?.accountType == AccountType.freelancer &&
        provider.user?.freelancer?.id == portfolio.freelancer;

    return GestureDetector(
      onTap: () async {
        final u = Uri.tryParse(portfolio.projectUrl ?? "");
        if (u == null) return;
        if (await canLaunchUrl(u)) {
          launchUrl(u);
        }
      },
      child: Container(
        padding: ContentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  formatDate(portfolio.startDate, format: 'y'),
                  style: TextStyle(
                    fontSize: 13,
                    color: context.textTheme.bodySmall?.color,
                  ),
                ),
                Space,
                if (isOwner)
                  InkWell(
                    child: Icon(
                      Icons.more_horiz,
                      color: context.textTheme.bodySmall?.color,
                    ),
                    onTap: () {
                      showAppBottomSheet(
                        context: context,
                        physics: const NeverScrollableScrollPhysics(),
                        children: (context) {
                          return [
                            Container(
                              padding: ContentPadding,
                              margin: ContentPadding,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.greyBackgroundColor(context),
                              ),
                              child: Text(
                                portfolio.title ?? '',
                                style: TextStyle(
                                  color: context.textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text("Edit work experience"),
                              onTap: () async {
                                Navigator.pop(context);
                                push(
                                  context: context,
                                  rootNavigator: true,
                                  builder: (_) => FreelancerPortfolioCreate(
                                    portfolioItem: portfolio,
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              textColor: context.colorScheme.error,
                              title: const Text("Delete"),
                              onTap: () {
                                delete(context);
                              },
                            ),
                          ];
                        },
                      );
                    },
                  ),
              ],
            ),
            if (!isOwner) VSizedBox4,
            Text(
              portfolio.title ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            VSizedBox8,
            Text(
              (portfolio.description ?? '').replaceAll('\n\n', ' '),
              style: TextStyle(
                fontSize: 14,
                color: context.textTheme.bodySmall?.color,
              ),
              // overflow: TextOverflow.ellipsis,
              // maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void delete(BuildContext context) async {
    final freelancerProvider = context.read<FreelancerProvider>();
    Navigator.pop(context);
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Deleting",
      request: freelancerProvider.deleteFreelancerPortfolioItem(portfolio.id!),
      onSuccess: (context, res) async {
        context.read<UserProvider>().getUserMe();
        freelancerProvider.getPortfolioItems(
          freelancerId: freelancerProvider.user?.freelancer?.id ?? '',
        );
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
          content: Text("Deleted"),
        ));
      },
    );
  }
}

class FreelancerPortfolioCardPlaceholder extends StatelessWidget {
  const FreelancerPortfolioCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(context).rect(width: 50, height: 8),
          VSizedBox8,
          Skeleton(context).rect(width: 150, height: 14),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
        ],
      ),
    );
  }
}
