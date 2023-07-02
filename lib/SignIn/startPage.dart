// ignore_for_file: camel_case_types, must_be_immutable, file_names
import 'package:Autism_Helper/SignIn/signInScreen.dart';
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
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.40,
                    decoration: BoxDecoration(
                        color: Colors.blue,
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
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: const Text(
                          'ولي الأمر',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.50,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
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
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: const Text(
                            'مدرب',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
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
