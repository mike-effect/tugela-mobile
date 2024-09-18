import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/job_submission.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/ui/applications/application_card.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class JobSubmissionList extends StatefulWidget {
  final String? mapId;
  final Map<String, dynamic> params;
  const JobSubmissionList({
    super.key,
    this.mapId = "",
    this.params = const {},
  });

  @override
  State<JobSubmissionList> createState() => _JobSubmissionListState();
}

class _JobSubmissionListState extends State<JobSubmissionList> {
  @override
  void initState() {
    final jobProvider = context.read<JobProvider>();
    if (jobProvider.jobSubmissions[widget.mapId]?.isEmpty ?? true) {
      jobProvider.getJobSubmissions(
        params: widget.params,
        mapId: widget.mapId,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    final feed = loadingPlaceholder<JobSubmission>(
      context: context,
      value: jobProvider.jobSubmissions[widget.mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const JobCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return const SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPaddingH,
            title: "Nothing here yet 🍃",
            subtitle: "Applications that are assigned will show up here",
          ),
        );
      },
      builder: (context, data) {
        return SliverList.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: context.theme.dividerTheme.color,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final submission = data[index];
            return ApplicationCard(application: submission.application!);
          },
          itemCount: data.length,
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
        title: const Text("Job Submissions"),
      ),
      slivers: [
        feed,
      ],
    );
  }
}
