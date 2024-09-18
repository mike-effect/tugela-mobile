import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/models/work_experience.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/ui/freelancer/freelancer_experience_card.dart';
import 'package:tugela/ui/freelancer/freelancer_experience_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/loading_placeholder.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerWorkExperience extends StatefulWidget {
  final String? title;
  final String mapId;
  final Map<String, dynamic> params;
  const FreelancerWorkExperience({
    super.key,
    required this.mapId,
    this.params = const {},
    this.title,
  });

  @override
  State<FreelancerWorkExperience> createState() =>
      _FreelancerWorkExperienceState();
}

class _FreelancerWorkExperienceState extends State<FreelancerWorkExperience> {
  @override
  void initState() {
    final provider = context.read<FreelancerProvider>();
    // if (provider.workExperiences[widget.mapId]?.isEmpty ?? false) {
    provider.getWorkExperiences(
      params: widget.params,
      freelancerId: widget.mapId,
    );
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FreelancerProvider>();

    final feed = loadingPlaceholder<WorkExperience>(
      context: context,
      value: provider.workExperiences[widget.mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const FreelancerExperienceCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPadding.copyWith(top: 44),
            title: "Nothing here yet 🍃",
            subtitle: "Work experiences that are posted will show up here",
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
            return FreelancerExperienceCard(experience: list[index]);
          },
          itemCount: list.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        provider.getWorkExperiences(
          freelancerId: widget.mapId,
          params: widget.params,
        ),
      ]),
      canLoadMore: (_) =>
          provider.workExperiences[widget.mapId]?.canLoadMore ?? false,
      onLoadMore: (context) {
        return provider.getWorkExperiences(
          freelancerId: widget.mapId,
          params: widget.params,
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: Text(widget.title ?? "Work Experience"),
      ),
      slivers: [
        feed,
      ],
      floatingActionButton: provider.user?.freelancer?.id == widget.mapId
          ? FloatingActionButton(
              onPressed: () async {
                final res = await push(
                  context: context,
                  builder: (_) => const FreelancerExperienceCreate(),
                  rootNavigator: true,
                );
                if (res ?? false) {
                  provider.getWorkExperiences(
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
