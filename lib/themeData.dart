import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: Colors.red,
      colorScheme: isDarkTheme
          ? const ColorScheme.dark(
              primary: Colors.red, secondary: Colors.red, tertiary: Colors.white54)
          : ColorScheme.light(
              primary: Colors.red, secondary: Colors.red, tertiary: Colors.grey[800]),
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      scaffoldBackgroundColor: isDarkTheme ? Colors.black : const Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      hintColor: isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
      highlightColor: isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
      hoverColor: isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor: isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Colors.grey[850] : Colors.grey[300],
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
