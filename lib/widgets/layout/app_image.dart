import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils.dart';

const defaultCacheImageSize = 720;

typedef AppImageCallback = void Function(
  BuildContext context,
  int index,
  String url,
);

class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? placeholderWidth;
  final double? placeholderHeight;
  final BorderRadius borderRadius;
  final Widget? child;
  final Color? backgroundColor;
  final Alignment alignment;
  final BoxFit? fit;
  final int? cacheImageSize;

  const AppImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.placeholderWidth,
    this.placeholderHeight,
    this.borderRadius = BorderRadius.zero,
    this.child,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.fit,
    this.cacheImageSize,
  });

  const factory AppImage.gallery({
    Key? key,
    required double galleryWidth,
    required double galleryHeight,
    int spacing,
    BorderRadius borderRadius,
    List<String> imageUrls,
    AppImageCallback onImageTap,
    int? cacheImageSize,
  }) = _AppImageGallery;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ??
        AppColors.dynamic(
          context: context,
          light: AppColors.grey.shade200,
          dark: AppColors.grey.shade700,
        );
    final placeholder = Container(
      alignment: Alignment.center,
      color: backgroundColor,
      width: placeholderWidth ?? width,
      height: placeholderHeight ?? height,
      child: child,
    );

    if (imageUrl == null ||
        !(Uri.tryParse(imageUrl ?? "")?.hasScheme ?? false)) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: placeholder,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        filterQuality: FilterQuality.high,
        maxHeightDiskCache: cacheImageSize,
        memCacheHeight: cacheImageSize,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) {
          return placeholder;
        },
        errorListener: (err) {
          handleError(err, stackTrace: StackTrace.current);
        },
        errorWidget: (context, url, error) {
          return placeholder;
        },
      ),
    );
  }
}

class _AppImageGallery extends AppImage {
  final int spacing;
  final double galleryWidth;
  final double galleryHeight;
  final List<String> imageUrls;
  final AppImageCallback? onImageTap;

  const _AppImageGallery({
    super.key,
    super.borderRadius = BorderRadius.zero,
    super.cacheImageSize,
    this.galleryWidth = double.maxFinite,
    this.galleryHeight = 100,
    this.spacing = 1,
    this.imageUrls = const [],
    this.onImageTap,
  });

  Widget placeholder(BuildContext context) {
    final backgroundColor = this.backgroundColor ??
        AppColors.dynamic(
          context: context,
          light: AppColors.grey.shade200,
          dark: AppColors.grey.shade700,
        );
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: child,
    );
  }

  Widget _image({
    required BuildContext context,
    required int index,
    required double height,
    required double width,
  }) {
    return GestureDetector(
      onTap: onImageTap == null
          ? null
          : () {
              onImageTap!(context, index, imageUrls[index]);
            },
      child: CachedNetworkImage(
        imageUrl: imageUrls[index],
        width: width,
        height: height,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        maxHeightDiskCache: cacheImageSize,
        memCacheHeight: cacheImageSize,
        placeholder: (context, url) {
          return placeholder(context);
        },
        errorWidget: (context, url, error) {
          return placeholder(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget slot = const SizedBox.shrink();
    if (imageUrls.isEmpty) {
      slot = placeholder(context);
    } else if (imageUrls.length == 3) {
      slot = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(
            context: context,
            index: 0,
            height: galleryHeight,
            width: (galleryWidth / 2) - spacing,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(2, (i) {
                final index = i + 1;
                return _image(
                  context: context,
                  index: index,
                  height: (galleryHeight / 2) - spacing,
                  width: (galleryWidth / 2) - spacing,
                );
              })
            ],
          ),
        ],
      );
    } else {
      slot = Wrap(
        spacing: spacing * 2,
        runSpacing: spacing * 2,
        children: List.generate(math.min(imageUrls.length, 4), (index) {
          double h = galleryHeight;
          double w = galleryWidth;
          switch (math.min(imageUrls.length, 4)) {
            case 2:
              w = (galleryWidth / 2) - spacing;
              break;
            case 3:
              if (index > 0) {
                w = (galleryWidth / 2) - spacing;
              }
              h = (galleryHeight / 2) - spacing;
              break;
            case 4:
              w = (galleryWidth / 2) - spacing;
              h = (galleryHeight / 2) - spacing;
              break;
            default:
          }
          if (imageUrls.length > 4 && index == 3) {
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                _image(
                  context: context,
                  index: index,
                  height: h,
                  width: w,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: h,
                    width: w,
                    alignment: Alignment.bottomRight,
                    padding: ContentPadding,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.4, 1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.black45,
                        ],
                      ),
                    ),
                    child: Text(
                      "+${imageUrls.length - 4}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return _image(
            context: context,
            index: index,
            height: h,
            width: w,
          );
        }),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: galleryWidth,
        height: galleryHeight,
        child: slot,
      ),
    );
  }
}
