import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: ContentPadding.right / 2),
      child: IconButton(
        onPressed: () {
          pushNamed(context, Routes.settings, rootNavigator: true);
        },
        icon: const Icon(PhosphorIconsRegular.list),
      ),

      // child: IconButton(
      //   icon: const Icon(PhosphorIconsRegular.bell),
      //   onPressed: () {},
      // ),
    );
  }
}
