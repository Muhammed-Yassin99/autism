// ignore_for_file: camel_case_types, must_be_immutable
import 'package:autism_zz/SignIn/signInScreen.dart';
import 'package:flutter/material.dart';

class startPage extends StatelessWidget {
  const startPage({super.key});
  static var role = "";

  getRole() {
    return role;
  }

  setRole(String type) {
    role = type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/HomePage/startPage.jpg'),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.50,
                  left: MediaQuery.of(context).size.width * 0.257,
                  child: Container(
                    height: 80,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(28)),
                    child: TextButton(
                        onPressed: () {
                          setRole("parents");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const signInScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        // ignore: prefer_const_constructors
                        child: Text(
                          'ولي الأمر',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.63,
                  left: MediaQuery.of(context).size.width * 0.257,
                  child: Container(
                    height: 80,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(28)),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setRole("trainers");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const signInScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        // ignore: prefer_const_constructors
                        child: Text(
                          'مدرب',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
