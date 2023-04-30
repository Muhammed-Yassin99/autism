// ignore_for_file: must_be_immutable, camel_case_types

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class needs extends StatefulWidget {
  const needs({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<needs> {
  final player = AudioPlayer();
  final List<String> images = [
    'assets/images/needs/1.jpg',
    'assets/images/needs/2.jpg',
    'assets/images/needs/3.jpg',
    'assets/images/needs/4.jpg',
    'assets/images/needs/5.jpg',
    'assets/images/needs/6.jpg',
    'assets/images/needs/7.jpg',
    'assets/images/needs/8.jpg',
    'assets/images/needs/9.jpg',
    'assets/images/needs/10.jpg',
    'assets/images/needs/11.jpg',
    'assets/images/needs/12.jpg',
  ];

  final List<String> labels = [
    'انا جائع',
    'انا عطشان',
    'اريد دخول الحمام',
    'اريد اللعب',
    'اريد الخروج',
    'اريد النوم',
    'اين ابي',
    'اين امي',
    'اريد طعام غير هذا',
    'لا احب هذه اللعبة',
    'هذه لعبة جيدة',
    'اريد اصدقائي'
  ];

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('التعبير عن الاحتياجات'),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: labels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            String label = labels[index];
            String imageUrl = images[index];
            String sound = 'sounds/needs/${index + 1}.m4a';

            return GestureDetector(
              onTap: () {
                playBeep(sound);
                AwesomeDialog(
                  context: context,
                  body: Column(
                    children: [
                      Image.asset(
                        imageUrl,
                        height: 450,
                        width: 450,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  dialogType: DialogType.success,
                  animType: AnimType.leftSlide,
                ).show();
              },
              child: Stack(
                children: [
                  Image.asset(
                    imageUrl,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> playBeep(String path) async {
    player.play(AssetSource(path), volume: 1.0);
  }
}
