import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/empty_state.dart';
import 'package:tugela/widgets/layout/loading_placeholder.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class CompanyValues extends StatefulWidget {
  final List<CompanyValue> selected;
  const CompanyValues({super.key, this.selected = const []});

  @override
  State<CompanyValues> createState() => _CompanyValuesState();
}

class _CompanyValuesState extends State<CompanyValues> {
  List<CompanyValue> selected = [];

  @override
  void initState() {
    selected = List.from(widget.selected);
    final p = context.read<CompanyProvider>();
    if (p.companyValues.isEmpty) {
      p.getCompanyValues();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const maxSelect = 6;
    final companyProvider = context.watch<CompanyProvider>();

    final feed = loadingPlaceholder<CompanyValue>(
      context: context,
      value: companyProvider.companyValues.data,
      placeholderCount: 10,
      placeholderBuilder: (context) {
        return Wrap(
          spacing: 6,
          runSpacing: 0,
          children: [
            ...List.generate(100, (index) {
              return RawChip(label: Text("    " * 3));
            })
          ],
        );
      },
      emptyStateBuilder: (context) {
        return SliverToBoxAdapter(
          child: EmptyState(
            margin: ContentPadding.copyWith(top: 44),
            title: "Nothing here yet 🍃",
            subtitle: "Company values will show up here to choose from",
          ),
        );
      },
      builder: (context, list) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: ContentPadding,
            child: Wrap(
              spacing: 8,
              children: list.map((option) {
                final isSelected = selected.contains(option);
                return RawChip(
                  backgroundColor:
                      isSelected ? context.textTheme.bodyMedium?.color : null,
                  labelStyle: isSelected
                      ? TextStyle(color: context.colorScheme.surface)
                      : null,
                  iconTheme: isSelected
                      ? IconThemeData(color: context.colorScheme.surface)
                      : null,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isSelected
                          ? Text(
                              "${(selected.indexWhere((o) => option.id == o.id) + 1)} ",
                              style: const TextStyle(
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : const Icon(
                              PhosphorIconsRegular.plus,
                              size: 13,
                              opticalSize: 13,
                            ),
                      HSizedBox4,
                      Text(
                        option.name ?? '',
                        style: const TextStyle(height: 1.1),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        selected.remove(option);
                      } else {
                        if (maxSelect > selected.length) selected.add(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
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
        title: const Text("Company Values"),
      ),
      slivers: [feed],
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selected);
          },
          child: Text(
            "Save ${selected.isNotEmpty ? '(${selected.length})' : ''}".trim(),
          ),
        ),
      ),
    );
  }
}
