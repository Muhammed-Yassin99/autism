import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'level2.dart';

// ignore: camel_case_types
class learnfaces3 extends StatelessWidget {
  final player = AudioPlayer();
  learnfaces3({super.key});

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
            'هيا لنتعلم الاوجه',
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
      body: Center(
          child: Stack(children: [
        Positioned(
          right: 80,
          top: 10,
          child: Material(
            color: const Color.fromARGB(255, 10, 79, 135),
            elevation: 8,
            borderRadius: BorderRadius.circular(28),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              splashColor: Colors.black26,
              onTap: () {
                playBeep('sounds/true.wav');
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Ink.image(
                  image: const AssetImage(
                      "assets/images/learn/faces/girlAngry.jpg"),
                  height: 190,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'فتاة غاضبة',
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
          right: 80,
          top: 275,
          child: Material(
            color: const Color.fromARGB(255, 10, 79, 135),
            elevation: 8,
            borderRadius: BorderRadius.circular(28),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              splashColor: Colors.black26,
              onTap: () {
                playBeep('sounds/false.wav');
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Ink.image(
                  image: const AssetImage(
                      "assets/images/learn/faces/girlCalm.jpg"),
                  height: 190,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'فتاة هادئة',
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
          left: 10,
          top: 235,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => learnfaces2()),
                );
              },
              child: const Icon(Icons.navigate_before_sharp)),
        ),
      ])),
    );
  }

  Future<void> playBeep(String path) async {
    player.play(AssetSource(path), volume: 1.0);
  }
}
