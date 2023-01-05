import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager_mobile/flavor/flavor_values.dart';
import 'package:money_manager_mobile/widgets/menu/menu.dart';
import 'flavor/flavor_config.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  FlavorConfig(
    values: FlavorValues(
      baseUrl: "https://192.168.1.33:7075",
      camera: firstCamera,
      themeData: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black87,
          selectedItemColor: Colors.amber
        ),
        primaryColor: Colors.black12,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          accentColor: const Color.fromARGB(255, 241, 113, 58)
        ),
        textTheme: GoogleFonts.anybodyTextTheme(const TextTheme(
          labelSmall: TextStyle(
            fontSize: 16,
            color: Colors.grey),
          titleMedium: TextStyle(
            fontSize: 18,
            color: Colors.white
          )
            )))));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate
        ],
      supportedLocales: const [
        Locale("pl"),
        Locale("en")
      ],
      theme: FlavorConfig.instance.values.themeData,
      home: const Menu(),
    );
  }
}

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
