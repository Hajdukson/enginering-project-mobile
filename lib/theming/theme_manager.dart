import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black87, selectedItemColor: Colors.amber),
      primaryColor: Colors.black12,
      colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          accentColor: const Color.fromARGB(255, 241, 113, 58)),
      textTheme: GoogleFonts.anybodyTextTheme(const TextTheme(
          labelSmall: TextStyle(fontSize: 16, color: Colors.grey),
          titleMedium: TextStyle(fontSize: 18, color: Colors.white))));

  final lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 10),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white, 
          selectedItemColor: Colors.amber,
          elevation: 10),
      primaryColor: const Color.fromARGB(136, 0, 0, 0),
      colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
          accentColor: const Color.fromARGB(255, 241, 113, 58)),
      textTheme: GoogleFonts.anybodyTextTheme(const TextTheme(
          labelSmall: TextStyle(fontSize: 16, color: Colors.grey),
          titleMedium: TextStyle(fontSize: 18, color: Colors.white))));

  late ThemeData _themeData = lightTheme;
  bool isDarkMode = false;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        isDarkMode = false;
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        isDarkMode = true;
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    isDarkMode = true;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    isDarkMode = false;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
