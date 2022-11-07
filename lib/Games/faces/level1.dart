// ignore_for_file: file_names, unused_element, must_be_immutable, library_private_types_in_public_api, camel_case_types, non_constant_identifier_names
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../../model/item_model.dart';
import '../../HomePage/parentHomePage.dart';

// ignore: use_key_in_widget_constructors
class facesLevel1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<facesLevel1> {
  final controller = ConfettiController();
  final player = AudioPlayer();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late int lvl;
  late bool gameOver;

  initGame1() {
    gameOver = false;
    score = 0;
    lvl = 1;
    items = [
      ItemModel(
        value: 'بكاء',
        name: 'بكاء',
        img: 'assets/images/games/faces/cry.png',
        sound: 'sounds/learn/faces/cry.wav',
      ),
      ItemModel(
          value: 'سعيد',
          name: 'سعيد',
          img: 'assets/images/games/faces/happy.png',
          sound: 'sounds/learn/faces/happy.wav'),
      ItemModel(
          value: 'حزين',
          name: 'حزين',
          img: 'assets/images/games/faces/sad.png',
          sound: 'sounds/learn/faces/sad.wav'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  initGame2() {
    gameOver = false;
    score = 0;
    lvl = 2;
    items = [
      ItemModel(
          value: 'دهشة',
          name: 'دهشة',
          img: 'assets/images/games/faces/surprised.png',
          sound: 'sounds/learn/faces/surprise.wav'),
      ItemModel(
          value: 'غاضب',
          name: 'غاضب',
          img: 'assets/images/games/faces/angry.png',
          sound: 'sounds/learn/faces/angry.wav'),
      ItemModel(
          value: 'هادئ',
          name: 'هادئ',
          img: 'assets/images/games/faces/calm.png',
          sound: 'sounds/learn/faces/calm.wav'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame1();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) gameOver = true;
    if (gameOver && score < 20) {
      if (lvl == 1) {
        initGame1();
      } else {
        initGame2();
      }
    }
    if (gameOver && score >= 20) {
      initGame2();
    }
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Container(
          color: Colors.teal,
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ConfettiWidget(
                  confettiController: controller,
                  shouldLoop: false,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 20,
                  emissionFrequency: 0.09,
                  gravity: 1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$score',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: ' :النقاط',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!gameOver)
                      Row(
                        children: [
                          const Spacer(),
                          Column(
                            children: items.map((item) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                child: Draggable<ItemModel>(
                                  data: item,
                                  childWhenDragging: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(item.img),
                                    radius: 50,
                                  ),
                                  feedback: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(item.img),
                                    radius: 50,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(item.img),
                                    radius: 50,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Spacer(flex: 1),
                          Column(
                            children: items2.map((item) {
                              return DragTarget<ItemModel>(
                                onAccept: (receivedItem) {
                                  if (item.value == receivedItem.value) {
                                    setState(() {
                                      items.remove(receivedItem);
                                      items2.remove(item);
                                    });
                                    score += 10;
                                    item.accepting = false;
                                    playBeep('sounds/true.wav');
                                    controller.play();
                                    Timer(const Duration(seconds: 1),
                                        (() => controller.stop()));
                                  } else {
                                    setState(() {
                                      score -= 5;
                                      item.accepting = false;
                                    });
                                    playBeep('sounds/false.wav');
                                  }
                                },
                                onWillAccept: (receivedItem) {
                                  setState(() {
                                    item.accepting = true;
                                  });
                                  return true;
                                },
                                onLeave: (receivedItem) {
                                  setState(() {
                                    item.accepting = false;
                                  });
                                },
                                builder:
                                    (context, acceptedItems, rejectedItems) =>
                                        Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: item.accepting
                                        ? Colors.grey[400]
                                        : Colors.grey[200],
                                  ),
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.width / 6.5,
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                  margin: const EdgeInsets.all(8),
                                  child: TextButton(
                                    onPressed: () {
                                      playBeep(item.sound);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          const Size.fromHeight(50), // NEW
                                    ),
                                    // ignore: prefer_const_constructors
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Icon(Icons.volume_up_sharp),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Spacer(),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 40,
          child: FloatingActionButton(
              heroTag: "facesHome",
              backgroundColor: Colors.amber,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Icon(
                Icons.home_filled,
                color: Colors.blue,
                size: 50,
              )),
        ),
        if (lvl == 2)
          Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height * 0.5,
            child: FloatingActionButton(
                heroTag: "facesBack1",
                onPressed: () {
                  setState(() {
                    initGame1();
                  });
                },
                child: const Icon(Icons.navigate_before_sharp)),
          ),
      ],
    )));
  }

  String result() {
    if (score == 30) {
      playBeep('sounds/success.wav');
      return ' !احسنت ';
    } else {
      playBeep('sounds/tryAgain.wav');
      return 'العب مجددا لتحصل علي نتيجة افضل';
    }
  }

  Future<void> playBeep(String path) async {
    player.play(AssetSource(path), volume: 1.0);
  }
}
