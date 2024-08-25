import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/index/notification_icon.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerTab extends StatefulWidget {
  const FreelancerTab({super.key});

  @override
  State<FreelancerTab> createState() => _FreelancerTabState();
}

class _FreelancerTabState extends State<FreelancerTab> {
  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return SliverScaffold(
      scrollController: appProvider.tabScrollControllers[1],
      appBar: AppBar(
        toolbarHeight: AppTheme.largeAppBarHeight,
        centerTitle: false,
        title: Text(
          "Talent",
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
            subtitle: "Freelancers on the platform will appear here",
          ),
        ],
      ),
    );
  }
}
