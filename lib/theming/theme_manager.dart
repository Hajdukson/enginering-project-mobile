import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager_mobile/theming/theme_colors.dart';
import '../services/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black87, selectedItemColor: Colors.amber),
      primaryColor: Colors.black12,
      primaryColorDark: Colors.white,
      
      colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          accentColor: const Color.fromARGB(255, 241, 113, 58),
          ),
      textTheme: GoogleFonts.anybodyTextTheme(const TextTheme(
          labelSmall: TextStyle(fontSize: 16, color: Colors.white),
          titleMedium: TextStyle(fontSize: 18, color: Colors.white))));

  final lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 10),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white, 
          selectedItemColor: Colors.amber,
          elevation: 10),
      primaryColor: const Color.fromARGB(136, 0, 0, 0),
      primaryColorDark: Colors.black,
      colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
          accentColor: const Color.fromARGB(255, 241, 113, 58)),
      textTheme: GoogleFonts.anybodyTextTheme(const TextTheme(
          labelSmall: TextStyle(fontSize: 16, color: Colors.black),
          titleMedium: TextStyle(fontSize: 18, color: Colors.black))));

  final darkColors = ThemeColors(
    chartColor: const [
    Color.fromARGB(255, 58, 61, 63),
    Color.fromARGB(255, 58, 61, 63),
    ]
  );

  final lightColors = ThemeColors(
    chartColor: const [
    Color.fromARGB(255, 170, 181, 188),
    Color.fromARGB(255, 165, 174, 179),
    ]
  );

  late ThemeData _themeData = lightTheme;
  late ThemeColors _colorsValues = lightColors;

  bool isDarkMode = false;
  ThemeData getTheme() => _themeData;
  ThemeColors getColorsValues() => _colorsValues;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        isDarkMode = false;
        _themeData = lightTheme;
        _colorsValues = lightColors;
      } else {
        print('setting dark theme');
        isDarkMode = true;
        _themeData = darkTheme;
        _colorsValues = darkColors;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    _colorsValues = darkColors;
    isDarkMode = true;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    _colorsValues = lightColors;
    isDarkMode = false;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
