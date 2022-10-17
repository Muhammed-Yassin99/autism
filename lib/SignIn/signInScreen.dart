// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../HomePage/home.dart';
import '../reuseableWidgets/reusedWidgets.dart';
import '../utils/colors_utils.dart';
import 'resetPass.dart';
import 'signUpScreen.dart';

class signInScreen extends StatefulWidget {
  const signInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<signInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  String errorMSG = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                if (errorMSG != "") alert(),
                logoWidget("assets/images/HomePage/signInLogo.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("أدخل أسم المستخدم", Icons.person_outline,
                    false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("أدخل كلمة المرور", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "تسجيل", () async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    });
                  } on FirebaseAuthException catch (e) {
                    errorMSG = e.code;
                    if (kDebugMode) {
                      print(e.toString());
                    }
                    if (e.code == 'invalid-email') {
                      if (kDebugMode) {
                        print('invalid-email format');
                      }
                      errorMSG = "بريد الكتروني غير صحيح";
                    } else if (e.code == 'user-not-found') {
                      if (kDebugMode) {
                        print('user-not-found');
                      }
                      errorMSG = "لا يوجد مستخدم بهذا الاسم";
                    } else if (e.code == 'wrong-password') {
                      setState(() {
                        if (kDebugMode) {
                          print('Wrong password provided for that user.');
                        }
                        errorMSG = "كلمة مرور خاطئة";
                      });
                    }
                  }
                }),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const signUpScreen()));
          },
          child: const Text(
            " انشاء حساب",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const Text("ليس لديك حساب؟", style: TextStyle(color: Colors.white70))
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "نسيت كلمة المرور؟",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const resetPass())),
      ),
    );
  }

  Widget alert() {
    return Container(
      //alignment: Alignment.topCenter,
      color: Colors.amberAccent,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
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
