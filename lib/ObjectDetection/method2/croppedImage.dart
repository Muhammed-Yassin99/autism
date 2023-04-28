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
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'الأشياء اللتي تم التعرف عليها',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        // ignore: prefer_const_literals_to_create_immutables
      ),
      body: ListView.builder(
        itemCount: recognitions.length,
        itemBuilder: (context, index) {
          final recognition = recognitions[index];
          final left = recognition['rect']['x'] * imageWidth;
          final top = recognition['rect']['y'] * imageHeight;
          final width = recognition['rect']['w'] * imageWidth;
          final height = recognition['rect']['h'] * imageHeight;
          final label = ': ${recognition['detectedClass']}';

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
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: ui.Color.fromARGB(255, 22, 106, 175),
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
