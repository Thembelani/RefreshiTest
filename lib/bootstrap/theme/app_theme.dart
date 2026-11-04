import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/app_palette/app_colors_extension.dart';
import 'package:refreshi_test/bootstrap/theme/app_typography/app_text_extension.dart';

class AppTheme {
  static final appColors = AppColorsThemeExtension.appDefault;
  static final appTypography = AppTextThemeExtension.appDefault;

  static final theme = ThemeData(
    brightness: Brightness.light,
    colorScheme: appColors.toColorScheme(Brightness.light),
    scaffoldBackgroundColor: appColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.background,
      foregroundColor: appColors.onBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    extensions: [
      appColors,
      appTypography,
    ],
  );
}
