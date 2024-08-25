import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/home/home_company.dart';
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
  @override
  void initState() {
    final companyProvider = context.read<CompanyProvider>();
    final companyId = companyProvider.user?.company?.id;
    if (companyId != null) {
      companyProvider.getCompany(companyProvider.user!.company!.id!);
    }
    final jobProvider = context.read<JobProvider>();
    jobProvider.getJobs(
      mapId: jobProvider.user?.company?.id,
      params: {"company": jobProvider.user?.company?.id},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final userProvider = context.watch<UserProvider>();
    final companyProvider = context.watch<CompanyProvider>();
    final user = userProvider.user;
    final jobProvider = context.watch<JobProvider>();

    final feed = loadingPlaceholder<Job>(
      context: context,
      value: jobProvider.jobs[user?.company?.id]?.data,
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
        jobProvider.getJobs(
          mapId: user?.company?.id,
          params: {"company": user?.company?.id},
        ),
        companyProvider.getCompany(companyProvider.user!.company!.id!),
      ]),
      appBar: AppBar(
        toolbarHeight: AppTheme.largeAppBarHeight,
        centerTitle: false,
        title: Text(
          "Home",
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
            company: (context, company) {
              return Column(
                children: [
                  if (company != null) HomeCompany(company: company),
                ],
              );
            },
          ),
        ),
        feed,
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(
            context: context,
            builder: (_) => const JobCreate(),
            rootNavigator: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
