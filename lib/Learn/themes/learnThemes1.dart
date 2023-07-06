// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../HomePage/ParentView/parentHomePage.dart';
import 'learnThemes2.dart';

// ignore: camel_case_types
class learnThemes1 extends StatelessWidget {
  final player = AudioPlayer();
  learnThemes1({super.key});

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
            right: MediaQuery.of(context).size.width * .15,
            top: MediaQuery.of(context).size.height * .07,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/themes/playing.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image: const AssetImage(
                        "assets/images/learn/themes/playing.jpg"),
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width * .75,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'اللعب مع الاصدقاء',
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
            right: MediaQuery.of(context).size.width * .15,
            bottom: MediaQuery.of(context).size.height * .07,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/themes/reading.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image: const AssetImage(
                        "assets/images/learn/themes/reading.jpg"),
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width * .75,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'قراءة الكتب',
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
            right: 10,
            top: 310,
            child: FloatingActionButton(
                heroTag: "btn1THlvl1",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => learnThemes2()),
                  );
                },
                child: const Icon(Icons.navigate_next_sharp)),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: FloatingActionButton(
                heroTag: "btn2THlvl1",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Icon(
                  Icons.home_filled,
                  color: Color.fromARGB(255, 143, 33, 162),
                  size: 50,
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
