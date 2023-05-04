// ignore_for_file: camel_case_types, file_names, must_be_immutable, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, library_private_types_in_public_api, unused_import, use_build_context_synchronously
import 'package:autism_zz/HomePage/ParentView/trainersList.dart';
import 'package:autism_zz/ObjectDetection/method2/live_camera.dart';
import 'package:autism_zz/ObjectDetection/method2/static.dart';
import 'package:autism_zz/HomePage/ParentView/ChildrenList.dart';
import 'package:autism_zz/main.dart';
import 'package:autism_zz/skills/skill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'method2/static2.dart';

class objecDetecHomepage extends StatefulWidget {
  const objecDetecHomepage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<objecDetecHomepage> {
  int seletedItem = 0;
  var userName;
  var pages = [StaticImage(), LiveFeed(cameras!)];
  var pageController = PageController();
  setUserName() async {
    var user = FirebaseAuth.instance.currentUser;
    String mail = user!.email.toString();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("parents");
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setUserName();
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
              title:
                  const Text(style: TextStyle(fontSize: 18), 'الصفحة الرئيسية'),
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
                        builder: (context) => const ChildrenList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'قائمة المدربين'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const trainersList()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(style: TextStyle(fontSize: 18), 'الأعدادات'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text(style: TextStyle(fontSize: 18), 'تسجيل الخروج'),
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
            '!تعرف علي الاشياء',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          const SizedBox(width: 18),
        ],
      ),
      body: Container(
          color: Colors.amber,
          child: Stack(
            children: [
              PageView(
                children: pages,
                onPageChanged: (index) {
                  setState(() {
                    seletedItem = index;
                  });
                },
                controller: pageController,
              ),
              BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  // ignore: prefer_const_constructors
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.picture_in_picture,
                        size: 50,
                      ),
                      label: 'صورة'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.video_call,
                        size: 50,
                      ),
                      label: 'فديو'),
                ],
                currentIndex: seletedItem,
                onTap: (index) {
                  setState(() {
                    seletedItem = index;
                    pageController.animateToPage(seletedItem,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear);
                  });
                },
              ),
            ],
          )),
    );
  }
}
