import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/ui/company/company_create.dart';
import 'package:tugela/ui/freelancer/freelancer_create.dart';
import 'package:tugela/ui/freelancer/freelancer_experiences.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio.dart';
import 'package:tugela/ui/freelancer/freelancer_services.dart';
import 'package:tugela/ui/settings/settings_payments.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/menu_list_tile.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final accountType = userProvider.user?.accountType;

    return SliverScaffold(
      pageAppBar: const PageAppBar(
        largeTitle: Text("Settings"),
      ),
      bodyPadding: ContentPadding,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VSizedBox16,
          if (userProvider.isCompany) ...[
            Text(
              "Company".toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 0.4,
                color: context.textTheme.bodySmall?.color,
              ),
            ),
            MenuListTile(
              iconData: PhosphorIconsRegular.building,
              title: "Company Profile",
              onTap: () {
                push(
                  context: context,
                  builder: (_) => CompanyCreate(
                    company: userProvider.user?.company,
                  ),
                );
              },
            ),
          ] else ...[
            Text(
              "Freelancer".toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 0.4,
                color: context.textTheme.bodySmall?.color,
              ),
            ),
            MenuListTile(
              iconData: PhosphorIconsRegular.user,
              title: "Freelancer Profile",
              onTap: () {
                push(
                  context: context,
                  builder: (_) => FreelancerCreate(
                    freelancer: userProvider.user?.freelancer,
                  ),
                );
              },
            ),
            MenuListTile(
              iconData: PhosphorIconsRegular.readCvLogo,
              title: "Portfolio",
              onTap: () {
                push(
                  context: context,
                  rootNavigator: true,
                  builder: (_) => FreelancerPortfolio(
                    title: 'My Portfolio',
                    mapId: userProvider.user?.freelancer?.id ?? "",
                  ),
                );
              },
            ),
            MenuListTile(
              iconData: PhosphorIconsRegular.globe,
              title: "Work Experience",
              onTap: () {
                push(
                  context: context,
                  rootNavigator: true,
                  builder: (_) => FreelancerWorkExperience(
                    title: 'Work Experience',
                    mapId: userProvider.user?.freelancer?.id ?? "",
                  ),
                );
              },
            ),
            MenuListTile(
              iconData: PhosphorIconsRegular.cardsThree,
              title: "Services",
              onTap: () {
                push(
                  context: context,
                  rootNavigator: true,
                  builder: (_) => FreelancerServices(
                    title: 'Services',
                    mapId: userProvider.user?.freelancer?.id ?? "",
                  ),
                );
              },
            ),
          ],
          if (accountType != null) ...[
            VSizedBox24,
            Text(
              "Payments".toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 0.4,
                color: context.textTheme.bodySmall?.color,
              ),
            ),
            MenuListTile(
              iconData: PhosphorIconsRegular.wallet,
              title: "Wallet",
              onTap: () {
                push(
                  context: context,
                  builder: (_) => SettingsPayments(accountType: accountType),
                );
              },
            ),
          ],
          VSizedBox24,
          Text(
            "About".toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 0.4,
              color: context.textTheme.bodySmall?.color,
            ),
          ),
          MenuListTile(
            iconData: PhosphorIconsRegular.link,
            title: "Visit website",
            onTap: () {
              openLink(AppConfig.siteUrl);
            },
          ),
          MenuListTile(
            iconData: PhosphorIconsRegular.shieldCheck,
            title: "Privacy Policy",
            onTap: () {
              openLink(AppConfig.privacyUrl);
            },
          ),
          MenuListTile(
            iconData: PhosphorIconsRegular.info,
            title: "Terms of Service",
            onTap: () {
              openLink(AppConfig.termsUrl);
            },
          ),
          const MenuListTile(
            iconData: PhosphorIconsRegular.info,
            title: "App version",
            showChevron: false,
            trailing: _VersionNumber(),
          ),
          VSizedBox24,
          Text(
            "ACCOUNT".toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 0.4,
              color: context.textTheme.bodySmall?.color,
            ),
          ),
          MenuListTile(
            color: context.colorScheme.error,
            iconData: PhosphorIconsRegular.trashSimple,
            title: "Permanently Delete Account",
            onTap: () async {
              String supportEmail = "info@tugela.co";
              String subject =
                  Uri.encodeComponent("Request for Account Deletion");
              String body = Uri.encodeComponent(
                "Hello Support,"
                "\n\nI would like to request the deletion of my "
                "account associated with this ${userProvider.user?.email ?? 'email address'}. "
                "Please confirm once the deletion has been completed."
                "\n\nThank you."
                "\n\nBest regards,"
                "\n${(userProvider.user?.freelancer?.fullname ?? userProvider.user?.company?.name ?? '')}",
              );

              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: supportEmail,
                query: 'subject=$subject&body=$body',
              );

              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                openLink("https://tugela.co/delete-my-data/");
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colorScheme.error,
          ),
          onPressed: () {
            userProvider.logout();
          },
          child: const Text("Log out"),
        ),
      ),
    );
  }
}

class _VersionNumber extends StatefulWidget {
  const _VersionNumber();
  @override
  __VersionNumberState createState() => __VersionNumberState();
}

class __VersionNumberState extends State<_VersionNumber> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      _version = info.version;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      _version,
      textAlign: TextAlign.center,
    );
  }
}
