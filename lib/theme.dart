library theme;

import 'package:flutter/cupertino.dart'
    show CupertinoThemeData, CupertinoTextThemeData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:google_fonts/google_fonts.dart';
import 'package:tugela/extensions/build_context.extension.dart';
import 'package:tugela/utils.dart' show ContentPadding;

part 'theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static TextTheme get googleFont => GoogleFonts.wixMadeforTextTextTheme(
        const TextTheme(),
      );

  static final fontFamily = googleFont.bodyMedium?.fontFamily ?? "";
  static final secondaryFontFamily = fontFamily;
  static final formBorderRadius = BorderRadius.circular(12);
  static final buttonBorderRadius = BorderRadius.circular(100);
  static final cardBorderRadius = BorderRadius.circular(12);
  static final avatarBorderRadius = BorderRadius.circular(8);
  static const textfieldPadding = EdgeInsets.all(16);
  static const buttonPadding = EdgeInsets.symmetric(
    vertical: 18,
    horizontal: 24,
  );

  static const largeAppBarHeight = kToolbarHeight + 12;

  static ButtonStyle? smallElevatedButtonStyle(BuildContext context) {
    return context.theme.elevatedButtonTheme.style?.copyWith(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  static ButtonStyle? compactElevatedButtonStyle(BuildContext context) {
    return context.theme.elevatedButtonTheme.style?.copyWith(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    );
  }

  static ButtonStyle? compactTextButtonStyle(BuildContext context) {
    return context.theme.textButtonTheme.style?.copyWith(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    );
  }

  static ButtonStyle? smallOutlinedButtonStyle(BuildContext context) {
    return context.theme.outlinedButtonTheme.style?.copyWith(
      side: WidgetStatePropertyAll(
        BorderSide(color: context.theme.dividerColor),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 14),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      ),
    );
  }

  static ThemeData datePickerTheme(ThemeData theme) {
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: theme.colorScheme.secondary,
        // surface: theme.colorScheme.secondary,
        onPrimary: Colors.black,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: theme.textTheme.displayLarge?.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        labelSmall:
            theme.textTheme.labelSmall?.copyWith(fontFamily: fontFamily),
        headlineMedium:
            theme.textTheme.headlineMedium?.copyWith(fontFamily: fontFamily),
        headlineSmall:
            theme.textTheme.headlineSmall?.copyWith(fontFamily: fontFamily),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(theme.primaryColor),
          textStyle: WidgetStateProperty.all(
            TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  static ThemeData dateRangePickerTheme(ThemeData theme) {
    return datePickerTheme(theme);
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      primaryColor: AppColors.primaryColorDark,
      primaryColorLight: AppColors.primaryColorLight,
      primaryColorDark: AppColors.primaryColorDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: AppColors.scaffoldbackgroundColor,
      splashColor: AppColors.transparent,
      unselectedWidgetColor: AppColors.black12,
      dividerColor: AppColors.dividerColor,
      secondaryHeaderColor: AppColors.grey.shade50,
      disabledColor: Colors.grey.shade400,
      dividerTheme: DividerThemeData(color: AppColors.dividerColor),
      tabBarTheme: const TabBarTheme(
        // labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        labelColor: Colors.black,
        indicatorColor: AppColors.primaryColor,
        // indicator: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(
        //       color: Colors.grey.shade600,
        //     ),
        //   ),
        // ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: AppColors.primaryColor,
        barBackgroundColor: AppColors.white,
        scaffoldBackgroundColor: AppColors.scaffoldbackgroundColor,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            color: AppColors.black87,
            fontFamily: fontFamily,
          ),
          tabLabelTextStyle: TextStyle(
            fontSize: 13,
            fontFamily: fontFamily,
          ),
          navTitleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
            // letterSpacing: -0.4,
          ),
          navLargeTitleTextStyle: TextStyle(
            color: Colors.black87,
            fontFamily: fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      iconTheme: const IconThemeData(size: 24),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: AppColors.scaffoldbackgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          // letterSpacing: 0.4,
        ),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        padding: ContentPadding,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.onPrimary,
        elevation: 3,
        iconSize: 32,
      ),
      snackBarTheme: SnackBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.green.shade700,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(
          fontSize: 15,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
        selectionHandleColor: AppColors.primaryColor,
        selectionColor: AppColors.grey.shade400,
      ),
      textTheme: googleFont,
      // textTheme: const TextTheme(
      //   headlineMedium: TextStyle(
      //     // letterSpacing: -0.3,
      //     color: AppColors.primaryColor,
      //     fontWeight: FontWeight.bold,
      //     fontFamily: fontFamily,
      //   ),
      //   // subtitle1: TextStyle(fontWeight: FontWeight.w600),
      //   titleSmall: TextStyle(
      //     fontWeight: FontWeight.normal,
      //     fontFamily: fontFamily,
      //   ),
      //   bodyLarge: TextStyle(
      //     fontWeight: FontWeight.normal,
      //   ),
      //   bodyMedium: TextStyle(
      //     // fontSize: 15,
      //     fontWeight: FontWeight.normal,
      //     fontFamily: fontFamily,
      //   ),
      // ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      buttonTheme: ButtonThemeData(
        minWidth: 50,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        buttonColor: AppColors.primaryColor,
        splashColor: AppColors.transparent,
        padding: AppTheme.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.buttonBorderRadius,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          foregroundColor: AppColors.primaryColor,
          padding: AppTheme.buttonPadding,
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.buttonBorderRadius,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          padding: AppTheme.buttonPadding,
          side: BorderSide(color: AppColors.grey.shade300, width: 1),
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.buttonBorderRadius,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          padding: AppTheme.buttonPadding,
          shadowColor: Colors.transparent,
          textStyle: TextStyle(
            fontSize: 17,
            height: 1,
            // letterSpacing: 0.2,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.buttonBorderRadius,
          ),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(AppColors.primaryColor),
        overlayColor: WidgetStateProperty.all(Colors.grey.shade800),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          elevation: const WidgetStatePropertyAll(40),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: AppColors.grey.shade100,
        hintStyle: TextStyle(
          fontSize: 15,
          color: AppColors.grey,
          fontFamily: fontFamily,
          fontWeight: FontWeight.normal,
        ),
        labelStyle: TextStyle(
          fontSize: 15,
          color: AppColors.grey,
          fontFamily: fontFamily,
          fontWeight: FontWeight.normal,
        ),
        errorMaxLines: 4,
        contentPadding: textfieldPadding,
        suffixIconColor: AppColors.blueGrey,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(
          fontSize: 17,
          fontFamily: fontFamily,
        ),
        errorStyle: TextStyle(
          color: AppColors.red.shade600,
          fontSize: 13,
          fontFamily: fontFamily,
        ),
        border: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: AppColors.disabledBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(width: 2, color: AppColors.red.shade800),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.indigo,
        accentColor: AppColors.secondaryColor,
      )
          .copyWith(
            primary: AppColors.primaryColor,
            onPrimary: AppColors.onPrimary,
            secondary: AppColors.secondaryColor,
            onSecondary: AppColors.onSecondary,
            tertiary: AppColors.tertiaryColor,
          )
          .copyWith(surface: AppColors.backgroundColor),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        pressElevation: 1,
      ),
    );
  }

  static ThemeData get dark {
    final darkTheme = ThemeData.dark();
    final colorScheme = light.colorScheme;
    final cupertinoOverrideTheme = light.cupertinoOverrideTheme;
    final appBarTheme = light.appBarTheme;
    final bottomAppBarTheme = light.bottomAppBarTheme;
    final bottomSheetTheme = light.bottomSheetTheme;
    final snackBarTheme = light.snackBarTheme;
    final iconTheme = light.iconTheme;
    final textSelectionTheme = light.textSelectionTheme;
    final textTheme = light.textTheme;
    final buttonTheme = light.buttonTheme;
    final textButtonTheme = light.textButtonTheme;
    final outlinedButtonTheme = light.outlinedButtonTheme;
    // final elevatedButtonTheme = light.elevatedButtonTheme;
    final inputDecorationTheme = light.inputDecorationTheme;
    final floatingActionButtonTheme = light.floatingActionButtonTheme;
    final chipTheme = light.chipTheme;
    final radioTheme = light.radioTheme;

    return light.copyWith(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColorDarkTheme,
      primaryColorLight: AppColors.primaryColorLightDarkTheme,
      primaryColorDark: AppColors.primaryColorDarkDarkTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: AppColors.scaffoldbackgroundColorDark,
      splashColor: AppColors.transparent,
      unselectedWidgetColor: AppColors.black12,
      dividerColor: Colors.grey.shade500,
      dividerTheme: DividerThemeData(color: Colors.grey.shade500),
      secondaryHeaderColor: AppColors.grey.shade900,
      dialogBackgroundColor: Colors.grey.shade900,
      disabledColor: AppColors.grey,
      iconTheme: iconTheme.copyWith(
        color: AppColors.primaryColorDarkDarkTheme,
      ),
      radioTheme: radioTheme.copyWith(
        fillColor: const WidgetStatePropertyAll(AppColors.primaryColorDark),
      ),
      cupertinoOverrideTheme: cupertinoOverrideTheme?.copyWith(
        primaryColor: AppColors.primaryColorDarkTheme,
        barBackgroundColor: AppColors.backgroundColorDark,
        textTheme: cupertinoOverrideTheme.textTheme?.copyWith(
          textStyle: cupertinoOverrideTheme.textTheme?.textStyle.copyWith(
            color: AppColors.grey,
          ),
          tabLabelTextStyle:
              cupertinoOverrideTheme.textTheme?.tabLabelTextStyle.copyWith(
            color: Colors.white70,
          ),
          navTitleTextStyle: cupertinoOverrideTheme.textTheme?.navTitleTextStyle
              .copyWith(color: Colors.white),
          navLargeTitleTextStyle: cupertinoOverrideTheme
              .textTheme?.navLargeTitleTextStyle
              .copyWith(color: Colors.white),
        ),
      ),
      appBarTheme: appBarTheme.copyWith(
        color: AppColors.scaffoldbackgroundColorDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: iconTheme.copyWith(color: AppColors.white),
        titleTextStyle: appBarTheme.titleTextStyle?.copyWith(
          color: AppColors.white,
        ),
      ),
      bottomAppBarTheme: bottomAppBarTheme.copyWith(
          // color: AppColors.backgroundColorDark,
          ),
      bottomSheetTheme: bottomSheetTheme.copyWith(
        backgroundColor: AppColors.elevatedBackgroundColorDark,
      ),
      floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
        backgroundColor: AppColors.grey.shade800,
      ),
      snackBarTheme: snackBarTheme.copyWith(
        backgroundColor: AppColors.green.shade800,
      ),
      textSelectionTheme: textSelectionTheme.copyWith(
        cursorColor: AppColors.primaryColorDarkDarkTheme,
        selectionHandleColor: AppColors.grey.shade400,
        selectionColor: AppColors.grey.shade600,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: light.textTheme.displayLarge
            ?.copyWith(color: darkTheme.textTheme.displayLarge?.color),
        displayMedium: light.textTheme.displayMedium
            ?.copyWith(color: darkTheme.textTheme.displayMedium?.color),
        displaySmall: light.textTheme.displaySmall
            ?.copyWith(color: darkTheme.textTheme.displaySmall?.color),
        headlineMedium: light.textTheme.headlineMedium
            ?.copyWith(color: darkTheme.textTheme.headlineMedium?.color),
        headlineSmall: light.textTheme.headlineSmall
            ?.copyWith(color: darkTheme.textTheme.headlineSmall?.color),
        titleLarge: light.textTheme.titleLarge
            ?.copyWith(color: darkTheme.textTheme.titleLarge?.color),
        titleMedium: light.textTheme.titleMedium
            ?.copyWith(color: darkTheme.textTheme.titleMedium?.color),
        titleSmall: light.textTheme.titleSmall
            ?.copyWith(color: darkTheme.textTheme.titleSmall?.color),
        bodyLarge: light.textTheme.bodyLarge
            ?.copyWith(color: darkTheme.textTheme.bodyLarge?.color),
        bodyMedium: light.textTheme.bodyMedium
            ?.copyWith(color: darkTheme.textTheme.bodyMedium?.color),
        bodySmall: light.textTheme.bodySmall
            ?.copyWith(color: darkTheme.textTheme.bodySmall?.color),
        labelLarge: light.textTheme.labelLarge
            ?.copyWith(color: darkTheme.textTheme.labelLarge?.color),
        labelSmall: light.textTheme.labelSmall
            ?.copyWith(color: darkTheme.textTheme.labelSmall?.color),
      ),
      buttonTheme: buttonTheme.copyWith(
        buttonColor: AppColors.primaryColorDarkTheme,
        disabledColor: AppColors.grey,
      ),
      textButtonTheme: TextButtonThemeData(
        style: textButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(
            AppColors.primaryColorDarkTheme,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: outlinedButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(
            AppColors.primaryColorDarkTheme,
          ),
          side: WidgetStateProperty.all(
            BorderSide(
              width: 2,
              color: AppColors.primaryColorDarkTheme.withOpacity(0.7),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryColorDarkTheme,
          foregroundColor: AppColors.primaryColorDark,
          disabledBackgroundColor: AppColors.grey.shade800,
          disabledForegroundColor: AppColors.grey.shade400,
          padding: AppTheme.buttonPadding,
          textStyle: TextStyle(
            fontSize: 17,
            height: 1,
            // letterSpacing: 0.2,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.buttonBorderRadius,
          ),
        ),
      ),
      inputDecorationTheme: inputDecorationTheme.copyWith(
        fillColor: AppColors.grey.shade900,
        hintStyle: inputDecorationTheme.hintStyle?.copyWith(
          color: AppColors.grey,
        ),
        floatingLabelStyle: inputDecorationTheme.floatingLabelStyle?.copyWith(
          color: AppColors.grey.shade300,
        ),
        errorStyle: inputDecorationTheme.errorStyle?.copyWith(
          color: AppColors.red.shade300,
        ),
        border: inputDecorationTheme.border?.copyWith(
          borderSide: inputDecorationTheme.border?.borderSide.copyWith(
            color: AppColors.borderColorDark,
          ),
        ),
        enabledBorder: inputDecorationTheme.enabledBorder?.copyWith(
          borderSide: inputDecorationTheme.enabledBorder?.borderSide.copyWith(
            color: AppColors.borderColorDark,
          ),
        ),
        disabledBorder: inputDecorationTheme.disabledBorder?.copyWith(
          borderSide: inputDecorationTheme.disabledBorder?.borderSide.copyWith(
            color: AppColors.disabledBorderColorDark,
          ),
        ),
        focusedBorder: inputDecorationTheme.focusedBorder?.copyWith(
          borderSide: inputDecorationTheme.focusedBorder?.borderSide.copyWith(
            width: 2,
            color: AppColors.primaryColorDarkTheme,
          ),
        ),
        errorBorder: inputDecorationTheme.errorBorder?.copyWith(
          borderSide: BorderSide(color: AppColors.red.shade300),
        ),
        focusedErrorBorder: inputDecorationTheme.focusedErrorBorder?.copyWith(
          borderSide:
              inputDecorationTheme.focusedErrorBorder?.borderSide.copyWith(
            width: 2,
            color: AppColors.red.shade400,
          ),
        ),
      ),
      colorScheme: colorScheme
          .copyWith(
            primary: AppColors.primaryColorDarkTheme,
            secondary: AppColors.secondaryColorDark,
            onSecondary: AppColors.onSecondaryDark,
            brightness: Brightness.dark,
            onSurface: AppColors.onSurfaceDark,
            onPrimary: AppColors.onPrimaryDark,
            surface: Colors.grey.shade800,
            tertiary: AppColors.tertiaryColorDark,
          )
          .copyWith(surface: AppColors.backgroundColorDark)
          .copyWith(error: AppColors.red.shade300),
      chipTheme: chipTheme.copyWith(
        backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      ),
    );
  }
}
