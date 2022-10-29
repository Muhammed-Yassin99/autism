// ignore_for_file: duplicate_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'HomePage/parentHomePage.dart';
import 'HomePage/startPage.dart';
import 'HomePage/trainerHomePage.dart';
import 'SignIn/signInScreen.dart';
import 'model/splashScreen.dart';

bool islogin = false;
bool hasRole = false;

Future<void> main() async {
  String role = '';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    islogin = true;
    String uid = user.uid.toString();
    var documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    documentReference.get().then((value) {
      role = value['role'].toString();
    });
    if (role == "parents") {
      hasRole = false;
    } else if (role == "trainers") {
      hasRole == true;
    }
  } else {
    islogin = false;
  }
  runApp(const MyApp());
}

getRole(context) {
  String role = '';
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String uid = user.uid.toString();
    var documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    documentReference.get().then((value) {
      role = value['role'].toString();
    });
    if (role == "parents") {
    } else if (role == "trainers") {
      Navigator.of(context).pushReplacementNamed("trainerHomePage");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autism',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "startPage": (context) => const startPage(),
        "login": (context) => const signInScreen(),
        "parentHomePage": (context) => const HomePage(),
        "trainerHomePage": (context) => const trainerHomePage(),
      },
      home: islogin == false
          ? const startPage()
          : hasRole == false
              ? const HomePage()
              : const trainerHomePage(),
    );
  }
}
