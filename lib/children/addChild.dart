// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, duplicate_ignore

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/colors_utils.dart';

class addChild extends StatefulWidget {
  const addChild({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<addChild> {
  // ignore: prefer_typing_uninitialized_variables
  var userEmail, userPass;
  static var childName;
  static var childAge;

  getChildName() async {
    return childName;
  }

  getChildAge() async {
    return childAge;
  }

  addChild() async {
    var formdate = formstate.currentState;
    if (formdate!.validate()) {
      formdate.save();
      CollectionReference userRef =
          FirebaseFirestore.instance.collection("users");
      await userRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .set({
        "name": childName,
        "age": childAge,
        //"games": gamesList,
      });
      await userRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("faces")
          .set({
        "name": "الاوجه التعبيرية",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });
      await userRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("animals")
          .set({
        "name": "الحيوانات",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });
      await userRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("digits")
          .set({
        "name": "الحروف",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": 0,
        "level4Score": 0,
        "Child rate out of 10": 0,
      });
      await userRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("numbers")
          .set({
        "name": "الأرقام",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });
      await userRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("family")
          .set({
        "name": "العائلة",
        "level1Score": 0,
        "level2Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });

      CollectionReference userRef2 =
          FirebaseFirestore.instance.collection("parents");
      await userRef2
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .set({
        "name": childName,
        "age": childAge,
      });
      await userRef2
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("faces")
          .set({
        "name": "الاوجه التعبيرية",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });
      await userRef2
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("animals")
          .set({
        "name": "الحيوانات",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });
      await userRef2
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("digits")
          .set({
        "name": "الحروف",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": 0,
        "level4Score": 0,
        "Child rate out of 10": 0,
      });
      await userRef2
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("numbers")
          .set({
        "name": "الأرقام",
        "level1Score": 0,
        "level2Score": 0,
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });
      await userRef2
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("children")
          .doc(childName)
          .collection("games")
          .doc("family")
          .set({
        "name": "العائلة",
        "level1Score": 0,
        "level2Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level3Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "level4Score": "سوف يتم إضافة مستوي جديد في المستقبل",
        "Child rate out of 10": 0,
      });
    }
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Form(
                key: formstate,
                child: Column(
                  children: [
                    // if (errorMSG != "") alert(),
                    Image.asset(
                      "assets/images/HomePage/signInLogo.png",
                      fit: BoxFit.fitWidth,
                      width: 240,
                      height: 240,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      onSaved: (newValue) {
                        childName = newValue;
                      },
                      validator: (value) {
                        if (value!.length > 50) {
                          return " اسم الطفل لا يمكن ان يتجاوز ال 50 حرف";
                        }
                        if (value.length < 2) {
                          return " اسم الطفل لا يمكن ان يقل عن الحرفين";
                        }
                        return null;
                      },
                      obscureText: false,
                      enableSuggestions: false,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white70,
                        ),
                        labelText: "اسم الطفل ثنائي",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onSaved: (newValue) {
                        childAge = newValue;
                      },
                      validator: (value) {
                        if (int.parse(value!) > 6) {
                          return " عمر الطفل لا يمكن ان يتجاوز ال 6 سنين";
                        }
                        if (int.parse(value) < 2) {
                          return "عمر الطفل لا يمكن ان يقل عن السنتين";
                        }
                        return null;
                      },
                      obscureText: false,
                      enableSuggestions: false,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white70,
                        ),
                        labelText: "عمر الطفل ",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90)),
                      child: ElevatedButton(
                        onPressed: () async {
                          await addChild();
                          if (kDebugMode) {
                            print(childName);
                          }
                          if (kDebugMode) {
                            print("child added");
                          }
                          Navigator.of(context)
                              .pushReplacementNamed("ChildrenChart");
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black26;
                              }
                              return Colors.white;
                            }),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                        child: const Text(
                          "أضف الطفل",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
