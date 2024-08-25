import 'dart:math' as math;

import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/utils.dart';

Widget buildSimpleRefreshIndicator(
  BuildContext context,
  cupertino.RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
  final dragging = refreshState == cupertino.RefreshIndicatorMode.drag;
  final arrow = Opacity(
    opacity: opacityCurve.transform(
      math.min(pulledExtent / refreshTriggerPullDistance, 1.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Pull down to refresh",
          style: TextStyle(
            color: cupertino.CupertinoDynamicColor.resolve(
              cupertino.CupertinoColors.inactiveGray,
              context,
            ),
          ),
        ),
        VSizedBox4,
        SizedBox(
          height: 2,
          width: math.min(
            (math.min(pulledExtent / refreshTriggerPullDistance, 1.0) *
                context.mediaWidth),
            context.mediaWidth,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.secondary,
            ),
          ),
        ),
      ],
    ),
  );
  final loader = Opacity(
    opacity: opacityCurve.transform(
      math.min(pulledExtent / refreshIndicatorExtent, 1.0),
    ),
    child: SizedBox(
      height: 2,
      child: LinearProgressIndicator(
        backgroundColor: context.isDark
            ? context.theme.colorScheme.secondary.withOpacity(0.4)
            : context.theme.colorScheme.secondary.withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation(
          context.theme.colorScheme.secondary,
        ),
      ),
    ),
  );
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: dragging ? arrow : loader,
    ),
  );
}

