import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/job_submission.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class JobSubmissionsList extends StatefulWidget {
  final String? title;
  final String? mapId;
  final Map<String, dynamic> params;
  const JobSubmissionsList({
    super.key,
    this.title,
    required this.mapId,
    required this.params,
  });

  @override
  State<JobSubmissionsList> createState() => _JobSubmissionsListState();
}

class _JobSubmissionsListState extends State<JobSubmissionsList> {
  @override
  void initState() {
    final jobProvider = context.read<JobProvider>();
    // if (p != null && p.isEmpty) {
    jobProvider.getJobSubmissions(params: widget.params, mapId: widget.mapId);
    // }
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
            subtitle: "Jobs that are posted will show up here",
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
            return const SizedBox();
            // return JobCard(job: job);
          },
          itemCount: jobs.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        jobProvider.getJobSubmissions(
          mapId: widget.mapId,
          params: widget.params,
        ),
      ]),
      canLoadMore: (_) =>
          jobProvider.jobSubmissions[widget.mapId]?.canLoadMore ?? false,
      onLoadMore: (context) {
        return jobProvider.getJobs(
          mapId: widget.mapId,
          params: widget.params,
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: Text(widget.title ?? "Job Submissions"),
      ),
      slivers: [
        feed,
      ],
    );
  }
}
