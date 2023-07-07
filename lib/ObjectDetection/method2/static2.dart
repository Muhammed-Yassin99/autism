// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unused_field, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'croppedImage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class StaticImage2 extends StatefulWidget {
  const StaticImage2({super.key});

  @override
  _StaticImageState createState() => _StaticImageState();
}

class _StaticImageState extends State<StaticImage2> {
  final player = AudioPlayer();
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
      return Positioned(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ((re["confidenceInClass"] > 0.50))
              ? Stack(children: [
                  Positioned(
                    left: re["rect"]["x"] * factorX,
                    top: re["rect"]["y"] * factorY,
                    width: re["rect"]["w"] * factorX,
                    height: re["rect"]["h"] * factorY,
                    child: GestureDetector(
                      onTap: () {
                        print(re["detectedClass"]);
                        String newPath = getPath(re["detectedClass"]);
                        playBeep(newPath);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: blue,
                          width: 3,
                        )),
                      ),
                    ),
                  ),
                  Positioned(
                    left: re["rect"]["x"] * factorX,
                    top: re["rect"]["y"] * factorY,
                    // left: re["rect"]["x"] * factorX,
                    //top: re["rect"]["y"] * factorY - 33,
                    width: 125,
                    child: GestureDetector(
                      onTap: () {
                        String newPath = getPath(re["detectedClass"]);
                        print(newPath);
                        playBeep(newPath);
                      },
                      child: Container(
                          color: Colors.blue,
                          child: Row(children: [
                            const SizedBox(
                                width:
                                    5), // Add some spacing between the icon and the text
                            Text(
                              "%${re["detectedClass"]} "
                              " ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}",
                              style: TextStyle(
                                background: Paint()..color = blue,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const Icon(
                              size: 20,
                              Icons.volume_up,
                              color: Colors.white,
                            ),
                          ])),
                    ),
                  ),
                ])
              : Container());
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
        Container(child: Image.file(_image)),
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

  Future<void> playBeep(String path) async {
    player.play(AssetSource(path), volume: 1.0);
  }

