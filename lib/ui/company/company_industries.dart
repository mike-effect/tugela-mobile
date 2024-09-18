import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/skeleton.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class CompanyIndustries extends StatefulWidget {
  final Industry? selected;
  const CompanyIndustries({super.key, required this.selected});

  @override
  State<CompanyIndustries> createState() => _CompanyIndustriesState();
}

class _CompanyIndustriesState extends State<CompanyIndustries> {
  @override
  void initState() {
    final p = context.read<CompanyProvider>();
    if (p.industries.isEmpty) {
      p.getCompanyIndustries();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final appProvider = context.watch<AppProvider>();
    final companyProvider = context.watch<CompanyProvider>();

    final feed = loadingPlaceholder<Industry>(
      context: context,
      value: companyProvider.industries.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return ListTile(
          title: Skeleton(context).rect(height: 12, width: 80),
        );
      },
      emptyStateBuilder: (context) {
        return const SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPaddingH,
            title: "Nothing here yet 🍃",
            subtitle: "Company industries will show up here to choose from",
          ),
        );
      },
      builder: (context, list) {
        return SliverList.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            final item = list[index];
            return RadioListTile<Industry>(
              value: item,
              groupValue: widget.selected,
              visualDensity: VisualDensity.compact,
              title: Text(item.name ?? ''),
              activeColor: context.colorScheme.secondary,
              onChanged: (value) {
                Navigator.of(context).pop(item);
              },
            );
          },
        );
      },
    );
    return SliverScaffold(
      onRefresh: () => Future.wait([
        companyProvider.getCompanyIndustries(
          options: const PaginatedOptions(refresh: true),
        ),
      ]),
      canLoadMore: (_) => companyProvider.industries.canLoadMore,
      onLoadMore: (_) {
        return companyProvider.getCompanyIndustries(
          options: const PaginatedOptions(loadMore: true),
        );
      },
      appBar: AppBar(
        title: const Text("Company Industry"),
      ),
      slivers: [
        feed,
      ],
    );
  }
}
