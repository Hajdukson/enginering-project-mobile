import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'bought_products_analizer.dart';

class CameraAccess extends StatefulWidget {
  const CameraAccess({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<CameraAccess> createState() => _CameraAccessState();
}

class _CameraAccessState extends State<CameraAccess> {
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(widget.camera, ResolutionPreset.ultraHigh);
    initializeControllerFuture = cameraController.initialize();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox (
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(cameraController);
            }
            return const Center(child: CircularProgressIndicator()); 
          },
        ), 
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.camera_enhance), 
        onPressed: () async {
          try {
            await initializeControllerFuture;

            final image = await cameraController.takePicture();
            final compressedImage = await compressImage(File(image.path));

            if (!mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => 
                BoughtProductsAnalizer(image: File(compressedImage.path),))
            );
          }
          catch(e){
            print(e);
          }
          
        },),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<File> compressImage(File image) async{
    File compressedFile = await FlutterNativeImage.compressImage(image.path,
        quality: 90,);
    return compressedFile;
  }
}