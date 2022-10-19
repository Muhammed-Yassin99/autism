// ignore_for_file: duplicate_import
import 'package:autism_zz/HomePage/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
        "login": (context) => const signInScreen(),
        "homePage": (context) => const HomePage(),
      },
      home: islogin == false ? const signInScreen() : const HomePage(),
    );
  }
}
