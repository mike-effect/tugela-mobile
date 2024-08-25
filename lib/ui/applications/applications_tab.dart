import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/index/notification_icon.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class ApplicationsTab extends StatefulWidget {
  const ApplicationsTab({super.key});

  @override
  State<ApplicationsTab> createState() => _ApplicationsTabState();
}

class _ApplicationsTabState extends State<ApplicationsTab> {
  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return SliverScaffold(
      scrollController: appProvider.tabScrollControllers[2],
      appBar: AppBar(
        toolbarHeight: AppTheme.largeAppBarHeight,
        centerTitle: false,
        title: Text(
          "Applications",
          style: context
              .theme.cupertinoOverrideTheme?.textTheme?.navLargeTitleTextStyle,
        ),
        actions: const [
          NotificationIcon(),
        ],
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmptyState(
            margin: ContentPadding,
            subtitle: "Job applications will be listed here",
          ),
        ],
      ),
    );
  }
}
