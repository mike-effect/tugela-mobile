import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/company/company_card.dart';
import 'package:tugela/ui/company/company_list.dart';
import 'package:tugela/ui/freelancer/freelancer_details.dart';
import 'package:tugela/ui/freelancer/freelancers_list.dart';
import 'package:tugela/ui/index/notification_icon.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/section_header.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final mapId = "";

  @override
  void initState() {
    super.initState();
    final freelancerProvider = context.read<FreelancerProvider>();
    freelancerProvider.getFreelancers(mapId: mapId);
    freelancerProvider.getServices(mapId: mapId);
    final companyProvider = context.read<CompanyProvider>();
    companyProvider.getCompanies(mapId: mapId);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final companyProvider = context.watch<CompanyProvider>();
    final freelancerProvider = context.watch<FreelancerProvider>();
    final freelancers = freelancerProvider.freelancers[mapId];
    final companies = companyProvider.companies[mapId]?.data;

    // final servicesFeed = loadingPlaceholder<FreelancerService>(
    //   context: context,
    //   value: freelancerProvider.services[mapId]?.data,
    //   placeholderCount: 3,
    //   placeholderBuilder: (context) {
    //     return const JobCardPlaceholder();
    //   },
    //   emptyStateBuilder: (context) {
    //     return const SliverToBoxAdapter(
    //       child: EmptyState(
    //         margin: ContentPaddingH,
    //         title: "Nothing here yet 🍃",
    //         subtitle: "Services by freelancers will show up here",
    //       ),
    //     );
    //   },
    //   builder: (context, data) {
    //     return SliverList.builder(
    //       // separatorBuilder: (context, index) {
    //       //   return Divider(height: 1, color: context.theme.dividerTheme.color);
    //       // },
    //       itemBuilder: (BuildContext context, int index) {
    //         final model = data[index];
    //         return ListTile(
    //           visualDensity: VisualDensity.compact,
    //           title: Text((model.title ?? '')),
    //           subtitle: Text(
    //             [
    //               'Starting at ${formatAmount(model.startingPrice, customFormat: NumberFormat.compactSimpleCurrency(name: model.currency), factor: 1)}',
    //               if (model.deliveryTime != null)
    //                 'Delivery time: ${model.deliveryTime}',
    //             ].join(' ・ '),
    //             style: const TextStyle(
    //               // fontWeight: FontWeight.w600,
    //               fontSize: 14,
    //             ),
    //           ),
    //         );
    //       },
    //       itemCount: min(data.length, 3),
    //     );
    //   },
    // );

    final freelancersFeed = loadingPlaceholder<Freelancer>(
      context: context,
      value: freelancerProvider.freelancers[mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const JobCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return const SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPaddingH,
            title: "Nothing here yet 🍃",
            subtitle: "Freelancers will show up here",
          ),
        );
      },
      builder: (context, data) {
        return SliverList.builder(
          // separatorBuilder: (context, index) {
          //   return Divider(height: 1, color: context.theme.dividerTheme.color);
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
      scrollController: appProvider.tabScrollControllers[1],
      onRefresh: () => Future.wait([
        // freelancerProvider.getServices(mapId: mapId),
        freelancerProvider.getFreelancers(mapId: mapId),
        companyProvider.getCompanies(mapId: mapId),
      ]),
      canLoadMore: (_) => freelancers?.canLoadMore ?? false,
      onLoadMore: (_) => freelancerProvider.getFreelancers(
        mapId: mapId,
        options: const PaginatedOptions(loadMore: true),
      ),
      appBar: AppBar(
        toolbarHeight: AppTheme.largeAppBarHeight,
        centerTitle: false,
        title: Text(
          "Explore",
          style: context
              .theme.cupertinoOverrideTheme?.textTheme?.navLargeTitleTextStyle,
        ),
        actions: const [
          NotificationIcon(),
        ],
      ),
      slivers: [
        if ((companies ?? []).isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Column(
              children: [
                SectionHeader(
                  title: "Companies",
                  padding: ContentPadding,
                  list: companies ?? [],
                  onViewAll: (context) {
                    push(
                      context: context,
                      rootNavigator: true,
                      builder: (_) => CompanyList(
                        mapId: mapId,
                        params: const {},
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 145,
                  width: context.mediaWidth,
                  child: ListView.separated(
                    itemCount: (companies ?? []).length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => HSizedBox16,
                    padding: ContentPaddingH,
                    itemBuilder: (context, index) {
                      final company = (companies ?? [])[index];
                      return SizedBox(
                        width: context.mediaWidth - 80,
                        child: CompanyCard(company: company),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: VSizedBox24),
        ],
        // if ((freelancerProvider.services[mapId]?.data ?? []).isNotEmpty) ...[
        //   SliverToBoxAdapter(
        //     child: SectionHeader(
        //       title: "Services",
        //       padding: ContentPadding,
        //       list: freelancerProvider.services[mapId]?.data ?? [],
        //     ),
        //   ),
        //   servicesFeed,
        //   const SliverToBoxAdapter(child: VSizedBox24),
        // ],
        SliverToBoxAdapter(
          child: SectionHeader(
            title: "Freelancers",
            padding: ContentPadding,
            list: freelancers?.data ?? [],
            onViewAll: (context) {
              push(
                context: context,
                rootNavigator: true,
                builder: (_) => FreelancersList(
                  mapId: mapId,
                  params: const {},
                ),
              );
            },
          ),
        ),
        freelancersFeed,
      ],
    );
  }
}
