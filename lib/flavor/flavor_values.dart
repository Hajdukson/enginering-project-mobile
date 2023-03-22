import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlavorValues {
  FlavorValues({
    required this.baseUrl, 
    required this.camera,
    });

  String baseUrl;
  CameraDescription camera;
}