import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:money_manager_mobile/flavor/flavor_values.dart';
import 'package:money_manager_mobile/menu/menu.dart';
import 'package:provider/provider.dart';
import 'flavor/flavor_config.dart';
import 'theming/custom_colors.dart';
import 'theming/theme_manager.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(), 
    child: MyApp(firstCamera: firstCamera,)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.firstCamera}) : super(key: key);

  final CameraDescription firstCamera;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        FlavorConfig(
          values: FlavorValues(
            baseUrl: "https://192.168.1.37:7075",
            camera: firstCamera,
            themeNotifier: theme,
          ));
        CustomColors.themeColors = theme.getColorsValues();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: theme.getTheme(),
          home: const Menu(),
        );
      }
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
