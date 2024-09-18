import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/home/home_company.dart';
import 'package:tugela/ui/home/home_freelancer.dart';
import 'package:tugela/ui/index/account_type_view.dart';
import 'package:tugela/ui/index/notification_icon.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/ui/jobs/job_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Map<String, dynamic> get params {
    final jobProvider = context.read<JobProvider>();
    if (jobProvider.isCompany) {
      return {"company": jobProvider.user?.company?.id};
    }
    return {"freelancer": jobProvider.user?.freelancer?.id};
  }

  @override
  void initState() {
    final jobProvider = context.read<JobProvider>();
    jobProvider.getJobs(mapId: jobProvider.user?.company?.id, params: params);
    final userProvider = context.read<UserProvider>();
    if (jobProvider.user?.xrpAddress != null) {
      userProvider.getBalance(jobProvider.user!.xrpAddress!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final jobProvider = context.watch<JobProvider>();
    final address = userProvider.user?.xrpAddress;

    final feed = loadingPlaceholder<Job>(
      context: context,
      value: jobProvider.jobs[user?.company?.id ?? '']?.data,
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
            final job = jobs[index];
            return JobCard(job: job);
          },
          itemCount: jobs.length,
        );
      },
    );

    return SliverScaffold(
      scrollController: appProvider.tabScrollControllers[0],
      onRefresh: () => Future.wait([
        if (address != null) userProvider.getBalance(address),
        jobProvider.getJobs(
          mapId: user?.company?.id,
          params: params,
        ),
      ]),
      appBar: AppBar(
        toolbarHeight: AppTheme.largeAppBarHeight,
        centerTitle: false,
        title: Text(
          userProvider.isCompany ? "Dashboard" : "Home",
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
              return HomeFreelancer(freelancer: freelancer);
            },
            company: (context, company) {
              if (company == null) return const SizedBox.shrink();
              return HomeCompany(company: company);
            },
          ),
        ),
        feed,
      ],
      floatingActionButton: userProvider.isCompany
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                push(
                  context: context,
                  builder: (_) => const JobCreate(),
                  rootNavigator: true,
                );
              },
            )
          : null,
    );
  }
}
