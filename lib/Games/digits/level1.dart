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
class digitsLevel1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<digitsLevel1> {
  final player = AudioPlayer();
  final controller = ConfettiController();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late int lvl;
  late int level1score;
  late int level2score;
  late int level3score;
  late int level4score;
  late double rate;
  static int MaxObtainableScore =
      240; //total number of items in all the levels multiped by 10
  late int TotalScore;
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
  }

  updateScore(String level, score) async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = ChildrenRef.doc(uid)
        .collection('children')
        .doc(currentChild)
        .collection('games')
        .doc('digits');
    await ref.update({level: score.toString()});
    await updateTotalScore(MaxObtainableScore);
  }

  updateTotalScore(score) async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = ChildrenRef.doc(uid)
        .collection('children')
        .doc(currentChild)
        .collection('games')
        .doc('digits');
    await ref.get().then((value) {
      String x = value.data()!['level1Score'].toString();
      level1score = int.parse(x);
      String y = value.data()!['level2Score'].toString();
      level2score = int.parse(y);
      String y1 = value.data()!['level3Score'].toString();
      level3score = int.parse(y1);
      String x1 = value.data()!['level4Score'].toString();
      level4score = int.parse(x1);
    });
    TotalScore = level1score + level2score + level3score + level4score;
    rate = (TotalScore / MaxObtainableScore) * 10;
    rate = double.parse(rate.toStringAsFixed(2));
    if (rate < 0) {
      rate = 0;
    }
    await ref.update({"Child rate out of 10": rate});
  }

  initGame1() {
    gameOver = false;
    score = 0;
    lvl = 1;
    items = [
      ItemModel(
          value: 'ألف',
          name: 'ألف',
          img: 'assets/images/games/digits/Alf.png',
          sound: 'sounds/learn/digits/Alf.wav'),
      ItemModel(
          value: 'باء',
          name: 'باء',
          img: 'assets/images/games/digits/B.png',
          sound: 'sounds/learn/digits/B.wav'),
      ItemModel(
          value: 'تاء',
          name: 'تاء',
          img: 'assets/images/games/digits/T.png',
          sound: 'sounds/learn/digits/T.wav'),
      ItemModel(
          value: 'ثاء',
          name: 'ثاء',
          img: 'assets/images/games/digits/tha2.png',
          sound: 'sounds/learn/digits/tha2.wav'),
      ItemModel(
          value: 'جيم',
          name: 'جيم',
          img: 'assets/images/games/digits/geem.png',
          sound: 'sounds/learn/digits/geem.wav'),
      ItemModel(
          value: 'حاء',
          name: 'حاء',
          img: 'assets/images/games/digits/7a2.png',
          sound: 'sounds/learn/digits/7a2.wav'),
      ItemModel(
          value: 'خاء',
          name: 'خاء',
          img: 'assets/images/games/digits/5a2.png',
          sound: 'sounds/learn/digits/5a2.wav'),
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
          value: 'دال',
          name: 'دال',
          img: 'assets/images/games/digits/dal.png',
          sound: 'sounds/learn/digits/dal.wav'),
      ItemModel(
          value: 'ذال',
          name: 'ذال',
          img: 'assets/images/games/digits/zal.png',
          sound: 'sounds/learn/digits/zal.wav'),
      ItemModel(
          value: 'راء',
          name: 'راء',
          img: 'assets/images/games/digits/raa2.png',
          sound: 'sounds/learn/digits/raa2.wav'),
      ItemModel(
          value: 'زال',
          name: 'زال',
          img: 'assets/images/games/digits/zeen.png',
          sound: 'sounds/learn/digits/zeen.wav'),
      ItemModel(
          value: 'سين',
          name: 'سين',
          img: 'assets/images/games/digits/seen.png',
          sound: 'sounds/learn/digits/seen.wav'),
      ItemModel(
          value: 'شين',
          name: 'شين',
          img: 'assets/images/games/digits/sheen.png',
          sound: 'sounds/learn/digits/sheen.wav'),
      ItemModel(
          value: 'صاد',
          name: 'صاد',
          img: 'assets/images/games/digits/saad.png',
          sound: 'sounds/learn/digits/saad.wav'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  initGame3() {
    gameOver = false;
    score = 0;
    lvl = 3;
    items = [
      ItemModel(
          value: 'ضاد',
          name: 'ضاد',
          img: 'assets/images/games/digits/daad.png',
          sound: 'sounds/learn/digits/daad.wav'),
      ItemModel(
          value: 'طاء',
          name: 'طاء',
          img: 'assets/images/games/digits/taah.png',
          sound: 'sounds/learn/digits/taah.wav'),
      ItemModel(
          value: 'ظاء',
          name: 'ظاء',
          img: 'assets/images/games/digits/zaah.png',
          sound: 'sounds/learn/digits/zaah.wav'),
      ItemModel(
          value: 'عين',
          name: 'عين',
          img: 'assets/images/games/digits/3ean.png',
          sound: 'sounds/learn/digits/3ean.wav'),
      ItemModel(
          value: 'غين',
          name: 'غين',
          img: 'assets/images/games/digits/8ean.png',
          sound: 'sounds/learn/digits/8ean.wav'),
      ItemModel(
          value: 'فاء',
          name: 'فاء',
          img: 'assets/images/games/digits/faa2.png',
          sound: 'sounds/learn/digits/faa2.wav'),
      ItemModel(
          value: 'قاف',
          name: 'قاف',
          img: 'assets/images/games/digits/qaaf.png',
          sound: 'sounds/learn/digits/qaaf.wav'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  initGame4() {
    gameOver = false;
    score = 0;
    lvl = 4;
    items = [
      ItemModel(
          value: 'كاف',
          name: 'كاف',
          img: 'assets/images/games/digits/kaaf.png',
          sound: 'sounds/learn/digits/kaaf.wav'),
      ItemModel(
          value: 'لام',
          name: 'لام',
          img: 'assets/images/games/digits/laam.png',
          sound: 'sounds/learn/digits/laam.wav'),
      ItemModel(
          value: 'ميم',
          name: 'ميم',
          img: 'assets/images/games/digits/meem.png',
          sound: 'sounds/learn/digits/meem.wav'),
      ItemModel(
          value: 'نون',
          name: 'نون',
          img: 'assets/images/games/digits/noon.png',
          sound: 'sounds/learn/digits/noon.wav'),
      ItemModel(
          value: 'هاء',
          name: 'هاء',
          img: 'assets/images/games/digits/heah.png',
          sound: 'sounds/learn/digits/heah.wav'),
      ItemModel(
          value: 'واو',
          name: 'واو',
          img: 'assets/images/games/digits/waw.png',
          sound: 'sounds/learn/digits/waw.wav'),
      ItemModel(
          value: 'ياء',
          name: 'ياء',
          img: 'assets/images/games/digits/yeah.png',
          sound: 'sounds/learn/digits/yeah.wav'),
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
    if (gameOver && score < 55) {
      if (lvl == 1) {
        updateScore("level1Score", score);
        initGame1();
      } else if (lvl == 2) {
        updateScore("level2Score", score);
        initGame2();
      } else if (lvl == 3) {
        updateScore("level3Score", score);
        initGame3();
      } else if (lvl == 4) {
        updateScore("level4Score", score);
        initGame4();
      }
    }
    if (gameOver && score >= 55) {
      if (lvl == 1) {
        updateScore("level1Score", score);
        initGame2();
      } else if (lvl == 2) {
        updateScore("level2Score", score);
        initGame3();
      } else if (lvl == 3) {
        updateScore("level3Score", score);
        initGame4();
      } else if (lvl == 4) {
        updateScore("level4Score", score);
        initGame4();
      }
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
          Positioned(
            right: 10,
            top: 40,
            child: FloatingActionButton(
                heroTag: "digitsHome",
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
                  heroTag: "digitsBack1",
                  onPressed: () {
                    setState(() {
                      initGame1();
                    });
                  },
                  child: const Icon(Icons.navigate_before_sharp)),
            ),
          if (lvl == 3)
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height * 0.5,
              child: FloatingActionButton(
                  heroTag: "difitsBack2",
                  onPressed: () {
                    setState(() {
                      initGame2();
                    });
                  },
                  child: const Icon(Icons.navigate_before_sharp)),
            ),
          if (lvl == 4)
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height * 0.5,
              child: FloatingActionButton(
                  heroTag: "difitsBack3",
                  onPressed: () {
                    setState(() {
                      initGame3();
                    });
                  },
                  child: const Icon(Icons.navigate_before_sharp)),
            ),
        ],
      )),
    );
  }

  String result() {
    if (score == 70) {
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
