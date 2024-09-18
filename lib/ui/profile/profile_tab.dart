import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/index/account_type_view.dart';
import 'package:tugela/ui/profile/profile_company.dart';
import 'package:tugela/ui/profile/profile_freelancer.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    // final companyProvider = context.watch<CompanyProvider>();
    final appProvider = context.watch<AppProvider>();
    // final companyId = userProvider.user?.company?.id;

    return SliverScaffold(
      scrollController: appProvider.tabScrollControllers[3],
      onRefresh: () => Future.wait([
        userProvider.getUserMe(),
        // if (companyId != null) companyProvider.getCompany(companyId),
      ]),
      appBar: AppBar(
        toolbarHeight: AppTheme.largeAppBarHeight,
        centerTitle: false,
        title: Text(
          "Profile",
          style: context
              .theme.cupertinoOverrideTheme?.textTheme?.navLargeTitleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              pushNamed(context, Routes.settings, rootNavigator: true);
            },
            icon: const Icon(PhosphorIconsRegular.list),
          ),
          HSizedBox8,
        ],
      ),
      bodyPadding: ContentPadding,
      body: AccountTypeView(
        company: (context, data) {
          if (data == null) return const SizedBox.shrink();
          return ProfileCompany(company: data);
        },
        freelancer: (context, data) {
          if (data == null) return const SizedBox.shrink();
          return ProfileFreelancer(freelancer: data);
        },
      ),
    );
  }
}
