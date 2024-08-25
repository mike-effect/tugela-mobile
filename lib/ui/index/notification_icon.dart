import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/utils.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: ContentPadding.right / 2),
      child: IconButton(
        icon: const Icon(PhosphorIconsRegular.bell),
        onPressed: () {},
      ),
    );
  }
}
