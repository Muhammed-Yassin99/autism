// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../HomePage/ParentView/parentHomePage.dart';
import 'learnAnimals1.dart';
import 'learnAnimals3.dart';

// ignore: camel_case_types
class learnAnimals2 extends StatelessWidget {
  final player = AudioPlayer();
  learnAnimals2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0.0,
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'هيا لنتعلم الحيوانات',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.teal,
          child: Stack(
            children: [
              Positioned(
                right: MediaQuery.of(context).size.width * 0.20,
                top: MediaQuery.of(context).size.height * 0.05,
                child: Material(
                  color: const Color.fromARGB(255, 10, 79, 135),
                  elevation: 8,
                  borderRadius: BorderRadius.circular(28),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    splashColor: Colors.black26,
                    onTap: () {
                      playBeep('sounds/learn/animals/cow.wav');
                    },
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Ink.image(
                        image: const AssetImage(
                            "assets/images/games/animals/cow.png"),
                        height: MediaQuery.of(context).size.height * 0.26,
                        width: MediaQuery.of(context).size.width * 0.585,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'بقرة ',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.amber,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width * 0.20,
                top: MediaQuery.of(context).size.height * 0.48,
                child: Material(
                  color: const Color.fromARGB(255, 10, 79, 135),
                  elevation: 8,
                  borderRadius: BorderRadius.circular(28),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    splashColor: Colors.black26,
                    onTap: () {
                      playBeep('sounds/learn/animals/sheep.wav');
                    },
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Ink.image(
                        image: const AssetImage(
                            "assets/images/games/animals/sheep.png"),
                        height: MediaQuery.of(context).size.height * 0.26,
                        width: MediaQuery.of(context).size.width * 0.585,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'خروف',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.amber,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.height * 0.40,
                child: FloatingActionButton(
                    heroTag: "btn3Alvl2",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => learnAnimals3()),
                      );
                    },
                    child: const Icon(Icons.navigate_next_sharp)),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.height * 0.40,
                child: FloatingActionButton(
                    heroTag: "btn1Alvl2",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => learnAnimals1()),
                      );
                    },
                    child: const Icon(Icons.navigate_before_sharp)),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.width * 0.03,
                child: FloatingActionButton(
                    heroTag: "btn2Alvl2",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Icon(
                      Icons.home_filled,
                      color: Color.fromARGB(255, 143, 33, 162),
                      size: 50,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> playBeep(String path) async {
    player.play(AssetSource(path), volume: 1.0);
  }
}
