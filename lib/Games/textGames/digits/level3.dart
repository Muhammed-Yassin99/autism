// ignore_for_file: file_names, unused_element, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors, camel_case_types
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../model/item_model.dart';
import '../../gamesHomePage1.dart';
import 'level4.dart';

class level3 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<level3> {
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
        child: Container(
          color: Colors.teal,
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
                              radius: 30,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.img),
                              radius: 30,
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
              if (gameOver && score >= 55)
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
                          MaterialPageRoute(builder: (context) => level4()),
                        );
                      },
                      // ignore: prefer_const_constructors
                      child: Text(
                        'الانتقال الي المستوي الرابع',
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
                        'الرجوع الي المستوي الثاني',
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
