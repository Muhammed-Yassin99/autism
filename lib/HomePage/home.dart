import 'package:flutter/material.dart';
import '../Games/gamesHomePage1.dart';
import '../Learn/learnHomePage.dart';
import '../model/category.dart';
import '../model/homePage_icons.dart';
import '../skills/skillsHomePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0.0,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'الصفحة الرئسية',
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
          const SizedBox(width: 18),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: buildWelcome(''),
          ),
        ),
      ),
      body: Container(
          //color: const Color.fromARGB(164, 0, 0, 0),
          color: const Color.fromARGB(255, 12, 79, 135),
          child: Stack(
            children: [
              const SizedBox(height: 8),
              const SizedBox(height: 32),
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
                    padding: const EdgeInsets.all(6.0),
                    sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 25.0),
                        delegate: SliverChildBuilderDelegate(
                          _buildCategoryItem,
                          childCount: homePage_categories.length,
                        )),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = homePage_categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 8.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(68.0),
      ),
      //color: const Color.fromARGB(255, 121, 23, 139),
      color: Colors.teal,
      hoverColor: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Image.asset(category.icon, height: 120, width: 150),
          const SizedBox(height: 5.0),
          Text(
            style: const TextStyle(
                fontSize: 22,
                wordSpacing: 1.1,
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

  Widget buildWelcome(String username) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            username,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            ' مرحبا',
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      );
  _categoryPressed(BuildContext context, Category category) {
    if (category.id == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const gamesHomePage()));
    }
    if (category.id == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const learnHomePage()));
    }
    if (category.id == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => skillsHomePage()));
    }
  }
}
