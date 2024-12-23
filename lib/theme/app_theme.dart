import 'package:flutter/material.dart';
import './colors.dart'; // Import custom colors

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.textPrimary,
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      color: AppColors.textSecondary,
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      color: AppColors.textSecondary,
      fontFamily: 'Inter',
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
);
