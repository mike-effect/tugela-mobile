import 'package:flutter/material.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/forms/search_text_field.dart';

class FullscreenSelector<T> extends StatefulWidget {
  final String title;
  final List<T> Function(BuildContext context) list;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final WidgetBuilder? emptyState;
  final WidgetBuilder? floatingActionButton;
  final List<T> Function(
    BuildContext context,
    List<T> options,
    String searchQuery,
  )? onSearch;
  const FullscreenSelector({
    super.key,
    required this.title,
    required this.itemBuilder,
    required this.list,
    this.onSearch,
    this.emptyState,
    this.floatingActionButton,
  });

  @override
  State<FullscreenSelector> createState() => _FullscreenSelectorState<T>();
}

class _FullscreenSelectorState<T> extends State<FullscreenSelector<T>> {
  final textController = TextEditingController();
  final scrollController = ScrollController();

  List<T> get list => List<T>.from(widget.list(context));

  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(update);
  }

  @override
  void dispose() {
    textController.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<T> searchResults = [];
    final query = textController.text;
    if (query.isEmpty) {
      searchResults = list;
    } else {
      searchResults = widget.onSearch?.call(context, list, query) ?? [];
    }

    final searchField = (widget.onSearch != null && list.length > 7)
        ? SafeArea(
            top: false,
            child: Padding(
              padding: ContentPadding.copyWith(
                right: widget.onSearch != null &&
                        widget.floatingActionButton != null
                    ? 72
                    : null,
              ),
              child: SearchTextField(
                controller: textController,
                autofocus: true,
                // margin: const EdgeInsets.all(12),
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search",
              ),
            ),
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: widget.floatingActionButton?.call(context),
      body: list.isEmpty
          ? widget.emptyState?.call(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return widget.itemBuilder(
                        context,
                        index,
                        searchResults[index],
                      );
                    },
                  ),
                ),
                if (searchField != null) searchField,
              ],
            ),
    );
  }
}
