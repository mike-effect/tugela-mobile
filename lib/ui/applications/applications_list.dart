import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/job_application.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/ui/applications/application_card.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class ApplicationList extends StatefulWidget {
  final String? title;
  final String? mapId;
  final Map<String, dynamic> params;
  const ApplicationList({
    super.key,
    this.title,
    required this.mapId,
    required this.params,
  });

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  @override
  void initState() {
    final jobProvider = context.read<JobProvider>();
    if (jobProvider.applications[widget.mapId]?.isEmpty ?? true) {
      jobProvider.getJobApplications(
        params: widget.params,
        mapId: widget.mapId,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    final feed = loadingPlaceholder<JobApplication>(
      context: context,
      value: jobProvider.applications[widget.mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const JobCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return const SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPaddingH,
            title: "Nothing here yet 🍃",
            subtitle: "Applications that are submitted will show up here",
          ),
        );
      },
      builder: (context, jobs) {
        return SliverList.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: context.theme.dividerTheme.color,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final job = jobs[index];
            return ApplicationCard(application: job);
          },
          itemCount: jobs.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        jobProvider.getJobApplications(
          mapId: widget.mapId,
          params: widget.params,
        ),
      ]),
      canLoadMore: (_) =>
          jobProvider.applications[widget.mapId]?.canLoadMore ?? false,
      onLoadMore: (context) {
        return jobProvider.getJobApplications(
          mapId: widget.mapId,
          params: widget.params,
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: Text(widget.title ?? "Job Applications"),
      ),
      slivers: [
        feed,
      ],
    );
  }
}
