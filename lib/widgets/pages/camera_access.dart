import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.camera_enhance), onPressed: () {},),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}