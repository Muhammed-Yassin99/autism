// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unused_field, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class StaticImage extends StatefulWidget {
  const StaticImage({Key? key});

  @override
  _StaticImageState createState() => _StaticImageState();
}

class _StaticImageState extends State<StaticImage> {
  var _image;
  File? croppedFile;
  late List _recognitions;
  late bool _busy;
  late double _imageWidth, _imageHeight;

  final picker = ImagePicker();

  // this function loads the model
  loadTfModel() async {
    await Tflite.loadModel(
        model: "assets/objecDetec/ssd_mobilenet.tflite",
        labels: "assets/objecDetec/SSDlabels.txt");
  }

  // this function detects the objects on the image
  // this function detects the objects on the image
  detectObject(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path, // required
      model: "SSDMobileNet",
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5, // defaults to 0.1
      numResultsPerClass: 5, // defaults to 5
    );

    File? croppedFile = await _cropImage(image);

    if (croppedFile != null) {
      FileImage(croppedFile)
          .resolve(const ImageConfiguration())
          .addListener((ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          _imageWidth = info.image.width.toDouble();
          _imageHeight = info.image.height.toDouble();
        });
      })));

      setState(() {
        _image = croppedFile;
        _recognitions = recognitions!;
      });
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
    double factorY = _imageHeight / _imageWidth * screen.width;

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

    stackChildren.add(Positioned(
      // using ternary operator
      child: _image == null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text("Please Select an Image"),
        ],
      )
          : Image.file(
        croppedFile!,
        width: 640,
        height: 640,
      ),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(const Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Object Detector"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Fltbtn2",
            onPressed: getImageFromCamera,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: "Fltbtn1",
            onPressed: getImageFromGallery,
            child: const Icon(Icons.photo),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }

  // gets image from camera and runs detectObject
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      croppedFile = await _cropImage(File(pickedFile.path));
      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
          detectObject(_image);
        });
      }
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(File(pickedFile.path));
      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
          detectObject(_image);
        });
      }
    }
  }
  Future<File?> _cropImage(File file) async {

    ImageCropper imageCropper = ImageCropper();

    File? croppedFile = await imageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Image',
      ),
    );
    return croppedFile;
  }
}
