import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ReceiptPreview extends StatelessWidget {
  ReceiptPreview({Key? key, required this.imageUrl}) : super(key: key);
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator(),),
      ),
      );
  }
}
