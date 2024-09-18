import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/ui/company/company_card.dart';
import 'package:tugela/ui/jobs/job_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class CompanyList extends StatefulWidget {
  final String? title;
  final String? mapId;
  final Map<String, dynamic> params;
  const CompanyList({
    super.key,
    this.title,
    required this.mapId,
    required this.params,
  });

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  @override
  void initState() {
    final companyProvider = context.read<CompanyProvider>();
    if (companyProvider.companies[widget.mapId]?.isEmpty ?? true) {
      companyProvider.getCompanies(
          params: widget.params, mapId: widget.mapId ?? "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();

    final feed = loadingPlaceholder<Company>(
      context: context,
      value: companyProvider.companies[widget.mapId]?.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return const JobCardPlaceholder();
      },
      emptyStateBuilder: (context) {
        return const SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPaddingH,
            title: "Nothing here yet 🍃",
            subtitle: "Companies on the platform will show up here",
          ),
        );
      },
      builder: (context, data) {
        return SliverList.separated(
          separatorBuilder: (context, index) => VSizedBox12,
          itemBuilder: (BuildContext context, int index) {
            final company = data[index];
            return Padding(
              padding: ContentPaddingH,
              child: CompanyCard(company: company),
            );
          },
          itemCount: data.length,
        );
      },
    );

    return SliverScaffold(
      onRefresh: () => Future.wait([
        companyProvider.getCompanies(
          mapId: widget.mapId ?? "",
          params: widget.params,
        ),
      ]),
      canLoadMore: (_) =>
          companyProvider.companies[widget.mapId]?.canLoadMore ?? false,
      onLoadMore: (context) {
        return companyProvider.getCompanies(
          mapId: widget.mapId ?? "",
          params: widget.params,
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: Text(widget.title ?? "Explore Companies"),
      ),
      slivers: [
        feed,
      ],
    );
  }
}
