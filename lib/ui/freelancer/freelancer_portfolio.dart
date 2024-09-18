import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/models/portfolio_item.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio_card.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/loading_placeholder.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerPortfolio extends StatefulWidget {
  final String? title;
  final String mapId;
  final Map<String, dynamic> params;
  const FreelancerPortfolio({
    super.key,
    required this.mapId,
    this.params = const {},
    this.title,
  });

  @override
  State<FreelancerPortfolio> createState() => _FreelancerPortfolioState();
}

class _FreelancerPortfolioState extends State<FreelancerPortfolio> {
  @override
  void initState() {
    final provider = context.read<FreelancerProvider>();
    // if (provider.portfolioItems[widget.mapId]?.isEmpty ?? false) {
    provider.getPortfolioItems(
      params: widget.params,
      freelancerId: widget.mapId,
    );
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FreelancerProvider>();

    final feed = loadingPlaceholder<PortfolioItem>(
      context: context,
      value: provider.portfolioItems[widget.mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const FreelancerPortfolioCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPadding.copyWith(top: 44),
            title: "Nothing here yet 🍃",
            subtitle: "Portfolio items that are posted will show up here",
          ),
        );
      },
      builder: (context, list) {
        return SliverList.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: context.theme.dividerTheme.color,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return FreelancerPortfolioCard(portfolio: list[index]);
          },
          itemCount: list.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        provider.getPortfolioItems(
          freelancerId: widget.mapId,
          params: widget.params,
        ),
      ]),
      canLoadMore: (_) =>
          provider.portfolioItems[widget.mapId]?.canLoadMore ?? false,
      onLoadMore: (context) {
        return provider.getPortfolioItems(
          freelancerId: widget.mapId,
          params: widget.params,
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: Text(widget.title ?? "Projects"),
      ),
      slivers: [
        feed,
      ],
      floatingActionButton: provider.user?.freelancer?.id == widget.mapId
          ? FloatingActionButton(
              onPressed: () async {
                final res = await push(
                  context: context,
                  builder: (_) => const FreelancerPortfolioCreate(),
                  rootNavigator: true,
                );
                if (res ?? false) {
                  provider.getPortfolioItems(
                    freelancerId: widget.mapId,
                    params: widget.params,
                  );
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
