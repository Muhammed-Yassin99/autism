// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unused_field, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'croppedImage.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:math' as math;

class StaticImage extends StatefulWidget {
  const StaticImage({super.key});

  @override
  _StaticImageState createState() => _StaticImageState();
}

class _StaticImageState extends State<StaticImage> {
  var _image;
  late List _recognitions;
  late bool _busy;
  late double _imageWidth, _imageHeight;

  final picker = ImagePicker();

  // this function loads the model
  loadTfModel() async {
    await Tflite.loadModel(
        model: "assets/objecDetec/yolov2_tiny.tflite",
        labels: "assets/objecDetec/yolov7labels1.txt");
  }

  void navigateToCroppedImagesScreen(File image, List recognitions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CroppedImagesScreen(
          image: image,
          recognitions: recognitions,
          imageWidth: _imageWidth,
          imageHeight: _imageHeight,
        ),
      ),
    );
  }

  // this function detects the objects on the image
  // this function detects the objects on the image
  detectObject(File image) async {
    if (image == null || !(await image.exists())) {
      throw ArgumentError('Input image is null or empty');
    }

    // Load the image using the Image package
    final bytes = await image.readAsBytes();
    final decodedImage = img.decodeImage(bytes.toList())!;

    // Resize the image to match the expected input size of the TensorFlow Lite model
    const inputSize = 416;
    final resizedImage =
        img.copyResize(decodedImage, width: inputSize, height: inputSize);

    // Convert the resized image to a byte buffer
    final input = Float32List(inputSize * inputSize * 3);
    int pixelIndex = 0;
    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        final pixel = resizedImage.getPixel(j, i);
        input[pixelIndex++] = img.getRed(pixel) / 255.0;
        input[pixelIndex++] = img.getGreen(pixel) / 255.0;
        input[pixelIndex++] = img.getBlue(pixel) / 255.0;
      }
    }

    // Detect objects on the resized image
    final byteBuffer = input.buffer.asUint8List();
    if (byteBuffer.isEmpty) {
      throw ArgumentError('Input byte buffer is empty');
    }
    var recognitions = await Tflite.detectObjectOnBinary(
      binary: byteBuffer,
      model: "yolov2-tiny.tflite",
      threshold: 0.5,
      numResultsPerClass: 1,
    );

    // Check that the recognitions array is not empty or null
    if (recognitions == null || recognitions.isEmpty) {
      throw ArgumentError('No objects detected');
    }

    if (recognitions != null && recognitions.isNotEmpty) {
      final imageBytes = await image.readAsBytes();
      final imageCodec = await ui.instantiateImageCodec(imageBytes);
      final ui.Image fullSizeImage = (await imageCodec.getNextFrame()).image;
      final imageWidth = fullSizeImage.width.toDouble();
      final imageHeight = fullSizeImage.height.toDouble();
      FileImage(image)
          .resolve(const ImageConfiguration())
          .addListener((ImageStreamListener((ImageInfo info, bool _) {
            setState(() {
              _imageWidth = info.image.width.toDouble();
              _imageHeight = info.image.height.toDouble();
            });
          })));
      setState(() {
        _recognitions = recognitions;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CroppedImagesScreen(
            image: image,
            recognitions: recognitions,
            imageWidth: imageWidth,
            imageHeight: imageHeight,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No objects detected'),
          content: const Text('Please select another image.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _busy = true;
    _recognitions = [];
    _imageWidth = 0;
    _imageHeight = 0;
    loadTfModel().then((val) {
      {
        setState(() {
          _busy = false;
        });
      }
    });
  }

  // display the bounding boxes over the detected objects
  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;

    Color blue = Colors.blue;

    return _recognitions.map((re) {
      return Positioned(
          left: re["rect"]["x"] * factorX,
          top: re["rect"]["y"] * factorY,
          width: re["rect"]["w"] * factorX,
          height: re["rect"]["h"] * factorY,
          child: ((re["confidenceInClass"] > 0.50))
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: blue,
                    width: 3,
                  )),
                  child: Text(
                    "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      background: Paint()..color = blue,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                )
              : Container());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    if (_image == null) {
      stackChildren.add(Positioned(
          top: 105,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/HomePage/discover1.jpg"),
                fit: BoxFit.cover,
                //alignment: Alignment.topCenter, // set the position of the image
              ),
            ),
            height: size.height * 0.62,
            width: size.width,
          )));
      stackChildren.add(
        const Text(
          "قم باختيار الصورة للتعرف على الأشياء الموجودة بها",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 190, 41, 61),
          ),
        ),
      );
    } else {
      stackChildren.add(
        Image.file(
          _image,
          width: size.width,
          height: size.height,
        ),
      );
    }
    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(const Center(
        child: CircularProgressIndicator(),
      ));
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(25.0),
          child: SizedBox(),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(
          bottom: (size.height) * 0.01,
        ),
        width: 340,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 140,
                  height: 140,
                  child: FloatingActionButton(
                    heroTag: "Fltbtn2",
                    onPressed: getImageFromCamera,
                    mini: false,
                    child: const Icon(Icons.camera_alt, size: 80),
                  ),
                ),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: FloatingActionButton(
                    heroTag: "Fltbtn1",
                    onPressed: getImageFromGallery,
                    mini: false,
                    child: const Icon(Icons.photo, size: 80),
                  ),
                ),
              ],
            ),
            /*const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 140,
              height: 140,
              child: FloatingActionButton(
                heroTag: "Fltbtn3",
                onPressed: _navigateToCroppedImagesScreen,
                mini: false,
                child: const Icon(Icons.crop, size: 80),
              ),
            ),*/
          ],
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: size.height - 170,
          width: size.width,
          child: Stack(
            children: stackChildren,
          ),
        )
      ]),
    ));
  }

  // gets image from camera and runs detectObject
  // gets image from camera and runs detectObject
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      detectObject(image);
    } else {
      if (kDebugMode) {
        print("No image selected");
      }
    }
  }

  // gets image from gallery and runs detectObject
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        detectObject(_image);
      } else {
        if (kDebugMode) {
          print("No image Selected");
        }
        return;
      }
    });
  }
}
