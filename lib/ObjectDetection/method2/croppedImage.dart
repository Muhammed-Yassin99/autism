import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CroppedImagesScreen extends StatelessWidget {
  final File image;
  final List recognitions;
  final double imageWidth;
  final double imageHeight;

  const CroppedImagesScreen({
    Key? key,
    required this.image,
    required this.recognitions,
    required this.imageWidth,
    required this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cropped Images'),
      ),
      body: Stack(
        children: [
          Image.file(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          ...recognitions.map((recognition) {
            final rect = recognition['rect'];
            final left = rect['x'] * imageWidth;
            final top = rect['y'] * imageHeight;
            final width = rect['w'] * imageWidth;
            final height = rect['h'] * imageHeight;
            final label =
                '${recognition['detectedClass']} ${(recognition['confidenceInClass'] * 100).toStringAsFixed(0)}%';
            return Positioned(
              left: left,
              top: top,
              child: Container(
                width: width,
                height: height + 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 3,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        background: Paint()..color = Colors.blue,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Image.file(
                      image,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      alignment: Alignment(-left / width, -top / height),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
