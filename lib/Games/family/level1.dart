// ignore_for_file: file_names, unused_element, must_be_immutable, library_private_types_in_public_api, camel_case_types
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../../model/item_model.dart';
import '../../HomePage/home.dart';

// ignore: use_key_in_widget_constructors
class familyLevel1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<familyLevel1> {
  final player = AudioPlayer();
  final controller = ConfettiController();
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
          value: 'اخ',
          name: 'اخ',
          img: 'assets/images/games/family/brothers.png',
          sound: 'sounds/learn/family/brother.wav'),
      ItemModel(
          value: 'اخت',
          name: 'اخت',
          img: 'assets/images/games/family/sister.png',
          sound: 'sounds/learn/family/sister.wav'),
      ItemModel(
          value: 'ام',
          name: 'ام',
          img: 'assets/images/games/family/mother.jpg',
          sound: 'sounds/learn/family/mother.wav'),
      ItemModel(
          value: 'اب',
          name: 'اب',
          img: 'assets/images/games/family/father.jpg',
          sound: 'sounds/learn/family/father.wav'),
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
    if (gameOver) {
      initGame1();
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Colors.teal,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(color: Colors.black),
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
                                    Timer(const Duration(seconds: 2),
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
                                      // ignore: prefer_const_constructors
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
                                      )),
                                ),
                              );
                            }).toList(),
                          ),
                          const Spacer(),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  right: 10,
                  top: 40,
                  child: FloatingActionButton(
                      backgroundColor: Colors.amber,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                      child: const Icon(
                        Icons.home_filled,
                        color: Colors.blue,
                        size: 50,
                      )),
                ),
              ],
            )),
      ),
    );
  }

  String result() {
    if (score == 40) {
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
