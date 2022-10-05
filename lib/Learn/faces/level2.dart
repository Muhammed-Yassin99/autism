import 'package:autism_zz/Learn/faces/level1.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// ignore: camel_case_types
class learnfaces2 extends StatelessWidget {
  final player = AudioPlayer();
  learnfaces2({super.key});

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
          child: Column(children: [
        Material(
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
                image:
                    const AssetImage("assets/images/learn/faces/boyHappy.jpg"),
                height: 190,
                width: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'ولد سعيد',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.amber,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Material(
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
                image: const AssetImage("assets/images/learn/faces/boySad.jpg"),
                height: 190,
                width: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'ولد حزين',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.amber,
                ),
              ),
            ]),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 + 100,
          top: MediaQuery.of(context).size.height / 2,
          child: Container(
              color: Colors.red,
              width: 50,
              height: 50,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => learnfaces1()),
                    );
                  },
                  child: const Text(
                    '>',
                  ))),
        ),
      ])),
    );
  }

  Future<void> playBeep(String path) async {
    player.play(AssetSource(path), volume: 1.0);
  }
}
