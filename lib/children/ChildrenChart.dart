// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:fl_chart/fl_chart.dart'
    show
        BarAreaData,
        FlBorderData,
        FlGridData,
        FlLine,
        FlSpot,
        FlTitlesData,
        LineChart,
        LineChartBarData,
        LineChartData,
        SideTitles;

class ChildrenChart extends StatefulWidget {
  const ChildrenChart({Key? key}) : super(key: key);

  @override
  FiChartPageState createState() => FiChartPageState();
}

class FiChartPageState extends State<ChildrenChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  var userName;
  List children = [];
  List listofGames = [];
  List games = [];
  //String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference ChildrenRef =
      FirebaseFirestore.instance.collection("parents");

  getChildren() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference childRef = ChildrenRef.doc(uid).collection("children");
    var response = await childRef.get();
    for (var element in response.docs) {
      setState(() {
        children.add(element.data());
      });
    }
    if (kDebugMode) {
      print(children);
    }
  }

  getGames() async {
    await getChildren();
    for (int i = 0; i <= children.length - 1; i++) {
      var uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference childRef = ChildrenRef.doc(uid)
          .collection("children")
          .doc(children[i]['name'])
          .collection("games");
      await childRef.get().then((value) {
        //print(i);
        games = [];
        /*print("games");
        print(games);
        print("listofgames");
        print(listofGames);*/
        for (var element in value.docs) {
          games.add(element.data());
        }
        listofGames.add(games);
      });
    }
  }

  setUserName() async {
    var user = FirebaseAuth.instance.currentUser;
    String mail = user!.email.toString();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == mail) {
          setState(() {
            userName = element['username'].toString();
          });
          break;
        }
      }
    });
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
                    child: Image.asset(
                      'assets/images/HomePage/parent.png',
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
                leading: const Icon(Icons.share),
                title: const Text(
                    style: TextStyle(fontSize: 18), 'الصفحة الرئيسية'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("parentHomePage");
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(style: TextStyle(fontSize: 18), 'الأطفال'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChildrenChart()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text(
                    style: TextStyle(fontSize: 18), 'قائمة المدربين'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text(style: TextStyle(fontSize: 18), 'الطلبات'),
                onTap: () {},
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
                title: const Text(style: TextStyle(fontSize: 18), 'الأعدادات'),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                title:
                    const Text(style: TextStyle(fontSize: 18), 'تسجيل الخروج'),
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
              'قائمة الأطفال',
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
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      itemCount: children.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ExpansionTile(
                            backgroundColor: Colors.black,
                            title: Text(
                                style: const TextStyle(fontSize: 28),
                                textAlign: TextAlign.right,
                                "${children[i]['name']}"),
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Divider(color: Colors.red),
                              Card(
                                color: Colors.grey,
                                child: ListTile(
                                  title: Text(
                                      style: const TextStyle(fontSize: 26),
                                      textAlign: TextAlign.right,
                                      "${"العمر"}: ${children[i]['age']}"),
                                ),
                              ),
                              Card(
                                color: Colors.grey,
                                child: ExpansionTile(
                                  backgroundColor: Colors.black,
                                  title: const Text(
                                    style: TextStyle(fontSize: 26),
                                    textAlign: TextAlign.right,
                                    "التقييم الكلي",
                                  ),
                                  children: [
                                    const Divider(color: Colors.red),
                                    Card(
                                      color: Colors.grey,
                                      child: ListView.builder(
                                        //scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int j) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 22.0),
                                            child: Center(
                                              child: SizedBox(
                                                width: 400,
                                                height: 400,
                                                child: LineChart(LineChartData(
                                                    borderData: FlBorderData(
                                                        show: true,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2)),
                                                    gridData: FlGridData(
                                                      show: true,
                                                      getDrawingHorizontalLine:
                                                          (value) {
                                                        return FlLine(
                                                            color: Colors.white,
                                                            strokeWidth: 1);
                                                      },
                                                      drawVerticalLine: true,
                                                      getDrawingVerticalLine:
                                                          (value) {
                                                        return FlLine(
                                                            color: Colors.white,
                                                            strokeWidth: 1);
                                                      },
                                                    ),
                                                    titlesData: FlTitlesData(
                                                      show: true,
                                                      bottomTitles: SideTitles(
                                                          showTitles: true,
                                                          reservedSize: 35,
                                                          getTextStyles:
                                                              (context, value) {
                                                            return const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold);
                                                          },
                                                          getTitles: (value) {
                                                            switch (
                                                                value.toInt()) {
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
                                                        getTextStyles:
                                                            (context, value) {
                                                          return const TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold);
                                                        },
                                                        getTitles: (value) {
                                                          switch (
                                                              value.toInt()) {
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
                                                            FlSpot(
                                                                0,
                                                                double.parse(listofGames[
                                                                            i][0]
                                                                        [
                                                                        'Child rate out of 10']
                                                                    .toString())),
                                                            FlSpot(
                                                                2,
                                                                double.parse(listofGames[
                                                                            i][1]
                                                                        [
                                                                        'Child rate out of 10']
                                                                    .toString())),
                                                            FlSpot(
                                                                4,
                                                                double.parse(listofGames[
                                                                            i][2]
                                                                        [
                                                                        'Child rate out of 10']
                                                                    .toString())),
                                                            FlSpot(
                                                                6,
                                                                double.parse(listofGames[
                                                                            i][3]
                                                                        [
                                                                        'Child rate out of 10']
                                                                    .toString())),
                                                            FlSpot(
                                                                8,
                                                                double.parse(listofGames[
                                                                            i][4]
                                                                        [
                                                                        'Child rate out of 10']
                                                                    .toString())),
                                                          ],
                                                          isCurved: true,
                                                          colors: [
                                                            Colors.white,
                                                            Colors.white,
                                                            Colors.white,
                                                          ],
                                                          barWidth: 5,
                                                          belowBarData: BarAreaData(
                                                              show: true,
                                                              colors: gradientColors
                                                                  .map((e) => e
                                                                      .withOpacity(
                                                                          0.7))
                                                                  .toList()))
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
        ));
  }
}
