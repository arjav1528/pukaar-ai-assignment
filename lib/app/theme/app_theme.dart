import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
      ),
    );
    final t = base.textTheme;
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: t.copyWith(
        headlineMedium: t.headlineMedium?.copyWith(fontSize: 28.sp),
        headlineSmall: t.headlineSmall?.copyWith(fontSize: 24.sp),
        titleLarge: t.titleLarge?.copyWith(fontSize: 22.sp),
        titleMedium: t.titleMedium?.copyWith(fontSize: 16.sp),
        titleSmall: t.titleSmall?.copyWith(fontSize: 14.sp),
        bodyLarge: t.bodyLarge?.copyWith(fontSize: 16.sp),
        bodyMedium: t.bodyMedium?.copyWith(fontSize: 14.sp),
        bodySmall: t.bodySmall?.copyWith(fontSize: 12.sp),
        labelLarge: t.labelLarge?.copyWith(fontSize: 14.sp),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