  String getPath(String label) {
    if (label == 'شخص') {
      String newPath = 'sounds/objectDetec/person.wav';
      return newPath;
    }
    if (label == 'عجلة') {
      String newPath = 'sounds/objectDetec/bike.wav';
      return newPath;
    }
    if (label == 'سيارة') {
      String newPath = 'sounds/objectDetec/car.wav';
      return newPath;
    }
    if (label == 'دراجة نارية') {
      String newPath = 'sounds/objectDetec/motorcycle.wav';
      return newPath;
    }
    if (label == 'طائرة') {
      String newPath = 'sounds/objectDetec/airplane.wav';
      return newPath;
    }
    if (label == 'قطار') {
      String newPath = 'sounds/objectDetec/train.wav';
      return newPath;
    }
    if (label == 'شاحنة نقل') {
      String newPath = 'sounds/objectDetec/truck.wav';
      return newPath;
    }
    if (label == 'مركب') {
      String newPath = 'sounds/objectDetec/boat.wav';
      return newPath;
    }
    if (label == 'اشارة مرور') {
      String newPath = 'sounds/objectDetec/TrafficSignal.wav';
      return newPath;
    }
    if (label == 'صنبور الاطفاء') {
      String newPath = 'sounds/objectDetec/fireHydrant.wav';
      return newPath;
    }
    if (label == 'علامة وقوف') {
      String newPath = 'sounds/objectDetec/stopSign.wav';
      return newPath;
    }
    if (label == 'عداد موقف السيارات') {
      String newPath = 'sounds/objectDetec/ParkingMeter.wav';
      return newPath;
    }
    if (label == 'مقعد') {
      String newPath = 'sounds/objectDetec/seat.wav';
      return newPath;
    }
    if (label == 'طائر') {
      String newPath = 'sounds/objectDetec/bird.wav';
      return newPath;
    }
    if (label == 'قطة') {
      String newPath = 'sounds/objectDetec/cat.wav';
      return newPath;
    }
    if (label == 'كلب') {
      String newPath = 'sounds/objectDetec/dog.wav';
      return newPath;
    }
    if (label == 'حصان') {
      String newPath = 'sounds/objectDetec/horse.wav';
      return newPath;
    }
    if (label == 'خاروف') {
      String newPath = 'sounds/objectDetec/sheep.wav';
      return newPath;
    }
    if (label == 'بقرة') {
      String newPath = 'sounds/objectDetec/cow.wav';
      return newPath;
    }
    if (label == 'بروكلي') {
      String newPath = 'sounds/objectDetec/broccoli.wav';
      return newPath;
    }
    if (label == 'جزرة') {
      String newPath = 'sounds/objectDetec/carrot.wav';
      return newPath;
    }
    if (label == 'سوسيس') {
      String newPath = 'sounds/objectDetec/sausage.wav';
      return newPath;
    }
    if (label == 'بيتزا') {
      String newPath = 'sounds/objectDetec/pizza.wav';
      return newPath;
    }
    if (label == 'دونتس') {
      String newPath = 'sounds/objectDetec/donut.wav';
      return newPath;
    }
    if (label == 'كيكة') {
      String newPath = 'sounds/objectDetec/cake.wav';
      return newPath;
    }
    if (label == 'كرسي') {
      String newPath = 'sounds/objectDetec/chair.wav';
      return newPath;
    }
    if (label == 'كنبة') {
      String newPath = 'sounds/objectDetec/sofa.wav';
      return newPath;
    }
    if (label == 'اصرية زرع') {
      String newPath = 'sounds/objectDetec/pottedPlant.wav';
      return newPath;
    }
    if (label == 'فراش(سرير)') {
      String newPath = 'sounds/objectDetec/bed.wav';
      return newPath;
    }
    if (label == 'مائدة طعام') {
      String newPath = 'sounds/objectDetec/diningTable.wav';
      return newPath;
    }
    if (label == 'مرحاض(حمام)') {
      String newPath = 'sounds/objectDetec/toilet.wav';
      return newPath;
    }
    if (label == 'تلفزيون') {
      String newPath = 'sounds/objectDetec/tv.wav';
      return newPath;
    }
    if (label == 'لابتوب') {
      String newPath = 'sounds/objectDetec/laptop.wav';
      return newPath;
    }
    if (label == 'فارة التحكم') {
      String newPath = 'sounds/objectDetec/controlMouse.wav';
      return newPath;
    }
    if (label == 'ريموت') {
      String newPath = 'sounds/objectDetec/remote.wav';
      return newPath;
    }
    if (label == 'لوحة المفاتيح') {
      String newPath = 'sounds/objectDetec/keyboard.wav';
      return newPath;
    }
    if (label == 'هاتف محمول') {
      String newPath = 'sounds/objectDetec/mobile.wav';
      return newPath;
    }
    if (label == 'مايكروايف') {
      String newPath = 'sounds/objectDetec/microwave.wav';
      return newPath;
    }
    if (label == 'فرن') {
      String newPath = 'sounds/objectDetec/oven.wav';
      return newPath;
    }
    if (label == 'محمصة') {
      String newPath = 'sounds/objectDetec/toaster.wav';
      return newPath;
    }
    if (label == 'حوض') {
      String newPath = 'sounds/objectDetec/sink.wav';
      return newPath;
    }
    if (label == 'ثلاجة') {
      String newPath = 'sounds/objectDetec/fridge.wav';
      return newPath;
    }
    if (label == 'كتاب') {
      String newPath = 'sounds/objectDetec/book.wav';
      return newPath;
    }
    if (label == 'ساعة') {
      String newPath = 'sounds/objectDetec/watch.wav';
      return newPath;
    }
    if (label == 'مزهرية') {
      String newPath = 'sounds/objectDetec/vase.wav';
      return newPath;
    }
    if (label == 'مقصات') {
      String newPath = 'sounds/objectDetec/scissors.wav';
      return newPath;
    }
    if (label == 'دبدوب') {
      String newPath = 'sounds/objectDetec/teadyBear.wav';
      return newPath;
    }
    if (label == 'مجفف شعر') {
      String newPath = 'sounds/objectDetec/hairDryer.wav';
      return newPath;
    }
    if (label == 'فرشة اسنان') {
      String newPath = 'sounds/objectDetec/teethBrush.wav';
      return newPath;
    }
    if (label == 'فيل') {
      String newPath = 'sounds/objectDetec/elephant.wav';
      return newPath;
    }
    if (label == 'دب') {
      String newPath = 'sounds/objectDetec/bear.wav';
      return newPath;
    }
    if (label == 'حمار وحشي') {
      String newPath = 'sounds/objectDetec/zebra.wav';
      return newPath;
    }
    if (label == 'ظرافة') {
      String newPath = 'sounds/objectDetec/giraffe.wav';
      return newPath;
    }
    if (label == 'حقيبة ظهر') {
      String newPath = 'sounds/objectDetec/backpack.wav';
      return newPath;
    }
    if (label == 'مظلة') {
      String newPath = 'sounds/objectDetec/umbrella.wav';
      return newPath;
    }
    if (label == 'حقيبة يد') {
      String newPath = 'sounds/objectDetec/handBag.wav';
      return newPath;
    }
    if (label == 'ربطة') {
      String newPath = 'sounds/objectDetec/tie.wav';
      return newPath;
    }
    if (label == 'حقيبة سفر') {
      String newPath = 'sounds/objectDetec/suitcase.wav';
      return newPath;
    }
    if (label == 'طبق طائر') {
      String newPath = 'sounds/objectDetec/frisbee.wav';
      return newPath;
    }
    if (label == 'لوح تزحلق') {
      String newPath = 'sounds/objectDetec/surfingBoard.wav';
      return newPath;
    }
    if (label == 'لوح تزلج') {
      String newPath = 'sounds/objectDetec/skateboard.wav';
      return newPath;
    }
    if (label == 'كرة رياضة') {
      String newPath = 'sounds/objectDetec/sportsBall.wav';
      return newPath;
    }
    if (label == 'طائرة ورقية') {
      String newPath = 'sounds/objectDetec/kite.wav';
      return newPath;
    }
    if (label == 'مضرب بيسبول') {
      String newPath = 'sounds/objectDetec/baseballBat.wav';
      return newPath;
    }
    if (label == 'قفاز بيسبول') {
      String newPath = 'sounds/objectDetec/baseballGlove.wav';
      return newPath;
    }
    if (label == 'لوح التزحلق') {
      String newPath = 'sounds/objectDetec/surfingBoard1.wav';
      return newPath;
    }
    if (label == 'لوح ركوب الامواج') {
      String newPath = 'sounds/objectDetec/windsurfingBoard.wav';
      return newPath;
    }
    if (label == 'مضرب تينس') {
      String newPath = 'sounds/objectDetec/tennisRacket.wav';
      return newPath;
    }
    if (label == 'زجاجة') {
      String newPath = 'sounds/objectDetec/bottle.wav';
      return newPath;
    }
    if (label == 'زجاجة عنب') {
      String newPath = 'sounds/objectDetec/grapeBottle.wav';
      return newPath;
    }
    if (label == 'فنجان') {
      String newPath = 'sounds/objectDetec/cup.wav';
      return newPath;
    }
    if (label == 'شوكة') {
      String newPath = 'sounds/objectDetec/fork.wav';
      return newPath;
    }
    if (label == 'سكينة') {
      String newPath = 'sounds/objectDetec/knife.wav';
      return newPath;
    }
    if (label == 'ملعقة') {
      String newPath = 'sounds/objectDetec/spoon.wav';
      return newPath;
    }
    if (label == 'إناء') {
      String newPath = 'sounds/objectDetec/bowl.wav';
      return newPath;
    }
    if (label == 'موزة') {
      String newPath = 'sounds/objectDetec/banana.wav';
      return newPath;
    }
    if (label == 'تفاحة') {
      String newPath = 'sounds/objectDetec/apple.wav';
      return newPath;
    }
    if (label == 'طعام') {
      String newPath = 'sounds/objectDetec/sadwich.wav';
      return newPath;
    }
    if (label == 'برتقال') {
      String newPath = 'sounds/objectDetec/orange.wav';
      return newPath;
    } else {
      String newPath = 'sounds/objectDetec/unknown.wav';
      return newPath;
    }
  }
}
