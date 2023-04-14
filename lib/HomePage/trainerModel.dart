// ignore_for_file: camel_case_types
import 'package:firebase_auth/firebase_auth.dart';

class trainerModel {
  final String driverID = FirebaseAuth.instance.currentUser!.uid;
  late final String userName;
  late final String email;
  late final String phoneNumber;
  late final String imageURL;
  late final String password;
  late final double rate;

  trainerModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'] ?? "";
    email = json['email'] ?? "";
    phoneNumber = json['phoneNumber'] ?? "";
    imageURL = json['imageURL'] ?? "";
    rate = (json['rate'] as int).toDouble();
  }
}
