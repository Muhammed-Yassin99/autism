// ignore_for_file: file_names, unused_element, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors, camel_case_types
import 'package:audioplayers/audioplayers.dart';
import '../../../model/item_model.dart';
import '../../gamesHomePage1.dart';
import 'package:flutter/material.dart';

class level2 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<level2> {
  final player = AudioPlayer();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late bool gameOver;

  initGame1() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(
          value: 'دهشة',
          name: 'دهشة',
          img: 'assets/images/games/faces/surprised.png',
          sound: 'sounds/learn/faces/surprised.wav'),
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                    const Spacer(flex: 2),
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
                              item.accepting = true;
                            });
                          },
                          builder: (context, acceptedItems, rejectedItems) =>
                              Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: item.accepting
                                  ? Colors.grey[400]
                                  : Colors.grey[200],
                            ),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width / 6.5,
                            width: MediaQuery.of(context).size.width / 3,
                            margin: const EdgeInsets.all(8),
                            child: TextButton(
                                onPressed: () {
                                  playBeep(item.sound);
                                },
                                // ignore: prefer_const_constructors
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.name,
                                      style:
                                          Theme.of(context).textTheme.headline6,
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
              if (gameOver)
                Center(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text('انتهت اللعبة',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          result(),
                        ),
                      ),
                    ],
                  ),
                ),
              if (gameOver)
                Container(
                  height: 70,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          initGame1();
                        });
                      },
                      // ignore: prefer_const_constructors
                      child: Text(
                        'اللعب مجددا',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 26),
                      )),
                ),
              const SizedBox(
                height: 20,
              ),
              if (gameOver)
                Container(
                  height: 70,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // ignore: prefer_const_constructors
                      child: Text(
                        'الرجوع الي المستوي السابق',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 26),
                      )),
                ),
              const SizedBox(
                height: 20,
              ),
              if (gameOver)
                Container(
                  height: 70,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const gamesHomePage()),
                        );
                      },
                      // ignore: prefer_const_constructors
                      child: Text(
                        'الرجوع الي صفحة الالعاب',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 26),
                      )),
                ),
            ],
          ),
        ),
      ),
    );
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
