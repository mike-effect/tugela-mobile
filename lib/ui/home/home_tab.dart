import 'package:flutter/material.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 24,
        centerTitle: false,
        title: Text(
          "Home",
          style: context
              .theme.cupertinoOverrideTheme?.textTheme?.navLargeTitleTextStyle,
        ),
      ),
    );
  }
}
