import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  var userGmail;
  var userName;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: loadDataFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // Handle errors
              return const Scaffold(
                body: Center(
                  child: Text('Error loading data'),
                ),
              );
            } else {
              // Data has been loaded, return your app's home screen
              final data = snapshot.data;
              return HomeScreen(data: data ?? []);
            }
          } else {
            // Show a loading indicator while waiting for data to load
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  getUserNameAndEmail() async {
    var user = FirebaseAuth.instance.currentUser;
    String gmail = user!.email.toString();
    userGmail = gmail;
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == gmail) {
          userName = element['username'].toString();
          break;
        }
      }
    });
  }

  Future<List<String>> loadDataFromDatabase() async {
    // Load data from the database here
    // ...

    // Wait for some time to simulate data loading
    await Future.delayed(const Duration(seconds: 2));

    // Return loaded data
    return ['item 1', 'item 2', 'item 3'];
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> data;

  HomeScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index]),
          );
        },
      ),
    );
  }
}
