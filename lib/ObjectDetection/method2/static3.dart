// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unused_field, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'croppedImage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class StaticImage3 extends StatefulWidget {
  const StaticImage3({super.key});

  @override
  _StaticImageState createState() => _StaticImageState();
}

class _StaticImageState extends State<StaticImage3> {
  var _image;
  late List _recognitions;
  late bool _busy;
  late double _imageWidth, _imageHeight;
  var userName;

  final picker = ImagePicker();
  setUserName() async {
    var user = FirebaseAuth.instance.currentUser;
    String mail = user!.email.toString();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("parents");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == mail) {
          setState(() {
            userName = element['username'].toString();
          });
          break;
        }
      }
    });
  }

  // this function loads the model
  loadTfModel() async {
    await Tflite.loadModel(
        model: "assets/objecDetec/ssd_mobilenet.tflite",
        labels: "assets/objecDetec/SSDlabelsArabic.txt");
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
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, // required
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5, // defaults to 0.1
        numResultsPerClass: 5, // defaults to 5
        asynch: true // defaults to true
        );
    if (image == null || !(await image.exists())) {
      return AwesomeDialog(
        context: context,
        body: const Text(
          textAlign: TextAlign.center,
          "!حدث خطأ اثناء تحميل الصورة, حاول مجددا ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        dialogType: DialogType.info,
        animType: AnimType.leftSlide,
      ).show();
    }
    // Check that the recognitions array is not empty or null
    if (recognitions == null || recognitions.isEmpty) {
      setState(() {
        _image = null;
        _recognitions = [];
      });
      return AwesomeDialog(
        context: context,
        body: const Text(
          textAlign: TextAlign.center,
          "!لا تحتوي الصورة علي اي اشياء للتعرف عليها,حاول مجددا",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        dialogType: DialogType.info,
        animType: AnimType.leftSlide,
      ).show();
    }
    if (recognitions != null && recognitions.isNotEmpty) {
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
            imageWidth: _imageWidth,
            imageHeight: _imageHeight,
          ),
        ),
      );
    } else {
      setState(() {
        _image = null;
        _recognitions = [];
      });
      return AwesomeDialog(
        context: context,
        body: const Text(
          textAlign: TextAlign.center,
          "!لا تحتوي الصورة علي اي اشياء للتعرف عليها,حاول مجددا",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        dialogType: DialogType.info,
        animType: AnimType.leftSlide,
      ).show();
    }
  }

  @override
  void initState() {
    setUserName();
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

    //double factorX = imageSize.width;
    // double factorY = imageSize.height;
    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;
    print("imageSize.width: ${_imageWidth}, imageSize.height: ${_imageHeight}");
    print("FactorX: ${factorX}, FactorY: ${factorY}");

    Color blue = Colors.blue;
    return _recognitions.map((re) {
      if (re["confidenceInClass"] > 0.50) {
        return Stack(children: [
          Positioned(
            left: re["rect"]["x"] * factorX,
            top: re["rect"]["y"] * factorY,
            width: re["rect"]["w"] * factorX,
            height: re["rect"]["h"] * factorY,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: blue,
                  width: 3,
                ),
              ),
            ),
          ),
          Positioned(
            left: re["rect"]["x"] * factorX,
            top: re["rect"]["y"] * factorY - 25,
            width: 120,
            height: 25,
            child: Container(
              color: blue,
              child: Text(
                "%${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ]);
      } else {
        return Positioned(
          left: re["rect"]["x"] * factorX,
          top: re["rect"]["y"] * factorY,
          width: re["rect"]["w"] * factorX,
          height: re["rect"]["h"] * factorY,
          child: Container(),
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    if (_image == null) {
      stackChildren.add(Padding(
        padding: EdgeInsets.only(top: size.height * 0.15),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/HomePage/discover1.jpg"),
              fit: BoxFit.cover,
              //alignment: Alignment.topCenter, // set the position of the image
            ),
          ),
          height: size.height * 0.66,
          width: size.width,
        ),
      ));
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
        Image.file(_image),
      );
    }
    //Size(_imageWidth, _imageHeight)
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
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    heroTag: "Fltbtn2",
                    onPressed: getImageFromCamera,
                    mini: false,
                    child: const Icon(Icons.camera_alt, size: 80),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    heroTag: "Fltbtn1",
                    onPressed: getImageFromGallery,
                    mini: false,
                    child: const Icon(Icons.photo, size: 80),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: stackChildren,
        ),
      ),
    ));
  }

  // gets image from camera and runs detectObject
  // gets image from camera and runs detectObject
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      detectObject(_image);
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
