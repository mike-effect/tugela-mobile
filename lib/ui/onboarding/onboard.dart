import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      pageAppBar: const PageAppBar(
        largeTitle: Text("Choose Account Type"),
      ),
      bodyPadding: ContentPadding,
      body: Column(
        children: [
          card(
            context: context,
            title: "Freelancer",
            subtitle: "Finish setting up your profile",
            onTap: () {
              pushNamed(context, Routes.freelancerCreate);
            },
            icon: const Icon(PhosphorIconsRegular.userCircle, size: 44),
          ),
          VSizedBox16,
          card(
            context: context,
            title: "Company",
            subtitle: "Set up your company profile",
            icon: const Icon(PhosphorIconsRegular.briefcase, size: 44),
            onTap: () {
              pushNamed(context, Routes.companyCreate);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: OutlinedButton(
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.error,
          ),
          child: const Text("Log out of this account"),
          onPressed: () {
            final userProvider = context.read<UserProvider>();
            userProvider.logout();
            rootNavigator(context)
                .pushNamedAndRemoveUntil(Routes.welcome, (_) => false);
          },
        ),
      ),
    );
  }

  // void createFreelancer(BuildContext context) async {
  //   final freelancerProvider = context.read<FreelancerProvider>();
  //   final userProvider = context.read<UserProvider>();
  //   ProviderRequest.api(
  //     context: context,
  //     request: freelancerProvider.createFreelancer(Freelancer(
  //       user: userProvider.user,
  //     )),
  //     onSuccess: (context, res) {
  //       ProviderRequest.api(
  //         context: context,
  //         request: userProvider.getUserMe(),
  //         onSuccess: (context, res) {
  //           rootNavigator(context).pushNamedAndRemoveUntil(
  //               userProvider.getRouteForUser(res.data), (_) => false);
  //         },
  //       );
  //     },
  //   );
  // }

  Widget card({
    required BuildContext context,
    required Widget icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ContentPadding,
        decoration: BoxDecoration(
          borderRadius: AppTheme.cardBorderRadius,
          border: Border.all(
            color: context.inputTheme.border!.borderSide.color,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              height: 70,
              child: IconTheme(
                data: context.iconTheme.copyWith(
                  color: context.colorScheme.secondary,
                ),
                child: icon,
              ),
            ),
            HSizedBox12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  VSizedBox4,
                  Text(subtitle),
                ],
              ),
            ),
            const RightChevron(),
          ],
        ),
      ),
    );
  }
}
