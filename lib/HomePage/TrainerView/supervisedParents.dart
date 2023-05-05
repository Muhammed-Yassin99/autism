// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'package:autism_zz/HomePage/TrainerView/trainerListOfRequests.dart';
import 'package:autism_zz/HomePage/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages

class supervisedParents extends StatefulWidget {
  const supervisedParents({Key? key}) : super(key: key);

  @override
  FiChartPageState createState() => FiChartPageState();
}

class FiChartPageState extends State<supervisedParents> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  var userName;
  List parents = [];
  var userPic;
  var trainerUid = FirebaseAuth.instance.currentUser?.uid;
  List supervisedParents = [""];
  List<List> children = [];
  List<List> listofGames = [
    [""]
  ];
  List games = [];
  //String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference trainerRef =
      FirebaseFirestore.instance.collection("trainers");
  CollectionReference parentRef =
      FirebaseFirestore.instance.collection("parents");

  Future<List<List>> fetchData() async {
    List<List> children = [];
    if (kDebugMode) {
      print(supervisedParents.length);
      print(supervisedParents);
    }
    if (supervisedParents.isNotEmpty) {
      for (int i = 0; i <= supervisedParents.length - 1; i++) {
        List children1 = [];
        CollectionReference childRef = parentRef
            .doc(supervisedParents[i].toString())
            .collection("children");
        await childRef.get().then((value) {
          for (var element in value.docs) {
            children1.add(element.data());
          }
        });
        children.add(children1);
      }
    }
    return children;
  }

  setUserName() async {
    supervisedParents = [];
    parents = [];
    var user = FirebaseAuth.instance.currentUser;
    var response = await parentRef.get();
    String mail = user!.email.toString();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == mail) {
          setState(() {
            userName = element['username'].toString();
            userPic = element['profilePic'].toString();
            supervisedParents = element['supervisedParents'];
          });
          break;
        }
      }
      for (int i = 0; i <= supervisedParents.length - 1; i++) {
        for (var element in response.docs) {
          if (element['uid'].toString() == supervisedParents[i].toString()) {
            setState(() {
              parents.add(element.data());
            });
            break;
          }
        }
      }
    });

    if (kDebugMode) {
      print(supervisedParents);
    }
    if (kDebugMode) {
      print(parents);
    }
    if (userPic == "") {
      userPic =
          "https://firebasestorage.googleapis.com/v0/b/graduationproject-35c1f.appspot.com/o/images%2Fdoctor.png?alt=media&token=04531c72-1cf6-48f2-a20c-f305e8cd33a7";
    }
  }

  getChildren() async {
    children = [];
    await setUserName();
    if (kDebugMode) {
      print(supervisedParents.length);
      print(supervisedParents);
    }
    if (supervisedParents.isNotEmpty) {
      for (int i = 0; i <= supervisedParents.length - 1; i++) {
        List children1 = [];
        CollectionReference childRef = parentRef
            .doc(supervisedParents[i].toString())
            .collection("children");
        await childRef.get().then((value) {
          for (var element in value.docs) {
            setState(() {
              children1.add(element.data());
            });
          }
        });
        setState(() {
          children.add(children1);
        });
      }
    }
    if (kDebugMode) {
      print("childrenList:");
      print(children[0].length);
    }
  }

  getGames() async {
    games = [];
    listofGames = [];
    await getChildren();
    for (int i = 0; i <= supervisedParents.length - 1; i++) {
      games = [];
      for (int j = 0; j <= children[i].length - 1; j++) {
        CollectionReference childRef = parentRef
            .doc(supervisedParents[i].toString())
            .collection("children")
            .doc(children[i][j]['name'])
            .collection("games");
        await childRef.get().then((value) {
          List games1 = [];
          for (var element in value.docs) {
            setState(() {
              games1.add(element.data());
            });
          }
          setState(() {
            games.add(games1);
          });
        });
      }
      setState(() {
        listofGames.add(games);
      });
    }
    /*if (kDebugMode) {
      print("games:");
      print(games);
      print("ListOFgames:");
      print(listofGames[0].length);
    }*/
  }

  Widget chatButton(String parentUid, String parentName) {
    var trainerUid = FirebaseAuth.instance.currentUser!.uid;
    return Positioned(
      top: 40,
      left: 5,
      child: ClipOval(
        child: SizedBox(
          width: 70,
          height: 70,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    senderId: trainerUid,
                    receiverId: parentUid,
                    parentName: parentName,
                  ),
                ),
              );
            },
            child: const Center(
              child: Icon(
                Icons.chat,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    setUserName();
    getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName.toString()),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    userPic.toString(),
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      'assets/images/HomePage/sideBarBackground.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('الصفحة الرئيسية'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("trainerHomePage");
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('الشهادات'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('اولياء الأمور'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('الطلبات'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const trainerListOfRequests()));
              },
              trailing: ClipOval(
                child: Container(
                  color: Colors.red,
                  width: 20,
                  height: 20,
                  child: const Center(
                    child: Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الأعدادات'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('تسجيل الخروج'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("startPage");
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0.0,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'قائمة الأهالي',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.list,
                size: 55,
              ),
              onPressed: () async {
                setState(() {});
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 96, 139, 115),
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder<List<List>>(
                      future: fetchData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<List>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return ListView.builder(
                            //scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // ignore: prefer_const_literals_to_create_immutables
                            itemCount: supervisedParents.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Card(
                                //padding: const EdgeInsets.only(top: 8),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ExpansionTile(
                                    backgroundColor: Colors.black,
                                    title: SizedBox(
                                      height: 110,
                                      child: Stack(
                                        children: [
                                          chatButton(supervisedParents[i],
                                              parents[i]['username']),
                                          Positioned(
                                              top: 10,
                                              right: 85,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${parents[i]['username']}",
                                                      style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ])),
                                          Positioned(
                                            height: 90,
                                            right: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 4,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 33, 37, 243),
                                                    ),
                                                    shape: BoxShape.circle,
                                                    image:
                                                        const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/images/HomePage/parent.png'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Container(
                                        color: Colors.blueGrey,
                                        child: Stack(children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Stack(children: [
                                              ExpansionTile(
                                                  backgroundColor: Colors.amber,
                                                  title: const Text(
                                                      style: TextStyle(
                                                          fontSize: 28),
                                                      textAlign:
                                                          TextAlign.right,
                                                      "الأطفال"),
                                                  children: [
                                                    SizedBox(
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          shrinkWrap: true,
                                                          // ignore: prefer_const_literals_to_create_immutables
                                                          itemCount: children[i]
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int j) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8),
                                                              child:
                                                                  ExpansionTile(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                title: Text(
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            28),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    "${snapshot.data![i][j]['name']}"),
                                                                // ignore: prefer_const_literals_to_create_immutables
                                                                children: [
                                                                  const Divider(
                                                                      color: Colors
                                                                          .red),
                                                                  Card(
                                                                    color: Colors
                                                                        .grey,
                                                                    child:
                                                                        ListTile(
                                                                      title: Text(
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  26),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          "${"العمر"}: ${snapshot.data![i][j]['age']}"),
                                                                    ),
                                                                  ),
                                                                  Card(
                                                                    color: Colors
                                                                        .grey,
                                                                    child:
                                                                        ExpansionTile(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      title:
                                                                          const Text(
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                26),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        "التقييم الكلي",
                                                                      ),
                                                                      children: [
                                                                        const Divider(
                                                                            color:
                                                                                Colors.red),
                                                                        Card(
                                                                          color:
                                                                              Colors.grey,
                                                                          child:
                                                                              ListView.builder(
                                                                            //scrollDirection: Axis.vertical,
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                1,
                                                                            itemBuilder:
                                                                                (BuildContext context, int k) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.only(right: 22.0),
                                                                                child: Center(
                                                                                  child: SizedBox(
                                                                                    width: 400,
                                                                                    height: 400,
                                                                                    child: LineChart(LineChartData(
                                                                                        borderData: FlBorderData(show: true, border: Border.all(color: Colors.white, width: 2)),
                                                                                        gridData: FlGridData(
                                                                                          show: true,
                                                                                          getDrawingHorizontalLine: (value) {
                                                                                            return FlLine(color: Colors.white, strokeWidth: 1);
                                                                                          },
                                                                                          drawVerticalLine: true,
                                                                                          getDrawingVerticalLine: (value) {
                                                                                            return FlLine(color: Colors.white, strokeWidth: 1);
                                                                                          },
                                                                                        ),
                                                                                        titlesData: FlTitlesData(
                                                                                          show: true,
                                                                                          bottomTitles: SideTitles(
                                                                                              showTitles: true,
                                                                                              reservedSize: 35,
                                                                                              getTextStyles: (context, value) {
                                                                                                return const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
                                                                                              },
                                                                                              getTitles: (value) {
                                                                                                switch (value.toInt()) {
                                                                                                  case 0:
                                                                                                    return 'الحيوانات';
                                                                                                  case 2:
                                                                                                    return 'الحروف';
                                                                                                  case 4:
                                                                                                    return 'الأوجه';
                                                                                                  case 6:
                                                                                                    return 'العائلة';
                                                                                                  case 8:
                                                                                                    return 'الأرقام';
                                                                                                }
                                                                                                return '';
                                                                                              },
                                                                                              margin: 8),
                                                                                          rightTitles: SideTitles(),
                                                                                          topTitles: SideTitles(),
                                                                                          leftTitles: SideTitles(
                                                                                            showTitles: true,
                                                                                            reservedSize: 35,
                                                                                            getTextStyles: (context, value) {
                                                                                              return const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold);
                                                                                            },
                                                                                            getTitles: (value) {
                                                                                              switch (value.toInt()) {
                                                                                                case 0:
                                                                                                  return '0';
                                                                                                case 1:
                                                                                                  return '1';
                                                                                                case 2:
                                                                                                  return '2';
                                                                                                case 3:
                                                                                                  return '3';
                                                                                                case 4:
                                                                                                  return '4';
                                                                                                case 5:
                                                                                                  return '5';
                                                                                                case 6:
                                                                                                  return '6';
                                                                                                case 7:
                                                                                                  return '7';
                                                                                                case 8:
                                                                                                  return '8';
                                                                                                case 9:
                                                                                                  return '9';
                                                                                                case 10:
                                                                                                  return '10';
                                                                                              }
                                                                                              return '';
                                                                                            },
                                                                                            margin: 12,
                                                                                          ),
                                                                                        ),
                                                                                        maxX: 10,
                                                                                        maxY: 11,
                                                                                        minY: 0,
                                                                                        minX: 0,
                                                                                        lineBarsData: [
                                                                                          LineChartBarData(
                                                                                              spots: [
                                                                                                FlSpot(0, double.parse(listofGames[i][j][0]['Child rate out of 10'].toString())),
                                                                                                FlSpot(2, double.parse(listofGames[i][j][1]['Child rate out of 10'].toString())),
                                                                                                FlSpot(4, double.parse(listofGames[i][j][2]['Child rate out of 10'].toString())),
                                                                                                FlSpot(6, double.parse(listofGames[i][j][3]['Child rate out of 10'].toString())),
                                                                                                FlSpot(8, double.parse(listofGames[i][j][4]['Child rate out of 10'].toString())),
                                                                                              ],
                                                                                              isCurved: true,
                                                                                              colors: [
                                                                                                Colors.white,
                                                                                                Colors.white,
                                                                                                Colors.white,
                                                                                              ],
                                                                                              barWidth: 5,
                                                                                              belowBarData: BarAreaData(show: true, colors: gradientColors.map((e) => e.withOpacity(0.7)).toList()))
                                                                                        ])),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Card(
                                                                    color: Colors
                                                                        .grey,
                                                                    child:
                                                                        ExpansionTile(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      title:
                                                                          const Text(
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                26),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        "مزيد من التفاصيل",
                                                                      ),
                                                                      children: [
                                                                        const Divider(
                                                                            color:
                                                                                Colors.red),
                                                                        Card(
                                                                          color:
                                                                              Colors.grey,
                                                                          child:
                                                                              ListView.builder(
                                                                            //scrollDirection: Axis.vertical,
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                5,
                                                                            itemBuilder:
                                                                                (BuildContext context, int k) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.only(top: 4),
                                                                                child: ExpansionTile(
                                                                                  backgroundColor: Colors.black,
                                                                                  title: Text(style: const TextStyle(fontSize: 26), textAlign: TextAlign.right, "${listofGames[i][j][k]['name']}"),
                                                                                  children: [
                                                                                    const Divider(color: Colors.red),
                                                                                    Card(
                                                                                      color: Colors.grey,
                                                                                      child: ListTile(
                                                                                        title: Text(style: const TextStyle(fontSize: 24), textAlign: TextAlign.right, "${"المستوي الأول"}: ${listofGames[i][j][k]['level1Score']}"),
                                                                                      ),
                                                                                    ),
                                                                                    Card(
                                                                                      color: Colors.grey,
                                                                                      child: ListTile(
                                                                                        title: Text(style: const TextStyle(fontSize: 24), textAlign: TextAlign.right, "${"المستوي الثاني"}: ${listofGames[i][j][k]['level2Score']}"),
                                                                                      ),
                                                                                    ),
                                                                                    Card(
                                                                                      color: Colors.grey,
                                                                                      child: ListTile(
                                                                                        title: Text(style: const TextStyle(fontSize: 24), textAlign: TextAlign.right, "${"المستوي الثالث"}: ${listofGames[i][j][k]['level3Score']}"),
                                                                                      ),
                                                                                    ),
                                                                                    Card(
                                                                                      color: Colors.grey,
                                                                                      child: ListTile(
                                                                                        title: Text(style: const TextStyle(fontSize: 24), textAlign: TextAlign.right, "${"المستوي الرابع"}: ${listofGames[i][j][k]['level4Score']}"),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  ]),
                                            ]),
                                          ),
                                        ]),
                                      ),
                                      const Divider(color: Colors.red),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