class SliverScaffold<T> extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PageAppBar? pageAppBar;
  final SliverAppBar? sliverAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool hasScrollBody;
  final ScrollController? scrollController;
  final cupertino.RefreshCallback? onRefresh;
  final Color? backgroundColor;
  final SliverChildDelegate? bodyListDelegate;
  final EdgeInsets? bodyPadding;
  final Widget? bottomNavigationBar;
  final bool hideAppBar;
  final bool extendBody;
  final bool unfocusOnTap;
  final bool extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget> slivers;
  final bool bottomSafeArea;
  final Future<T> Function(BuildContext context)? onLoadMore;
  final bool Function(BuildContext context)? canLoadMore;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  const SliverScaffold({
    super.key,
    this.appBar,
    this.pageAppBar,
    this.sliverAppBar,
    this.body,
    this.bodyListDelegate,
    this.bodyPadding,
    this.hasScrollBody = false,
    this.onRefresh,
    this.backgroundColor,
    this.scaffoldKey,
    this.bottomNavigationBar,
    this.hideAppBar = false,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.unfocusOnTap = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.slivers = const [],
    this.bottomSafeArea = true,
    this.onLoadMore,
    this.canLoadMore,
    this.scrollController,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  cupertino.State<SliverScaffold> createState() => _SliverScaffoldState();
}

class _SliverScaffoldState extends cupertino.State<SliverScaffold> {
  late ScrollController scrollController;
  bool isLoading = false;

  void watchScroll() {
    if (isLoading) return;
    if (!(widget.canLoadMore?.call(context) ?? false)) return;
    if (!scrollController.hasClients) return;
    final end = scrollController.position.maxScrollExtent;
    final current = scrollController.offset;
    if (current > end || isLoading) return;
    if ((current >= end - 300)) {
      fetch();
    }
  }

  fetch() async {
    if (widget.onLoadMore == null || isLoading) return;
    isLoading = true;
    if (mounted) setState(() {});
    await widget.onLoadMore?.call(context);
    isLoading = false;
    if (mounted) setState(() {});
  }

  refresh() {
    if (widget.onRefresh == null || isLoading) return;
    if (isLoading) return;
    widget.onRefresh!.call();
    HapticFeedback.mediumImpact();
    isLoading = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    scrollController = widget.scrollController ?? ScrollController();
    if (widget.onLoadMore != null) scrollController.addListener(watchScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(watchScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PrimaryScrollController(
      controller: scrollController,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: widget.appBar,
          extendBody: widget.extendBody,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          key: widget.scaffoldKey,
          backgroundColor: widget.backgroundColor,
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          body: Theme(
            data: theme.copyWith(
              appBarTheme: theme.appBarTheme.copyWith(
                backgroundColor: widget.backgroundColor,
              ),
            ),
            child: CustomScrollView(
              cacheExtent: 1000,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              controller: PrimaryScrollController.of(context),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              // primary: controller == null,
              // primary: true,
              slivers: <Widget>[
                if (!widget.hideAppBar) ...[
                  if (widget.pageAppBar != null) widget.pageAppBar!,
                  if (widget.sliverAppBar != null) widget.sliverAppBar!,
                ],
                if (widget.onRefresh != null)
                  cupertino.CupertinoSliverRefreshControl(
                    onRefresh: widget.onRefresh,
                    builder: buildSimpleRefreshIndicator,
                    refreshTriggerPullDistance: 120,
                  ),
                ...widget.slivers,
                if (widget.bodyListDelegate != null && widget.body == null)
                  SliverSafeArea(
                    top: false,
                    sliver: SliverPadding(
                      padding: (widget.bodyPadding ?? EdgeInsets.zero).add(
                        const EdgeInsetsDirectional.only(bottom: 100),
                      ),
                      sliver: SliverList(delegate: widget.bodyListDelegate!),
                    ),
                  )
                else
                  SliverFillRemaining(
                    hasScrollBody: widget.hasScrollBody,
                    child: SafeArea(
                      top: false,
                      bottom: widget.bottomSafeArea,
                      child: Padding(
                        padding: widget.bodyPadding ?? EdgeInsets.zero,
                        child: widget.body ?? const SizedBox(),
                      ),
                    ),
                  ),
                if (isLoading)
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 32),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(
                          backgroundColor: context.isDark
                              ? context.theme.colorScheme.secondary
                                  .withOpacity(0.4)
                              : context.theme.colorScheme.secondary
                                  .withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation(
                            context.theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class PageBackIcon extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const PageBackIcon({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = Theme.of(context).appBarTheme.iconTheme;
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    if (!(ModalRoute.of(context)?.canPop ?? false)) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        container: true,
        excludeSemantics: true,
        label: 'Back',
        button: true,
        child: IconTheme(
          data: iconTheme!.copyWith(color: color),
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 0),
            child: parentRoute is PageRoute<dynamic> &&
                    parentRoute.fullscreenDialog
                ? const Icon(Icons.close)
                : const BackButtonIcon(),
          ),
        ),
      ),
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}

class PageAppBar extends StatelessWidget {
  final Widget? leading;
  final Widget? largeTitle;
  final Widget? middle;
  final Widget? trailing;
  final Color? backgroundColor;
  final EdgeInsetsDirectional? padding;
  final bool automaticallyImplyLeading;
  final bool automaticallyImplyTitle;
  const PageAppBar({
    super.key,
    this.leading,
    this.largeTitle,
    this.middle,
    this.trailing,
    this.backgroundColor,
    this.padding,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyTitle = true,
  });

  Widget? _wrapWithMediaQuery(BuildContext context, Widget? child) {
    if (child == null) return null;
    return MediaQuery(
      data: context.mediaQuery.copyWith(
        textScaler: MediaQuery.textScalerOf(context),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PageAppBar(
      leading: _wrapWithMediaQuery(context, leading ?? const PageBackIcon()),
      largeTitle: _wrapWithMediaQuery(context, largeTitle),
      middle: _wrapWithMediaQuery(context, middle),
      backgroundColor:
          backgroundColor ?? context.theme.appBarTheme.backgroundColor,
      padding: padding,
      trailing: Material(
        type: MaterialType.transparency,
        child: trailing,
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      automaticallyImplyTitle: automaticallyImplyTitle,
    );
  }
}

class _PageAppBar extends cupertino.CupertinoSliverNavigationBar {
  const _PageAppBar({
    super.key,
    super.leading,
    super.largeTitle,
    super.middle,
    super.trailing,
    super.backgroundColor,
    super.padding,
    super.automaticallyImplyLeading,
    super.automaticallyImplyTitle,
  }) : super(
          border: const Border(),
          heroTag: "$key",
        );
}

class SliverHeader extends StatelessWidget {
  final Widget child;
  final double height;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  const SliverHeader({
    super.key,
    required this.child,
    required this.height,
    this.decoration,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(
        height: height,
        child: child,
        decoration: decoration,
        padding: padding,
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  const _SliverHeaderDelegate({
    required this.child,
    required this.height,
    required this.decoration,
    required this.padding,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return oldDelegate.decoration != decoration || oldDelegate.child != child;
  }
}
