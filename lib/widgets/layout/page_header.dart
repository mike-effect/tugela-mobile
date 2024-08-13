import 'package:flutter/material.dart';

enum PageHeaderSize { normal, small }

class PageHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? overline;
  final double? topMargin;
  final double? bottomMargin;
  final double? leftMargin;
  final double? rightMargin;
  final bool centerText;
  final PageHeaderSize size;
  const PageHeader({
    super.key,
    this.title,
    this.subtitle,
    this.overline,
    this.topMargin,
    this.bottomMargin,
    this.leftMargin,
    this.rightMargin,
    this.centerText = false,
    this.size = PageHeaderSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final titleSize = {
    //   PageHeaderSize.normal: 24.0,
    //   PageHeaderSize.small: 18.0,
    // };
    final subtitleSize = {
      PageHeaderSize.normal: 15.0,
      PageHeaderSize.small: 14.0,
    };
    final titleVerticalSpacing = {
      PageHeaderSize.normal: 10.0,
      PageHeaderSize.small: 6.0,
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topMargin ?? (title == null ? 0 : 20),
        bottom: bottomMargin ?? 40,
        left: leftMargin ?? 0,
        right: rightMargin ?? 0,
      ),
      child: Column(
        crossAxisAlignment:
            centerText ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (overline != null) ...[
            Text(
              "$overline",
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(height: 10),
          ],
          if (title != null)
            FittedBox(
              child: Text(
                title!,
                textAlign: centerText ? TextAlign.center : TextAlign.start,
                style: theme
                    .cupertinoOverrideTheme?.textTheme?.navLargeTitleTextStyle,
              ),
            ),
          if (subtitle != null) ...[
            if (title != null) SizedBox(height: titleVerticalSpacing[size]),
            Text(
              "$subtitle",
              textAlign: centerText ? TextAlign.center : TextAlign.start,
              style: theme.textTheme.titleSmall!.copyWith(
                letterSpacing: -0.1,
                fontSize: subtitleSize[size],
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
