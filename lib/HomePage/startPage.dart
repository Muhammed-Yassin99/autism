// ignore_for_file: camel_case_types
import 'package:autism_zz/SignIn/signInScreen.dart';
import 'package:flutter/material.dart';

class startPage extends StatelessWidget {
  const startPage({super.key});

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
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                  right: MediaQuery.of(context).size.width,
                  top: MediaQuery.of(context).size.height * 0.75,
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(28)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const signInScreen()),
                          );
                        },
                        // ignore: prefer_const_constructors
                        child: Text(
                          'ولي أمر',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
    );
  }
}
