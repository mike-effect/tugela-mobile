import 'package:flutter/material.dart';
import 'package:tugela/theme.dart';

class Skeleton {
  final BuildContext context;
  Skeleton(this.context);

  Widget circle({double radius = 12}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.dynamic(
        context: context,
        light: AppColors.grey.shade200,
        dark: AppColors.grey.shade700,
      ),
    );
  }

  Widget rect({
    double width = double.infinity,
    double height = 16,
    BorderRadius? borderRadius,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.dynamic(
          context: context,
          light: AppColors.grey.shade200,
          dark: AppColors.grey.shade700,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
    );
  }
}
