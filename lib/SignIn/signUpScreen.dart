// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../HomePage/home.dart';
import '../utils/colors_utils.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<signUpScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var userName, userEmail, userPass;
  String errorMSG = "";
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  SignUp() async {
    var formdate = formstate.currentState;
    if (formdate!.validate()) {
      formdate.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: userEmail, password: userPass);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        errorMSG = e.code;
        if (e.code == 'invalid-email') {
          errorMSG = "بريد الكتروني غير صحيح";
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(errorMSG),
          ).show();
        } else if (e.code == 'weak-password') {
          errorMSG = "كلمة مرور ضعيفة";
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(
              errorMSG,
            ),
          ).show();
        } else if (e.code == 'email-already-in-use') {
          errorMSG = "البريد الألكتروني مستخدم من قبل ";
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(errorMSG),
          ).show();
        } else {
          errorMSG = e.code;
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(errorMSG),
          ).show();
        }
      }
    }
    if (kDebugMode) {
      print("Not Valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "أنشاء حساب",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.18,
                  ),
                  //if (errorMSG != "") alert(),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.06,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      userName = newValue;
                    },
                    validator: (value) {
                      if (value!.length > 50) {
                        return "اسم المستخدم لا يمكن ان يتجاوز ال 50 حرف";
                      }
                      if (value.length < 4) {
                        return "اسم المستخدم لا يمكن ان يقل عن ال 4 حروف";
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
                      labelText: "اسم المستخدم",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      userEmail = newValue;
                    },
                    validator: (value) {
                      if (value!.length > 50) {
                        return " البريد الألكتروني لا يمكن ان يتجاوز ال 50 حرف";
                      }
                      if (value.length < 4) {
                        return " البريد الألكتروني لا يمكن ان يقل عن ال 4 حروف";
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
                      labelText: "البريد الألكتروني",
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
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      userPass = newValue;
                    },
                    validator: (value) {
                      if (value!.length > 50) {
                        return " كلمة المرور لا يمكن ان يتجاوز ال 50 حرف";
                      }
                      if (value.length < 4) {
                        return "كلمة المرور لا يمكن ان يقل عن ال 4 حروف";
                      }
                      return null;
                    },
                    obscureText: true,
                    enableSuggestions: false,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white70,
                      ),
                      labelText: "كلمة المرور",
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
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(90)),
                    child: ElevatedButton(
                      onPressed: () async {
                        UserCredential? response = await SignUp();
                        if (response != null) {
                          Navigator.of(context)
                              .pushReplacementNamed("homePage");
                        } else {
                          if (kDebugMode) {
                            print("Sign Up Failed");
                          }
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black26;
                            }
                            return Colors.white;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                      child: const Text(
                        "انشاء حساب",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ))),
    );
  }

  Widget alert() {
    return Container(
      //alignment: Alignment.topCenter,
      color: Colors.amberAccent,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.error_outline),
          ),
          Expanded(
            child: Text(
              errorMSG,
              maxLines: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  errorMSG = "";
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
