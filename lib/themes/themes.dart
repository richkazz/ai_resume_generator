import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color.fromRGBO(1, 72, 123, 1);
  static const secondaryColor = Color.fromRGBO(72, 161, 227, 1);
  static const tertiaryColor = Color.fromRGBO(243, 249, 252, 1);
  static const outlineButtonBorderColor = Color.fromRGBO(0, 0, 0, 1);
  static const outlineButtonTextColor = Color.fromRGBO(0, 0, 0, 1);
  static const filledButtonBackgroundColor = primaryColor;
  static const filledButtonTextColor = Color.fromRGBO(255, 255, 255, 1);
  static const errorColor = Color.fromRGBO(250, 2, 2, 1);
  static const editButtonColor = Color.fromRGBO(2, 119, 21, 1);
  static const onboardingPageNotActiveIconColor =
      Color.fromRGBO(207, 207, 207, 1);
  static const disabledButtonBackgroundColor = Colors.grey;
  static const inputTextFieldEnabledBorderColor =
      Color.fromRGBO(217, 217, 217, 1);
  static const backButtonColor = secondaryColor;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      shadow: Colors.black38,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: Colors.black),
    inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: Colors.black,
      suffixIconColor: Colors.black,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
      ),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.white),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      secondary: Colors.black,
      surface: Colors.black,
      shadow: Colors.white38,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      shape: BorderDirectional(
        bottom: BorderSide(
          color: Colors.white38,
        ),
      ),
    ),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: Colors.white),
    inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: Colors.white,
      suffixIconColor: Colors.white,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white),
      ),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.white),
    ),
  );
}
