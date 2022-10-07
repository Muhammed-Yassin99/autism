// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/homePage_icons.dart';
import 'textGames/animals/level1.dart';
import 'textGames/digits/level1.dart';
import 'textGames/faces/level1.dart';
import 'textGames/family/level1.dart';
import 'textGames/numbers/level1.dart';

class gamesHomePage extends StatelessWidget {
  const gamesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0.0,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'الالعاب',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
          color: const Color.fromARGB(164, 0, 0, 0),
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0),
                        delegate: SliverChildBuilderDelegate(
                          _buildCategoryItem,
                          childCount: game_categories.length,
                        )),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = game_categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      //color: const Color.fromARGB(255, 121, 23, 139),
      color: Colors.teal,

      hoverColor: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(category.icon, height: 90, width: 200),
          const SizedBox(height: 5.0),
          Text(
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 2, 9, 73)),
            category.name,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    if (category.id == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => facesLevel1()));
    }
    if (category.id == 5) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => animalsLevel1()));
    }
    if (category.id == 4) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => familyLevel1()));
    }
    if (category.id == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => numbersLevel1()));
    }
    if (category.id == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => digitsLevel1()));
    }
  }
}
