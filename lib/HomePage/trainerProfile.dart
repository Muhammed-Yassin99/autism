// ignore_for_file: library_private_types_in_public_api, camel_case_types, unused_field, unused_local_variable, deprecated_member_use, prefer_typing_uninitialized_variables
import 'dart:io';
import 'package:autism_zz/HomePage/trainerHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class trainerProfile extends StatefulWidget {
  const trainerProfile({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<trainerProfile> {
  bool showPassword = false;
  String imageUrl = "";
  File? _image;
  String? _imageUrl;
  final _firebaseStorage = FirebaseStorage.instance;
  var userName;
  var userGmail;
  var userPic;
  CollectionReference trainerRef =
      FirebaseFirestore.instance.collection("trainers");
  var uid = FirebaseAuth.instance.currentUser!.uid;

  getUserNameAndEmail() async {
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
          });
        }
      }
    });
  }

  getUserImage() async {
    var user = FirebaseAuth.instance.currentUser;
    String mail = user!.email.toString();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == mail) {
          setState(() {
            userPic = element['profilePic'].toString();
          });
          break;
        }
      }
    });
    if (userPic == "") {
      userPic =
          "https://firebasestorage.googleapis.com/v0/b/graduationproject-35c1f.appspot.com/o/images%2FdefaultPic.png?alt=media&token=bdd0c8b8-7632-40b0-9c2d-4d815264b221";
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
        });
        DocumentReference ref = trainerRef.doc(uid);
        ref.update({"profilePic": _imageUrl});
        if (kDebugMode) {
          print('Image uploaded successfully: $_imageUrl');
        }
      });
    }
  }

  @override
  void initState() {
    getUserNameAndEmail();
    getUserImage();
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
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const trainerHomePage()));
            },
          ),
        ],
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
              buildTextField("Full Name", userName.toString(), false),
              buildTextField("E-mail",
                  FirebaseAuth.instance.currentUser!.email.toString(), false),
              buildTextField("Password", "********", true),
              buildTextField("Location", "trash", false),
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
                    onPressed: () {},
                    child: const Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
