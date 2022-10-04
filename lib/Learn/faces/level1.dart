import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  // static const String path = "lib/src/pages/quiz_app/home.dart";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0.0,
          title: const Align(
            alignment: Alignment.center,
            child: Text(
              'هيا لنتعلم الاوجه',
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
            const SizedBox(width: 12),
          ],
        ),
        body: (Column(
          children: [
            Container(
              height: 70,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  // ignore: prefer_const_constructors
                  image: DecorationImage(
                    Image.asset(category.icon, height: 90, width: 200),
                  )),
              child: TextButton(
                  onPressed: () {},
                  // ignore: prefer_const_constructors
                  child: Text(
                    'وجه سعيد ',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 4, 46, 81),
                    ),
                  )),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        )));
  }
}
