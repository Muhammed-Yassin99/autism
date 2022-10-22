import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class startPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset('assets/imgs/of_main_bg.png',
                        fit: BoxFit.cover),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Container(
                              width: 180,
                              height: 180,
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: const Text(
                                " ",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 26,
                                    fontFamily: 'orilla'),
                              )),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text('Bienvenido/a',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40),
                      const Text('Productos Frescos.\nSaludables. A Tiempo',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 40),
                    ],
                  ),
                )
              ],
            )));
  }
}
