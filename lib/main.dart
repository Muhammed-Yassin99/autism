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
      title: 'Match game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
/*void main() {
  // ignore: prefer_const_constructors
  runApp(MaterialApp(
      home: Scaffold(
    appBar: AppBar(),
    drawer: Drawer(),
    // ignore: prefer_const_constructors
    body: Container(
      color: Colors.black87,
      child: Text("OfA7 Fuck You",
          textDirection: TextDirection.ltr,
          // ignore: prefer_const_constructors
          style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 224, 16, 13),
              fontWeight: FontWeight.w600,
              letterSpacing: 5.0,
              wordSpacing: 10,
              decoration: TextDecoration.underline,
              // backgroundColor: Color.fromARGB(255, 11, 131, 230),
              // ignore: prefer_const_literals_to_create_immutables
              shadows: [
                // ignore: prefer_const_constructors
                Shadow(
                    color: Colors.blueAccent,
                    blurRadius: 3.0,
                    // ignore: prefer_const_constructors
                    offset: Offset(2.0, 4.0))
              ])),
    ),
  )));
}*/
