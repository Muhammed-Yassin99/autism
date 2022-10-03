// ignore_for_file: file_names, unused_element, must_be_immutable, library_private_types_in_public_api, camel_case_types
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../model/item_model.dart';

// ignore: use_key_in_widget_constructors
class familyLevel1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<familyLevel1> {
  final player = AudioPlayer();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late bool gameOver;

  initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(
          value: 'اخ',
          name: 'اخ',
          img: 'assets/images/games/family/brothers.png'),
      ItemModel(
          value: 'اخت',
          name: 'اخت',
          img: 'assets/images/games/family/sister.png'),
      ItemModel(
          value: 'ام',
          name: 'ام',
          img: 'assets/images/games/family/mother.jpg'),
      ItemModel(
          value: 'اب',
          name: 'اب',
          img: 'assets/images/games/family/father.jpg'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) gameOver = true;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Score: ',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: '$score',
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.copyWith(color: Colors.teal),
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
                              item.accepting = false;
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
                                  height:
                                      MediaQuery.of(context).size.width / 6.5,
                                  width: MediaQuery.of(context).size.width / 3,
                                  margin: const EdgeInsets.all(8),
                                  child: Text(
                                    item.name,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )),
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
                            fontSize: 24,
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
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          initGame();
                        });
                      },
                      // ignore: prefer_const_constructors
                      child: Text(
                        'اللعب مجددا',
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
              const SizedBox(
                height: 20,
              ),
              if (gameOver)
                Container(
                  height: 70,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // ignore: prefer_const_constructors
                      child: Text(
                        'الرجوع الي صفحة الالعاب',
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
            ],
          ),
        ),
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
