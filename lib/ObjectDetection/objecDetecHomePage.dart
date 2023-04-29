// ignore_for_file: camel_case_types, file_names, must_be_immutable, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, library_private_types_in_public_api, unused_import
import 'package:autism_zz/ObjectDetection/method2/live_camera.dart';
import 'package:autism_zz/ObjectDetection/method2/static.dart';
import 'package:autism_zz/main.dart';
import 'package:autism_zz/skills/skill.dart';
import 'package:flutter/material.dart';

import 'method2/static2.dart';

class objecDetecHomepage extends StatefulWidget {
  const objecDetecHomepage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<objecDetecHomepage> {
  int seletedItem = 0;
  var pages = [StaticImage(), LiveFeed(cameras!)];
  var pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
