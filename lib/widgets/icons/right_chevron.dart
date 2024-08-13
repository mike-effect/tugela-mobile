import 'package:flutter/material.dart';
import 'package:tugela/extensions.dart';

class RightChevron extends StatelessWidget {
  final Color? color;
  const RightChevron({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right,
      size: 24,
      color: color ?? context.theme.iconTheme.color,
    );
  }
}
