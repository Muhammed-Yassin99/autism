// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../HomePage/parentHomePage.dart';
import 'learnThemes1.dart';

// ignore: camel_case_types
class learnThemes2 extends StatelessWidget {
  final player = AudioPlayer();
  learnThemes2({super.key});

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
            'هيا لنتعلم المشهد العاطفي',
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
      body: Container(
        color: Colors.teal,
        child: Center(
            child: Stack(children: [
          Positioned(
            right: 70,
            top: 25,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/themes/eating.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image: const AssetImage(
                        "assets/images/learn/themes/eating.jpg"),
                    height: 220,
                    width: 290,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'تناول الطعام',
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
            right: 70,
            top: 370,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/themes/party.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image: const AssetImage(
                        "assets/images/learn/themes/party.jpg"),
                    height: 220,
                    width: 290,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'حفلة عيدميلاد',
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
            left: 0,
            top: 310,
            child: FloatingActionButton(
                heroTag: "btn1THlvl2",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => learnThemes1()),
                  );
                },
                child: const Icon(Icons.navigate_before_sharp)),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: FloatingActionButton(
                heroTag: "btn2THLvl2",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Icon(
                  Icons.home_filled,
                  color: Color.fromARGB(255, 143, 33, 162),
                  size: 40,
                )),
          ),
        ])),
      ),
    );
  }

  Future<void> playBeep(String path) async {
    player.play(AssetSource(path), volume: 1.0);
  }
}
