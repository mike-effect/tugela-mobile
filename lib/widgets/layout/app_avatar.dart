import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tugela/constants/app_assets.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final Widget? overlayWidget;
  final VoidCallback? onTap;
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.overlayWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final diameter = (radius * 2).toInt();
    final backgroundColor = this.backgroundColor ??
        AppColors.dynamic(
          context: context,
          light: AppColors.grey.shade200,
          dark: AppColors.grey.shade700,
        );
    final placeholder = CircleAvatar(
      radius: radius,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child ??
            Image.asset(
              AppAssets.images.appIconForegroundPng,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withOpacity(0.2),
            ),
      ),

      // child: SvgPicture.asset(
      //   AppAssets.svg.ncGlyphSvg,
      //   height: radius * 1.5,
      //   theme: SvgTheme(
      //     currentColor: AppColors.dynamic(
      //       context: context,
      //       light: AppColors.grey.shade400,
      //       dark: AppColors.grey.shade900,
      //     )!,
      //   ),
      // ),
      // child: Text(
      //   userInitials(name),
      //   style: TextStyle(
      //     fontSize: (diameter / 2.7),
      //     color: foregroundColor ?? context.textTheme.bodyMedium?.color,
      //   ),
      // ),
    );
    final isInvalidImage =
        imageUrl == null || !(Uri.tryParse(imageUrl ?? "")?.hasScheme ?? false);
    return GestureDetector(
      onTap: onTap,
      child: isInvalidImage
          ? placeholder
          : CircleAvatar(
              radius: radius,
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
              backgroundImage: CachedNetworkImageProvider(
                imageUrl!,
                maxHeight: diameter * 2,
                maxWidth: diameter * 2,
                errorListener: (err) {
                  handleError(err, stackTrace: StackTrace.current);
                },
              ),
            ),
    );
  }
}
