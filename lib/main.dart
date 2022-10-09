// ignore_for_file: duplicate_import
import 'package:flutter/material.dart';
import 'HomePage/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      //TEST
    );
  }
}
