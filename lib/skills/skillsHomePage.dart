// ignore_for_file: camel_case_types, file_names, must_be_immutable, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore
import 'package:flutter/material.dart';
import 'PhysCard.dart';
import 'skill.dart';

class skillsHomePage extends StatelessWidget {
  skillsHomePage({super.key});
  int seletedItem = 0;
  var pages = [const PhysCard(), const skills()];
  var pageController = PageController();

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
            'المهارات',
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
      body: PageView(
        children: pages,
        onPageChanged: (index) {
          setState(() {
            seletedItem = index;
          });
        },
        controller: pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(icon: Icon(Icons.home), icon: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo), label: const Text('Photos')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('Profile'))
        ],
        currentIndex: seletedItem,
        onTap: (index) {
          setState(() {
            seletedItem = index;
            pageController.animateToPage(seletedItem,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
      ),
    );
  }
}
