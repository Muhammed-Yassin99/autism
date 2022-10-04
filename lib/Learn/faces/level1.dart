import 'package:flutter/material.dart';

// ignore: camel_case_types
class learnfaces extends StatelessWidget {
  // static const String path = "lib/src/pages/quiz_app/home.dart";

  const learnfaces({super.key});

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
      body: Center(
          child: Material(
              color: Colors.blue,
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {},
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Ink.image(
                    image:
                        const AssetImage("assets/images/HomePage/Efaces.png"),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'وجه سعيد',
                    style: TextStyle(fontSize: 32, color: Colors.amber),
                  ),
                  const SizedBox(
                    height: 6,
                  )
                ]),
              ))),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // ignore: todo
    // TODO: implement createState
    throw UnimplementedError();
  }
}
