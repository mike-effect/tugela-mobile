import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/freelancer_service.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/ui/freelancer/freelancer_service_card.dart';
import 'package:tugela/ui/freelancer/freelancer_services_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/loading_placeholder.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerServices extends StatefulWidget {
  final String? title;
  final String mapId;
  final Map<String, dynamic> params;
  const FreelancerServices({
    super.key,
    required this.mapId,
    this.params = const {},
    this.title,
  });

  @override
  State<FreelancerServices> createState() => _FreelancerServicesState();
}

class _FreelancerServicesState extends State<FreelancerServices> {
  @override
  void initState() {
    final provider = context.read<FreelancerProvider>();
    // if (provider.services[widget.mapId]?.isEmpty ?? false) {
    provider.getServices(
      params: widget.params,
      mapId: widget.mapId,
    );
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FreelancerProvider>();

    final feed = loadingPlaceholder<FreelancerService>(
      context: context,
      value: provider.services[widget.mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const FreelancerServiceCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPadding.copyWith(top: 44),
            title: "Nothing here yet 🍃",
            subtitle: "Services that are posted will show up here",
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
            return FreelancerServiceCard(service: list[index]);
          },
          itemCount: list.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        provider.getServices(
          mapId: widget.mapId,
          params: widget.params,
        ),
      ]),
      canLoadMore: (_) => provider.services[widget.mapId]?.canLoadMore ?? false,
      onLoadMore: (context) {
        return provider.getServices(
          mapId: widget.mapId,
          params: widget.params,
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: Text(widget.title ?? "Services"),
      ),
      slivers: [
        feed,
      ],
      floatingActionButton: provider.user?.freelancer?.id == widget.mapId
          ? FloatingActionButton(
              onPressed: () async {
                final res = await push(
                  context: context,
                  builder: (_) => const FreelancerServiceCreate(),
                  rootNavigator: true,
                );
                if (res ?? false) {
                  provider.getServices(
                    mapId: widget.mapId,
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
