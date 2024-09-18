import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/applications/application_card.dart';
import 'package:tugela/ui/applications/applications_company.dart';
import 'package:tugela/ui/applications/applications_freelancer.dart';
import 'package:tugela/ui/index/account_type_view.dart';
import 'package:tugela/ui/index/notification_icon.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class ApplicationsTab extends StatefulWidget {
  const ApplicationsTab({super.key});

  @override
  State<ApplicationsTab> createState() => _ApplicationsTabState();
}

class _ApplicationsTabState extends State<ApplicationsTab> {
  String get mapId {
    final jobProvider = context.read<JobProvider>();

    return jobProvider.isFreelancer
        ? jobProvider.user?.freelancer?.id ?? ""
        : jobProvider.user?.company?.id ?? "";
  }

  Map<String, dynamic> get params {
    final jobProvider = context.read<JobProvider>();
    if (jobProvider.isCompany) {
      return {"company": mapId};
    }
    return {"freelancer": mapId};
  }

  @override
  void initState() {
    super.initState();
    final jobProvider = context.read<JobProvider>();
    jobProvider.getJobApplications(mapId: mapId, params: params);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final jobProvider = context.watch<JobProvider>();
    // final userProvider = context.watch<UserProvider>();
    // final user = userProvider.user;

    final feed = loadingPlaceholder<JobApplication>(
      context: context,
      value: jobProvider.applications[mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const JobCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return const SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPadding,
            subtitle: "Job applications will be listed here",
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
            final item = list[index];
            return ApplicationCard(application: item);
          },
          itemCount: list.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        jobProvider.getJobApplications(
          mapId: mapId,
          params: params,
        ),
      ]),
      canLoadMore: (_) => jobProvider.applications[mapId]?.canLoadMore ?? false,
      onLoadMore: (_) => jobProvider.getJobApplications(
        mapId: mapId,
        params: params,
        options: const PaginatedOptions(loadMore: true),
      ),
      scrollController: appProvider.tabScrollControllers[2],
      appBar: AppBar(
        toolbarHeight: AppTheme.largeAppBarHeight,
        centerTitle: false,
        title: Text(
          "Applications",
          style: context
              .theme.cupertinoOverrideTheme?.textTheme?.navLargeTitleTextStyle,
        ),
        actions: const [
          NotificationIcon(),
        ],
      ),
      slivers: [
        SliverToBoxAdapter(
          child: AccountTypeView(
            freelancer: (context, freelancer) {
              if (freelancer == null) return const SizedBox.shrink();
              return ApplicationsFreelancer(freelancer: freelancer);
            },
            company: (context, company) {
              if (company == null) return const SizedBox.shrink();
              return ApplicationsCompany(company: company);
            },
          ),
        ),
        feed,
      ],
    );
  }
}
