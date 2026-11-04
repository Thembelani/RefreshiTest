import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/app_palette/app_colors_extension.dart';
import 'package:refreshi_test/bootstrap/theme/app_theme.dart';
import 'package:refreshi_test/bootstrap/theme/app_typography/app_text_extension.dart';

extension AppThemeExtension on ThemeData {
  AppColorsThemeExtension get appColors =>
      extension<AppColorsThemeExtension>() ?? AppTheme.appColors;
}

extension AppTypographyExtension on ThemeData {
  AppTextThemeExtension get appTypography =>
      extension<AppTextThemeExtension>() ?? AppTheme.appTypography;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
