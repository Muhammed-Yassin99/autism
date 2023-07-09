// ignore_for_file: duplicate_import, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, import_of_legacy_library_into_null_safe
// @dart=2.9
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Autism_Helper/SignIn/startPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'HomePage/ParentView/parentHomePage.dart';
import 'HomePage/TrainerView/trainerHomePage.dart';
import 'SignIn/signInScreen.dart';
import 'HomePage/ParentView/ChildrenList.dart';
import 'package:splashscreen/splashscreen.dart';

var islogin;
var hasRole = false;
var role;
List<CameraDescription> cameras;

setHasRole(bool role) async {
  hasRole = role;
}

getHasRole() {
  return hasRole;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    if (kDebugMode) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    islogin = true;
    String uid = user.uid.toString();
    var documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    await documentReference.get().then((value) {
      role = value['role'].toString();
      if (role == "parents") {
        hasRole = false;
        setHasRole(false);
      } else if (role == "trainers") {
        hasRole = true;
        setHasRole(true);
      }
    });
  } else {
    islogin = false;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    hasRole = getHasRole();
    return MaterialApp(
      title: 'Autism',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "startPage": (context) => const startPage(),
        "login": (context) => const signInScreen(),
        "parentHomePage": (context) => const HomePage(),
        "trainerHomePage": (context) => const trainerHomePage(),
        "ChildrenChart": (context) => const ChildrenList()
      },
      home: islogin == false
          ? SplashScreen(
              seconds: 5,
              navigateAfterSeconds: const startPage(),
              title: Text('Autism Helper',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ])),
              image: Image.asset('assets/images/HomePage/AppIcon.png',
                  alignment: Alignment.center),
              backgroundColor: Colors.blue,
              photoSize: 100.0,
              loadingText: Text(
                'انت لست وحيدا',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.red.withOpacity(0.8),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]),
              ),
              //loaderColor: Colors.white,
            )
          : hasRole == false
              ? SplashScreen(
                  seconds: 5,
                  navigateAfterSeconds: const HomePage(),
                  title: Text('Autism Helper',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ])),
                  image: Image.asset('assets/images/HomePage/AppIcon.png',
                      alignment: Alignment.center),
                  backgroundColor: Colors.blue,
                  styleTextUnderTheLoader: const TextStyle(),
                  photoSize: 100.0,
                  loadingText: Text(
                    'انت لست وحيدا',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.red.withOpacity(0.8),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                  ),
                  //loaderColor: Colors.white,
                )
              : SplashScreen(
                  seconds: 5,
                  navigateAfterSeconds: const trainerHomePage(),
                  title: Text('Autism Helper',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ])),
                  image: Image.asset('assets/images/HomePage/AppIcon.png',
                      alignment: Alignment.center),
                  backgroundColor: Colors.blue,
                  styleTextUnderTheLoader: const TextStyle(),
                  photoSize: 100.0,
                  loadingText: Text(
                    'انت لست وحيدا',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.red.withOpacity(0.8),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                  ),
                  //loaderColor: Colors.white,
                ),
    );
  }
}
