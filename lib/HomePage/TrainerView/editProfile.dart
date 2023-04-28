// ignore_for_file: library_private_types_in_public_api, camel_case_types, unused_field, unused_local_variable, deprecated_member_use, prefer_typing_uninitialized_variables, depend_on_referenced_packages
import 'dart:io';
import 'package:autism_zz/HomePage/TrainerView/trainerHomePage.dart';
import 'package:autism_zz/HomePage/TrainerView/trainerProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class editTrainerProfile extends StatefulWidget {
  const editTrainerProfile({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<editTrainerProfile> {
  bool showPassword = false;
  String imageUrl = "";
  File? _image;
  String? _imageUrl;
  final _firebaseStorage = FirebaseStorage.instance;
  var userName;
  var userGmail;
  var userPic;
  var userYearsOfExp;
  var userLocation;
  var editedDate = [];
  final TimeOfDay _startTime = const TimeOfDay(hour: 12, minute: 0);
  final TimeOfDay _endTime = const TimeOfDay(hour: 20, minute: 0);
  CollectionReference trainerRef =
      FirebaseFirestore.instance.collection("trainers");
  var uid = FirebaseAuth.instance.currentUser!.uid;
  List<TextEditingController> controllers = List.generate(
    3,
    (index) => TextEditingController(),
  );

  getUserInfo() async {
    var user = FirebaseAuth.instance.currentUser;
    String gmail = user!.email.toString();
    userGmail = gmail;
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == gmail) {
          setState(() {
            userName = element['username'].toString();
            userPic = element['profilePic'].toString();
            userYearsOfExp = element['yearsOfExp'].toString();
            userLocation = element['location'].toString();
          });
        }
      }
    });
    if (userPic == "") {
      userPic =
          "https://firebasestorage.googleapis.com/v0/b/graduationproject-35c1f.appspot.com/o/images%2Fdoctor.png?alt=media&token=04531c72-1cf6-48f2-a20c-f305e8cd33a7";
    }
    if (userYearsOfExp == "") {
      userYearsOfExp = "لم تقم باضافة سنين الخبرة";
    }
    if (userLocation == "") {
      userLocation = "لم تقم باضافة مكان العيادة الخاصة بك";
    }
    editedDate.add(userName);
    editedDate.add(userYearsOfExp);
    editedDate.add(userLocation);
    editedDate.add(userPic);
    if (kDebugMode) {
      print(editedDate[2]);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = Path.basename(file.path);
      final storageRef = _firebaseStorage.ref().child('images/$fileName');
      final uploadTask = storageRef.putFile(file);

      await uploadTask.whenComplete(() async {
        final downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          _image = file;
          _imageUrl = downloadUrl;
          editedDate[3] = _imageUrl;
          userPic = _imageUrl;
        });
      });
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const trainerProfile()));
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userPic.toString()))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _pickImage,
                            iconSize: 20,
                            color: Colors.white,
                            alignment: Alignment.center,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              buildTextField("الاسم بالكامل", userName.toString(), 0),
              buildTextField("سنين الخبرة", userYearsOfExp.toString(), 1),
              buildTextField("محل العمل", userLocation.toString(), 2),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return Colors.white;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const trainerProfile()));
                    },
                    child: const Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        saveChanges();
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const trainerProfile()));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return Colors.white;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  saveChanges() async {
    setState(() {
      DocumentReference ref = trainerRef.doc(uid);
      ref.update({"profilePic": editedDate[3]});
      ref.update({"username": editedDate[0]});
      ref.update({"yearsOfExp": editedDate[1]});
      ref.update({"location": editedDate[2]});
    });
    /*if (kDebugMode) {
      print('Image uploaded successfully: $_imageUrl');
    }*/
  }

  Widget buildTextField(String labelText, String placeholder, int num) {
    TextEditingController controller = controllers[num];
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        onChanged: (String newText) {
          String currentHintText = controller.text;
          editedDate[num] = currentHintText;
          print('New hint text: $newText');
          print('Current hint text: $currentHintText');
          print(editedDate[0]);
          print(editedDate[3]);
        },
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        enabled: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget buildTextField1(String labelText, String placeholder, int num) {
    TextEditingController controller = controllers[1];
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        onChanged: (String newText) {
          String currentHintText = controller.text;
          editedDate[num] = currentHintText;
          print('New hint text: $newText');
          print('Current hint text: $currentHintText');
          print(editedDate[0]);
          print(editedDate[3]);
        },
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        enabled: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget buildTextField2(String labelText, String placeholder, int num) {
    TextEditingController controller = controllers[2];
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        onChanged: (String newText) {
          String currentHintText = controller.text;
          editedDate[num] = currentHintText;
          print('New hint text: $newText');
          print('Current hint text: $currentHintText');
          print(editedDate[0]);
          print(editedDate[3]);
        },
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        enabled: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
