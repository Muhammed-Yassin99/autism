// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../HomePage/home.dart';
import 'learnDigits7.dart';
import 'learnDigits5.dart';
//import 'learnAnimals2.dart';

// ignore: camel_case_types
class learnDigits6 extends StatelessWidget {
  final player = AudioPlayer();
  learnDigits6({super.key});

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
            'هيا لنتعلم الحروف',
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
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.10,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/digits/qaaf.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image:
                        const AssetImage("assets/images/learn/digits/qaaf.jpg"),
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: MediaQuery.of(context).size.height * 0.20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'قاف',
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
            left: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.10,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/digits/kaaf.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image:
                        const AssetImage("assets/images/learn/digits/kaaf.jpg"),
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: MediaQuery.of(context).size.height * 0.20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'كاف',
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
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.5,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/digits/laam.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image:
                        const AssetImage("assets/images/learn/digits/laam.jpg"),
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: MediaQuery.of(context).size.height * 0.20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'لام',
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
            left: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.5,
            child: Material(
              color: const Color.fromARGB(255, 10, 79, 135),
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  playBeep('sounds/learn/digits/meem.wav');
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image:
                        const AssetImage("assets/images/learn/digits/meem.jpg"),
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: MediaQuery.of(context).size.height * 0.20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'ميم',
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
            left: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.height * 0.40,
            child: FloatingActionButton(
                heroTag: "btn1Dlvl6",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => learnDigits5()),
                  );
                },
                child: const Icon(Icons.navigate_before_sharp)),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.height * 0.40,
            child: FloatingActionButton(
                heroTag: "btn2Dlvl6",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => learnDigits7()),
                  );
                },
                child: const Icon(Icons.navigate_next_sharp)),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.height * 0.03,
            child: FloatingActionButton(
                heroTag: "btn3Dlvl6",
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
