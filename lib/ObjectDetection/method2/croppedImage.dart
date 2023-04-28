// ignore_for_file: unused_import

import 'dart:io';
import 'dart:ui' as ui;

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
      appBar: AppBar(
        title: const Text('Detected Objects'),
      ),
      body: ListView.builder(
        itemCount: recognitions.length,
        itemBuilder: (context, index) {
          final recognition = recognitions[index];
          final left = recognition['rect']['x'] * imageWidth;
          final top = recognition['rect']['y'] * imageHeight;
          final width = recognition['rect']['w'] * imageWidth;
          final height = recognition['rect']['h'] * imageHeight;
          final label =
              '${recognition['detectedClass']} ${(recognition['confidenceInClass'] * 100).toStringAsFixed(0)}%';

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ClipRect(
                        child: CustomPaint(
                          painter: BoundingBoxPainter(
                            left: left,
                            top: top,
                            width: width,
                            height: height,
                            color: Colors.blue,
                            strokeWidth: 3,
                          ),
                          child: Image.file(
                            image,
                            width: width,
                            height: height,
                            fit: BoxFit.cover,
                            alignment: Alignment(-left / width, -top / height),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final double left;
  final double top;
  final double width;
  final double height;
  final Color color;
  final double strokeWidth;

  BoundingBoxPainter({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRect(
      Rect.fromLTWH(left, top, width, height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
