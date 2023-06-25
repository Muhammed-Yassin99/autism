// ignore_for_file: camel_case_types, file_names, must_be_immutable, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, library_private_types_in_public_api, unused_import, use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'package:Autism_Helper/HomePage/ParentView/parentChat.dart';
import 'package:Autism_Helper/HomePage/ParentView/questions.dart';
import 'package:Autism_Helper/HomePage/ParentView/trainersList.dart';
import 'package:Autism_Helper/ObjectDetection/method2/live_camera.dart';
import 'package:Autism_Helper/ObjectDetection/method2/static.dart';
import 'package:Autism_Helper/HomePage/ParentView/ChildrenList.dart';
import 'package:Autism_Helper/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'method2/static2.dart';

class objecDetecHomepage extends StatefulWidget {
  const objecDetecHomepage({super.key});

  @override
  HomeScreenState1 createState() => HomeScreenState1();
}

class HomeScreenState1 extends State<objecDetecHomepage> {
  int seletedItem = 0;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var trainerName;
  var userName;
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  var assignedTrainer = "";
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
            assignedTrainer = element['assignedTrainer'].toString();
          });
          break;
        }
      }
    });
  }

  getTrainerName() async {
    await setUserName();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['uid'].toString() == assignedTrainer) {
          setState(() {
            trainerName = element['username'].toString();
          });
          break;
        }
      }
    });
  }

  @override
  void initState() {
    getTrainerName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userName.toString(),
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                mail,
                style: TextStyle(fontSize: 18),
              ),
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
              leading: const Icon(
                Icons.home,
                color: Colors.blue,
              ),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'الصفحة الرئيسية'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("parentHomePage");
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.child_care,
                color: Colors.blue,
              ),
              title: const Text(style: TextStyle(fontSize: 18), 'الأطفال'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChildrenList()));
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'قائمة المدربين'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const trainersList()));
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.chat,
                color: Colors.blue,
              ),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'المدرب الحالي'),
              onTap: () {
                if (assignedTrainer == "") {
                  AwesomeDialog(
                    context: context,
                    body: const Text(
                      "!لم تقم بالانضمام الي طبيب معالج",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    dialogType: DialogType.info,
                    animType: AnimType.leftSlide,
                  ).show();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => parentChatScreen(
                        senderId: assignedTrainer,
                        receiverId: uid.toString(),
                        trainerName: trainerName,
                      ),
                    ),
                  );
                }
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.question_mark,
                color: Colors.blue,
              ),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'الأسئلة الشائعة'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FaqsPage()));
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              title: const Text(style: TextStyle(fontSize: 18), 'تسجيل الخروج'),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  FirebaseAuth.instance.signOut();
                });
                Navigator.of(context).pushReplacementNamed("startPage");
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
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
