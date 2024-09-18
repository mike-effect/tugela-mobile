import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/ui/freelancer/freelancer_details.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancersList extends StatefulWidget {
  final String? title;
  final String? mapId;
  final Map<String, dynamic> params;
  const FreelancersList({
    super.key,
    this.title,
    required this.mapId,
    required this.params,
  });

  @override
  State<FreelancersList> createState() => _FreelancersListState();
}

class _FreelancersListState extends State<FreelancersList> {
  @override
  void initState() {
    final freelancerProvider = context.read<FreelancerProvider>();
    if (freelancerProvider.freelancers[widget.mapId]?.isEmpty ?? true) {
      freelancerProvider.getFreelancers(
          params: widget.params, mapId: widget.mapId ?? "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final freelancerProvider = context.watch<FreelancerProvider>();

    final feed = loadingPlaceholder<Freelancer>(
      context: context,
      value: freelancerProvider.freelancers[widget.mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const JobCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return const SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPaddingH,
            title: "Nothing here yet 🍃",
            subtitle: "Freelancers on the platform will show up here",
          ),
        );
      },
      builder: (context, data) {
        return SliverList.builder(
          // separatorBuilder: (context, index) {
          //   return Divider(
          //     height: 1,
          //     color: context.theme.dividerTheme.color,
          //   );
          // },
          itemBuilder: (BuildContext context, int index) {
            final freelancer = data[index];
            return ListTile(
              leading: AppAvatar(
                radius: 24,
                imageUrl: freelancer.profileImage,
              ),
              title: Text(freelancer.fullname ?? ''),
              subtitle: Text(
                [
                  (freelancer.title ?? ''),
                  (freelancer.location ?? '').titleCase,
                ].join(' in '),
              ),
              onTap: () {
                push(
                  context: context,
                  builder: (_) => FreelancerDetails(freelancer: freelancer),
                  rootNavigator: true,
                );
              },
            );
          },
          itemCount: data.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        freelancerProvider.getFreelancers(
          mapId: widget.mapId ?? "",
          params: widget.params,
        ),
      ]),
      canLoadMore: (_) =>
          freelancerProvider.freelancers[widget.mapId]?.canLoadMore ?? false,
      onLoadMore: (context) {
        return freelancerProvider.getFreelancers(
          mapId: widget.mapId ?? "",
          params: widget.params,
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: Text(widget.title ?? "Explore Freelancers"),
      ),
      slivers: [
        feed,
      ],
    );
  }
}
