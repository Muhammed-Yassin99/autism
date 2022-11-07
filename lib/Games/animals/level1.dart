// ignore_for_file: file_names, unused_element, must_be_immutable, library_private_types_in_public_api, camel_case_types, non_constant_identifier_names
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../model/item_model.dart';
import '../../HomePage/parentHomePage.dart';

// ignore: use_key_in_widget_constructors
class animalsLevel1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<animalsLevel1> {
  final player = AudioPlayer();
  final controller = ConfettiController();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late int lvl;
  late bool gameOver;
  String currentChild = "";
  CollectionReference ChildrenRef =
      FirebaseFirestore.instance.collection('parents');

  getcurrentChild() async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = ChildrenRef.doc(uid);
    await ref.get().then((value) {
      currentChild = value['currentChild'].toString();
    });
    if (kDebugMode) {
      print(currentChild);
    }
  }

  updateScore(String level, score) async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = ChildrenRef.doc(uid)
        .collection('children')
        .doc(currentChild)
        .collection('games')
        .doc('animals');
    await ref.update({level: score.toString()});
  }

  initGame1() {
    gameOver = false;
    score = 0;
    lvl = 1;
    items = [
      ItemModel(
          value: 'اسد',
          name: 'اسد',
          img: 'assets/images/games/animals/lion.png',
          sound: 'sounds/learn/animals/lion.wav'),
      ItemModel(
          value: 'قطة',
          name: 'قطة',
          img: 'assets/images/games/animals/cat.png',
          sound: 'sounds/learn/animals/cat.wav'),
      ItemModel(
        value: 'بقرة',
        name: 'بقرة',
        img: 'assets/images/games/animals/cow.png',
        sound: 'sounds/learn/animals/cow.wav',
      ),
      ItemModel(
          value: 'كلب',
          name: 'كلب',
          img: 'assets/images/games/animals/dog.png',
          sound: 'sounds/learn/animals/dog.wav'),
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
          value: 'ثعلب',
          name: 'ثعلب',
          img: 'assets/images/games/animals/fox.png',
          sound: 'sounds/learn/animals/fox.wav'),
      ItemModel(
          value: 'حصان',
          name: 'حصان',
          img: 'assets/images/games/animals/horse.png',
          sound: 'sounds/learn/animals/horse.wav'),
      ItemModel(
          value: 'باندا',
          name: 'باندا',
          img: 'assets/images/games/animals/panda.png',
          sound: 'sounds/learn/animals/panda.wav'),
      ItemModel(
          value: 'خاروف',
          name: 'خاروف',
          img: 'assets/images/games/animals/sheep.png',
          sound: 'sounds/learn/animals/sheep.wav'),
      ItemModel(
          value: 'دجاجة',
          name: 'دجاجة',
          img: 'assets/images/games/animals/hen.png',
          sound: 'sounds/learn/animals/hen.wav'),
      ItemModel(
          value: 'جمل',
          name: 'جمل',
          img: 'assets/images/games/animals/camel.png',
          sound: 'sounds/learn/animals/camel.wav'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    getcurrentChild();
    super.initState();
    initGame1();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) gameOver = true;
    if (gameOver && lvl == 1) {
      updateScore("level1Score", score);
      if (score < 30) {
        initGame1();
      } else {
        initGame2();
      }
    }
    if (gameOver && lvl == 2) {
      updateScore("level2Score", score);
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
                                      radius: 30,
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
          if (lvl == 2)
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 2,
              child: FloatingActionButton(
                  heroTag: "animalsBack",
                  onPressed: () {
                    setState(() {
                      initGame1();
                    });
                  },
                  child: const Icon(Icons.navigate_before_sharp)),
            ),
          Positioned(
            right: 10,
            top: 40,
            child: FloatingActionButton(
                heroTag: "animalsHome",
                backgroundColor: Colors.amber,
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed("parentHomePage");
                  });
                },
                child: const Icon(
                  Icons.home_filled,
                  color: Colors.blue,
                  size: 50,
                )),
          ),
        ],
      )),
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
