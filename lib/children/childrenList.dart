// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/drawer.dart';

class childrenList extends StatefulWidget {
  const childrenList({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<childrenList> {
  List children = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
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

  @override
  void initState() {
    getChildren();
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

      body: ListView.builder(
        // ignore: prefer_const_literals_to_create_immutables
        itemCount: children.length,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ExpansionTile(
              backgroundColor: Colors.black,
              title: Text("${children[i]['name']}"),
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Divider(color: Colors.red),
                Card(
                  color: Colors.grey,
                  child: ListTile(
                    title: Text("${children[i]['age']}"),
                  ),
                ),
                const Card(
                  color: Colors.grey,
                  child: ListTile(
                    title: Text("ummm"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
