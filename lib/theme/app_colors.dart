part of '../theme.dart';

class AppColors {
  AppColors._();

  static const primaryColor = indigo;
  static const primaryColorLight = black12;
  static const primaryColorDark = indigo;

  static const primaryColorDarkTheme = white;
  static const primaryColorLightDarkTheme = white38;
  static const primaryColorDarkDarkTheme = white24;

  static get secondaryColor => indigo;
  static get secondaryColorDark => indigo;

  static final tertiaryColor = amber.shade700;
  static final tertiaryColorDark = amber.shade800;

  static const accentColor = primaryColor;
  static final accentColorFaint = indigo.shade300;

  static get dividerColor => grey.shade400;
  static final dividerColorDark = grey.shade800;

  static final borderColor = grey.shade300;
  static final borderColorDark = grey.shade700;

  static final disabledBorderColor = grey.shade400;
  static const disabledBorderColorDark = white24;

  static const scaffoldbackgroundColor = white;
  static const scaffoldbackgroundColorDark = black;

  static const backgroundColor = white;
  static Color backgroundColorDark = const Color.fromARGB(255, 24, 24, 24);

  static final elevatedBackgroundColorDark = Colors.grey.shade900;

  static const onPrimary = Colors.white;
  static const onPrimaryDark = Colors.black;

  static const onSurface = Colors.black;
  static const onSurfaceDark = Colors.white;

  static final onSecondary = secondaryColor.shade900;
  static final onSecondaryDark = secondaryColor.shade700;

  static const Color transparent = Color(0x00000000);

  static const Color black = Color(0xFF000000);

  static const Color black87 = Color(0xDD000000);

  static const Color black54 = Color(0x8A000000);

  static const Color black45 = Color(0x73000000);

  static const Color black38 = Color(0x61000000);

  static const Color black26 = Color(0x42000000);

  static const Color black12 = Color(0x1F000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color white70 = Color(0xB3FFFFFF);

  static const Color white60 = Color(0x99FFFFFF);

  static const Color white54 = Color(0x8AFFFFFF);

  static const Color white38 = Color(0x62FFFFFF);

  static const Color white30 = Color(0x4DFFFFFF);

  static const Color white24 = Color(0x3DFFFFFF);

  static const Color white12 = Color(0x1FFFFFFF);

  static const Color white10 = Color(0x1AFFFFFF);

  static const Color appGreen = Color(0xFF0BB96C);

  static const grey = Colors.grey;
  static const blueGrey = Colors.blueGrey;
  static const red = Colors.red;
  static const pink = Colors.pink;
  static const purple = Colors.purple;
  static const indigo = Colors.indigo;
  static const blue = Colors.blue;
  static const lightBlue = Colors.lightBlue;
  static const cyan = Colors.cyan;
  static const teal = Colors.teal;
  static const green = Colors.green;
  static const lime = Colors.lime;
  static const yellow = Colors.yellow;
  static const amber = Colors.amber;
  static const orange = Colors.orange;

  static const List<MaterialColor> primaries = <MaterialColor>[
    red,
    pink,
    purple,
    indigo,
    blue,
    lightBlue,
    cyan,
    teal,
    green,
    lime,
    yellow,
    amber,
    orange,
  ];

  static LinearGradient get primaryGradient {
    return const LinearGradient(colors: [
      Color(0xFF314B9D),
      Color(0xFF009ACF),
    ]);
  }

  static MaterialColor colorFor(String? name) {
    const colors = [
      // red,
      purple,
      indigo,
      blue,
      cyan,
      green,
      amber,
      orange,
    ];
    final first =
        (name == "" ? "C" : (name?.toUpperCase() ?? "C")).split('').first;
    return colors[first.hashCode & colors.length - 1];
  }

  static Color? dynamic({
    required BuildContext context,
    Color? light,
    Color? dark,
  }) {
    if (context.isDark && dark != null) {
      return dark;
    } else {
      return light;
    }
  }

  static Color greyBackgroundColor(context) {
    return dynamic(
      context: context,
      light: const Color(0xFFF7F7F8),
      dark: black,
    )!;
  }

  static Color greyElevatedBackgroundColor(context) {
    return dynamic(
      context: context,
      light: Colors.grey.shade100,
      dark: const Color.fromARGB(255, 22, 22, 22),
    )!;
  }
}
