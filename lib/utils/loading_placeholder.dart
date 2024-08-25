import 'package:flutter/material.dart';

Widget loadingPlaceholder<T>({
  required BuildContext context,
  required List<T>? value,
  required Widget Function(BuildContext context, List<T> value) builder,
  required WidgetBuilder placeholderBuilder,
  WidgetBuilder? emptyStateBuilder,
  int placeholderCount = 7,
}) {
  if (value == null) {
    return SliverList.builder(
      itemCount: placeholderCount,
      itemBuilder: (context, index) {
        return placeholderBuilder(context);
      },
    );
  }

  if (value.isEmpty && emptyStateBuilder != null) {
    return emptyStateBuilder(context);
  }

  return builder(context, value);
}

Widget gridLoadingPlaceholder<T>({
  required BuildContext context,
  required List<T>? value,
  required Widget Function(BuildContext context, List<T> value) builder,
  required WidgetBuilder placeholderBuilder,
  required SliverGridDelegate gridDelegate,
  WidgetBuilder? emptyStateBuilder,
  int placeholderCount = 8,
}) {
  if (value == null) {
    return SliverGrid.builder(
      gridDelegate: gridDelegate,
      itemCount: placeholderCount,
      itemBuilder: (context, index) {
        return placeholderBuilder(context);
      },
    );
  }

  if (value.isEmpty && emptyStateBuilder != null) {
    return emptyStateBuilder(context);
  }

  return builder(context, value);
}
