import 'package:camera/camera.dart';
import 'package:money_manager_mobile/theming/custom_colors.dart';
import 'package:money_manager_mobile/theming/theme_manager.dart';

class FlavorValues {
  FlavorValues({
    required this.baseUrl, 
    required this.camera,
    required this.themeNotifier,
    required this.customColors
    });

  String baseUrl;
  CameraDescription camera;
  ThemeNotifier themeNotifier;
  // I think it shouldn't be added to FlavorValues but it works
  CustomColors customColors;
}