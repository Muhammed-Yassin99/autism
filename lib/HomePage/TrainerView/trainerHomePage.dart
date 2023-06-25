// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

//import 'package:Autism_Helper/HomePage/trainerProfile.dart';
import 'package:Autism_Helper/HomePage/TrainerView/supervisedParents.dart';
import 'package:Autism_Helper/HomePage/TrainerView/trainerListOfRequests.dart';
import 'package:Autism_Helper/HomePage/TrainerView/trainerProfile.dart';
//import 'package:Autism_Helper/HomePage/trainerProfile1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/homePage_icons.dart';

class trainerHomePage extends StatefulWidget {
  const trainerHomePage({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<trainerHomePage> {
  static var userName = '';
  var userPic;
  List listOfRequests = [""];
  String mail = FirebaseAuth.instance.currentUser!.email.toString();

  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    if (kDebugMode) {
      print(user!.email);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    setUserName();
  }

  setUserName() async {
    var user = FirebaseAuth.instance.currentUser;
    String mail = user!.email.toString();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == mail) {
          setState(() {
            userName = element['username'].toString();
            userPic = element['profilePic'].toString();
            listOfRequests = element['pendingRequests'];
          });
          if (kDebugMode) {
            print(userName);
          }
          break;
        }
      }
    });
    if (userPic == "") {
      userPic =
          "https://firebasestorage.googleapis.com/v0/b/graduationproject-35c1f.appspot.com/o/images%2Fdoctor.png?alt=media&token=04531c72-1cf6-48f2-a20c-f305e8cd33a7";
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName.toString(),
                  style: const TextStyle(fontSize: 18)),
              accountEmail: Text(
                mail,
                style: const TextStyle(fontSize: 18),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    userPic.toString(),
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      'assets/images/HomePage/sideBarBackground.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.book,
                color: Colors.blue,
              ),
              title: const Text(
                'الشهادات',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: const Text(
                'اولياء الأمور',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const supervisedParents()));
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Colors.blue,
              ),
              title: const Text(
                'الطلبات',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const trainerListOfRequests()));
              },
              trailing: ClipOval(
                child: Container(
                  color: Colors.red,
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      '${listOfRequests.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontSize: 18),
              ),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  FirebaseAuth.instance.signOut();
                });
                Navigator.of(context).pushReplacementNamed("startPage");
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0.0,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'الصفحة الرئيسية',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
          ),
        ),
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
        /*leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
              alignment: Alignment.topLeft,
              iconSize: 50,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("startPage");
              },
              icon: const Icon(Icons.exit_to_app)),
        ),*/
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.list,
                size: 55,
              ),
              onPressed: () async {
                setState(() {});
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
          ),
        ),
      ),
      body: Container(
          //color: const Color.fromARGB(164, 0, 0, 0),
          color: const Color.fromARGB(255, 135, 135, 25),
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
                          childCount: trainerHomePage_categories.length,
                        )),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    var category = trainerHomePage_categories[index];
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
          Image.asset(category.icon, height: 100, width: 130),
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

  buildWelcome() {
    setState(() {});
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          userName.toString(),
          textAlign: TextAlign.end,
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
  }

  _categoryPressed(BuildContext context, category) {
    if (category.id == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const trainerListOfRequests()));
    }
    if (category.id == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const trainerProfile()));
    }
    if (category.id == 4) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const supervisedParents()));
    }
  }
}
