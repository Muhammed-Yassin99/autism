// ignore_for_file: duplicate_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'HomePage/parentHomePage.dart';
import 'HomePage/startPage.dart';
import 'HomePage/trainerHomePage.dart';
import 'SignIn/signInScreen.dart';

bool islogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  runApp(const MyApp());
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
      home: islogin == false ? const startPage() : const HomePage(),
    );
  }
}
