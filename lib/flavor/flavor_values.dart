import 'package:camera/camera.dart';
import 'package:money_manager_mobile/theming/theme_manager.dart';

class FlavorValues {
  FlavorValues({
    required this.baseUrl, 
    required this.camera,
    required this.themeNotifier,
    });

  String baseUrl;
  CameraDescription camera;
  ThemeNotifier themeNotifier;
}