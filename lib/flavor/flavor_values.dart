import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlavorValues {
  FlavorValues({
    required this.baseUrl, 
    required this.camera,
    required this.themeData
    });

  String baseUrl;
  CameraDescription camera;
  ThemeData themeData;
}