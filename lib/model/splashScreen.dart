// ignore_for_file: file_names

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EasySplashScreen(
          showLoader: true,
          logo: Image.asset('images/HomePage/startPage.jpg'),
          loadingText: const Text("Loading..."),
          loaderColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
