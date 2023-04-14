// ignore_for_file: camel_case_types

import 'package:autism_zz/HomePage/trainerModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class trainerProfile extends StatefulWidget {
  const trainerProfile({Key? key}) : super(key: key);

  @override
  State<trainerProfile> createState() => _trainerProfileState();
}

class _trainerProfileState extends State<trainerProfile> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userDataStream;
  late trainerModel trainModel;

  @override
  void initState() {
    super.initState();
    userDataStream = FirebaseFirestore.instance
        .collection("trainer")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Driver Profile',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        toolbarHeight: size.height * 0.10,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
            iconSize: 30,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/signup_login.jpeg"),
                fit: BoxFit.fill),
          ),
          height: size.height,
          child: SizedBox(
            child: SingleChildScrollView(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading user data"),
                      );
                    }

                    final data = snapshot.data!.data()!;
                    trainModel = trainerModel.fromJson(data);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(trainModel.imageURL),
                            ),
                            Text(
                              trainModel.userName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: const Alignment(0.5, 0.5),
                          child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (rating) {
                              if (kDebugMode) {
                                print(rating);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 15.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.mail),
                                  Text(
                                    trainModel.email,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 13.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_android),
                                  Text(
                                    trainModel.phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.03),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Text(
                                "Your History with Drivoo",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            Container(
                              height: 150,
                              width: 220,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/chart.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: const Text(
                                "Ride Name : \n\nTime Of The Ride : \n\nDrowsy Times : \n\nDistracted Times : ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
