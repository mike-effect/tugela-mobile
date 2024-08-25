import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/ui/company/company_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/menu_list_tile.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return SliverScaffold(
      pageAppBar: const PageAppBar(
        largeTitle: Text("Settings"),
      ),
      bodyPadding: ContentPadding,
      body: Column(
        children: [
          MenuListTile(
            iconData: PhosphorIconsRegular.user,
            title: "Edit Profile",
            onTap: () {
              push(
                context: context,
                builder: (_) => CompanyCreate(
                  company: userProvider.user?.company,
                ),
              );
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
