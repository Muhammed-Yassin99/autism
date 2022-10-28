// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/drawer.dart';
import 'basicTiles.dart';

class childrenList extends StatefulWidget {
  const childrenList({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<childrenList> {
  static var userName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      drawer: const drawer(),
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

      body: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: ExpansionTile(
                backgroundColor: Colors.black,
                title: Text("Account"),
                children: [
                  Divider(color: Colors.red),
                  Card(
                    color: Colors.grey,
                    child: ListTile(
                      title: Text("fkup"),
                      subtitle: Text("fkup again"),
                    ),
                  ),
                  Card(
                    color: Colors.grey,
                    child: ListTile(
                      title: Text("ummm"),
                      subtitle: Text("shut up"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: ExpansionTile(
                backgroundColor: Colors.black,
                title: Text("More trash"),
                children: [
                  Divider(
                    color: Colors.red,
                  ),
                  Card(
                    color: Colors.grey,
                    child: ListTile(
                      title: Text("fkup"),
                      subtitle: Text("fkup again"),
                    ),
                  ),
                  Card(
                    color: Colors.grey,
                    child: ListTile(
                      title: Text("ummm"),
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}
