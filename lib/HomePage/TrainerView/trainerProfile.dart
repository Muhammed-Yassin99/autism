// ignore_for_file: library_private_types_in_public_api, camel_case_types, unused_field, unused_local_variable, deprecated_member_use, prefer_typing_uninitialized_variables
import 'dart:io';
import 'package:Autism_Helper/HomePage/TrainerView/editProfile.dart';
import 'package:Autism_Helper/HomePage/TrainerView/trainerHomePage.dart';
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
  var userYearsOfExp;
  var userLocation;
  var availabeTimes;
  var moreDetailsAboutYou;
  CollectionReference trainerRef =
      FirebaseFirestore.instance.collection("trainers");
  var uid = FirebaseAuth.instance.currentUser!.uid;

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
            availabeTimes = element['availabeTimes'].toString();
            moreDetailsAboutYou = element['moreDetailsAboutYou'].toString();
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
            Navigator.of(context).pushReplacementNamed("trainerHomePage");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const editTrainerProfile()));
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
                textAlign: TextAlign.right,
                "الملف الشخصي",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
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
                            color: Colors.blue,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 5,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userPic.toString()))),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              buildTextField("الاسم بالكامل", userName.toString()),
              buildTextField("البريد الألكتروني",
                  FirebaseAuth.instance.currentUser!.email.toString()),
              buildTextField("سنين الخبرة", userYearsOfExp.toString()),
              buildTextField("محل العمل", userLocation.toString()),
              buildTextField("أوقات العمل", availabeTimes.toString()),
              buildTextField(
                  "مزيد من التفاصيل عنك", moreDetailsAboutYou.toString()),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        enabled: false,
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
        ),
      ),
    );
  }
}
