// ignore_for_file: file_names, camel_case_types

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: EasySplashScreen(
          showLoader: true,
          logo: Image.asset("assets/images/HomePage/startPage.jpg"),
          loadingText: const Text("Loading..."),
          loaderColor: Colors.blueAccent,
          durationInSeconds: 3,
          navigator: const MyApp(),
        ),
      ),
    );
  }
}
