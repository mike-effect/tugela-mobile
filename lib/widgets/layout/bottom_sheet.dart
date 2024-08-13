import 'package:flutter/material.dart';
import 'package:tugela/extensions/build_context.extension.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/page_header.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  String? title,
  String? subtitle,
  required List<Widget> Function(BuildContext context) children,
  ScrollPhysics? physics,
  bool centerTitleText = false,
  EdgeInsets? padding,
  bool safeArea = true,
  Color? backgroundColor,
  Widget Function(BuildContext context)? header,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    backgroundColor: backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: context.mediaHeight / 1.14,
          minHeight: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: context.inputTheme.enabledBorder!.borderSide.color,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            if (title != null || subtitle != null)
              PageHeader(
                title: title,
                subtitle: subtitle,
                topMargin: 32,
                bottomMargin: 28,
                centerText: centerTitleText,
                leftMargin: ContentPaddingH.left,
                size: PageHeaderSize.small,
              ),
            if (header != null) header(context),
            Flexible(
              fit: FlexFit.loose,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    physics: physics,
                    padding: padding,
                    children: children(context),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      );
    },
  );
}
