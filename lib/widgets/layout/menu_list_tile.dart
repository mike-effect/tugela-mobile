import 'package:flutter/material.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils/spacing.dart';
import 'package:tugela/widgets/icons/right_chevron.dart';

class MenuListTile extends StatelessWidget {
  final IconData? iconData;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;
  final Color? iconBackgroundColor;
  final bool hasBorder;
  final bool showChevron;
  final TextStyle? titleStyle;
  final double? iconSize;
  final EdgeInsets? iconPadding;
  const MenuListTile({
    super.key,
    this.iconData,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.color,
    this.iconBackgroundColor,
    this.hasBorder = true,
    this.showChevron = true,
    this.titleStyle,
    this.iconSize,
    this.iconPadding,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null;
    final iconSize = this.iconSize ?? (hasSubtitle ? 19 : 18);
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: AppTheme.cardBorderRadius,
        // border: hasBorder
        //     ? Border.all(
        //         color: AppColors.dynamic(
        //           context: context,
        //           light: context.inputTheme.disabledBorder!.borderSide.color,
        //           dark: context.inputTheme.disabledBorder!.borderSide.color,
        //         )!,
        //       )
        //     : null,
      ),
      child: ListTile(
        onTap: onTap,
        minLeadingWidth: 16,
        contentPadding: EdgeInsets.only(
          left: iconData == null ? ContentPadding.left : 0,
          right: 8,
        ),
        leading: iconData == null
            ? null
            : Padding(
                padding: iconPadding ?? EdgeInsets.zero,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      AppColors.greyElevatedBackgroundColor(context),
                  child: Icon(
                    iconData,
                    size: iconSize,
                    color: color ?? context.theme.colorScheme.primary,
                  ),
                ),
              ),
        // : Container(
        //     alignment: Alignment.center,
        //     width: iconSize,
        //     margin: iconPadding,
        //     child: FittedBox(
        //       fit: BoxFit.scaleDown,
        //       child: Icon(
        //         iconData,
        //         size: iconSize,
        //         color: color ?? context.theme.colorScheme.primary,
        //       ),
        //     ),
        //   ),
        title: Text(
          title,
          style: TextStyle(
            height: 1,
            fontSize: 16,
            color: color,
            letterSpacing: 0.1,
            fontWeight: hasSubtitle ? FontWeight.w600 : FontWeight.w500,
          ).merge(titleStyle),
        ),
        subtitle: hasSubtitle
            ? Text(
                subtitle!,
                style: const TextStyle(fontSize: 13.5),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (trailing != null) ...[
              trailing!,
              if (showChevron) HSizedBox4,
            ],
            if (showChevron) ...[
              RightChevron(
                color: color ?? context.textTheme.bodyMedium?.color,
              ),
            ],
            HSizedBox4,
          ],
        ),
      ),
    );
  }
}
