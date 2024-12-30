import 'package:flutter/material.dart';
import 'colors.dart';

/// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.lightPrimary,
  scaffoldBackgroundColor: AppColors.lightBackground,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.lightTextPrimary,
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      color: AppColors.lightTextSecondary,
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      color: AppColors.lightTextSecondary,
      fontFamily: 'Inter',
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.lightPrimary,
    titleTextStyle: TextStyle(
      color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
    iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.lightPrimary,
  ),
);

/// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.darkTextPrimary,
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      color: AppColors.darkTextSecondary,
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      color: AppColors.darkTextSecondary,
      fontFamily: 'Inter',
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkPrimary,
    titleTextStyle: TextStyle(
      color: AppColors.darkTextPrimary,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
    iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.darkPrimary,
  ),
);
