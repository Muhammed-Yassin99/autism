// ignore_for_file: file_names, unused_element, must_be_immutable, library_private_types_in_public_api, camel_case_types, non_constant_identifier_names
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../model/item_model.dart';
import '../../HomePage/ParentView/parentHomePage.dart';

// ignore: use_key_in_widget_constructors
class numbersLevel1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<numbersLevel1> {
  final player = AudioPlayer();
  final controller = ConfettiController();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late int lvl;
  late bool gameOver;
  late int level1score;
  late int level2score;
  late double rate;
  static int MaxObtainableScore =
      100; //total number of items in all the levels multiped by 10
  late int TotalScore;
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
        .doc('numbers');
    await ref.update({level: score.toString()});
    await updateTotalScore(MaxObtainableScore);
  }

  updateTotalScore(score) async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = ChildrenRef.doc(uid)
        .collection('children')
        .doc(currentChild)
        .collection('games')
        .doc('numbers');
    await ref.get().then((value) {
      String x = value.data()!['level1Score'].toString();
      level1score = int.parse(x);
      String y = value.data()!['level2Score'].toString();
      level2score = int.parse(y);
    });
    TotalScore = level1score + level2score;
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
          value: 'واحد',
          name: 'واحد',
          img: 'assets/images/games/numbers/1.png',
          sound: 'sounds/learn/numbers/no1.wav'),
      ItemModel(
          value: 'اثنان',
          name: 'اثنان',
          img: 'assets/images/games/numbers/2.png',
          sound: 'sounds/learn/numbers/no2.wav'),
      ItemModel(
          value: 'ثلاثة',
          name: 'ثلاثة',
          img: 'assets/images/games/numbers/3.png',
          sound: 'sounds/learn/numbers/no3.wav'),
      ItemModel(
          value: 'اربعة',
          name: 'اربعة',
          img: 'assets/images/games/numbers/4.png',
          sound: 'sounds/learn/numbers/no4.wav'),
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
          value: 'اربعة',
          name: 'اربعة',
          img: 'assets/images/games/numbers/4.png',
          sound: 'sounds/learn/numbers/no4.wav'),
      ItemModel(
          value: 'خمسة',
          name: 'خمسة',
          img: 'assets/images/games/numbers/5.png',
          sound: 'sounds/learn/numbers/no5.wav'),
      ItemModel(
          value: 'ستة',
          name: 'ستة',
          img: 'assets/images/games/numbers/6.png',
          sound: 'sounds/learn/numbers/no6.wav'),
      ItemModel(
          value: 'سبعة',
          name: 'سبعة',
          img: 'assets/images/games/numbers/7.png',
          sound: 'sounds/learn/numbers/no7.wav'),
      ItemModel(
          value: 'ثمانية',
          name: 'ثمانية',
          img: 'assets/images/games/numbers/8.png',
          sound: 'sounds/learn/numbers/no8.wav'),
      ItemModel(
          value: 'تسعة',
          name: 'تسعة',
          img: 'assets/images/games/numbers/9.png',
          sound: 'sounds/learn/numbers/no9.wav'),
      ItemModel(
          value: 'عشرة',
          name: 'عشرة',
          img: 'assets/images/games/numbers/10.png',
          sound: 'sounds/learn/numbers/no10.wav'),
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
      if (score < 30) {
        updateScore("level1Score", score);
        initGame1();
      } else {
        updateScore("level1Score", score);
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
              physics: const BouncingScrollPhysics(),
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
                                    .displayMedium
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
                                      /*controller.play();
                                      Timer(const Duration(seconds: 1),
                                          (() => controller.stop()));*/
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
                                                  .titleLarge,
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
                heroTag: "numbersHome",
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
                  heroTag: "numbersBack",
                  onPressed: () {
                    setState(() {
                      initGame1();
                    });
                  },
                  child: const Icon(Icons.navigate_before_sharp)),
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
