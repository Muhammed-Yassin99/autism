// ignore_for_file: use_build_context_synchronously, avoid_returning_null_for_void, prefer_typing_uninitialized_variables, must_be_immutable, unused_local_variable, prefer_interpolation_to_compose_strings, file_names, non_constant_identifier_names, prefer_const_constructors, duplicate_ignore
import 'package:autism_zz/HomePage/ParentView/parentChat.dart';
import 'package:autism_zz/HomePage/ParentView/trainersList.dart';
import 'package:autism_zz/ObjectDetection/objecDetecHomePage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Games/gamesHomePage1.dart';
import '../../Learn/learnHomePage.dart';
import 'ChildrenList.dart';
import 'addChild.dart';
import '../../model/homePage_icons.dart';
import '../../skills/skillsHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomePage> {
  var userName;
  var trainerName;
  var assignedTrainer = "";
  List children = [];
  String currentChild = "";
  var uid = FirebaseAuth.instance.currentUser!.uid;
  //String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference ChildrenRef =
      FirebaseFirestore.instance.collection("parents");

  getChildren() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference childRef = ChildrenRef.doc(uid).collection("children");
    var response = await childRef.get();
    for (var element in response.docs) {
      setState(() {
        children.add(element.data());
      });
    }
    if (children.isEmpty) {
      currentChild = "لم تقم بإضافة أي طفل بعد";
    } else {
      currentChild = children[0]['name'];
    }
  }

  setCurrentChild() async {
    await getChildren();
    String child = "";
    var uid = FirebaseAuth.instance.currentUser!.uid;
    String mail = FirebaseAuth.instance.currentUser!.email.toString();
    DocumentReference ref = ChildrenRef.doc(uid);
    ChildrenRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == mail) {
          child = element['currentChild'].toString();
          break;
        }
      }
    });
    if (child == "") {
      ref.update({"currentChild": currentChild});
    }
    if (currentChild == "") {
      currentChild = "لم تقم بإضافة أي طفل بعد";
    }
    if (kDebugMode) {
      print(child);
    }
  }

  changeCurrentChild() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference ref = ChildrenRef.doc(uid);
    await ref.update({"currentChild": currentChild});
    if (kDebugMode) {
      print("done");
    }
  }

  getTrainerName() async {
    await setUserName();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['uid'].toString() == assignedTrainer) {
          setState(() {
            trainerName = element['username'].toString();
          });
          break;
        }
      }
    });
  }

  setUserName() async {
    var user = FirebaseAuth.instance.currentUser;
    String mail = user!.email.toString();
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("parents");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['gmail'].toString() == mail) {
          setState(() {
            userName = element['username'].toString();
            assignedTrainer = element['assignedTrainer'].toString();
          });
          break;
        }
      }
    });
  }

  @override
  void initState() {
    //getChildren();
    setCurrentChild();
    getTrainerName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName.toString()),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/HomePage/parent.png',
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
            // ignore: prefer_const_constructors
            Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ExpansionTile(
                  title: Text(
                      style: const TextStyle(fontSize: 22, color: Colors.black),
                      "${"الطفل الحالي"}: $currentChild"),
                  children: [
                    ListView.builder(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      itemCount: children.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          color: Colors.white,
                          child: TextButton(
                            onPressed: () {
                              currentChild = children[i]['name'];
                              changeCurrentChild();
                            },
                            child: Text(
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                                "${children[i]['name']}"),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.child_care),
              title: const Text(style: TextStyle(fontSize: 18), 'الأطفال'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChildrenList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'قائمة المدربين'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const trainersList()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.chat),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'المدرب الحالي'),
              onTap: () {
                if (assignedTrainer == "") {
                  AwesomeDialog(
                    context: context,
                    body: Text(
                      "!لم تقم بالانضمام الي طبيب معالج",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    dialogType: DialogType.info,
                    animType: AnimType.leftSlide,
                  ).show();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => parentChatScreen(
                        senderId: assignedTrainer,
                        receiverId: uid.toString(),
                        trainerName: trainerName,
                      ),
                    ),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(style: TextStyle(fontSize: 18), 'الأعدادات'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text(style: TextStyle(fontSize: 18), 'تسجيل الخروج'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  FirebaseAuth.instance.signOut();
                });
                Navigator.of(context).pushReplacementNamed("startPage");
              },
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
    var category = homePage_categories[index];
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

  buildPopUpMenu() {
    return PopupMenuButton(
      initialValue: 2,
      child: const Center(child: Text('click here')),
      itemBuilder: (context) {
        return List.generate(5, (index) {
          return PopupMenuItem(
            value: index,
            child: Text('button no $index'),
          );
        });
      },
    );
  }

  buildWelcome() {
    //setState(() {});
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const gamesHomePage()));
    }
    if (category.id == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const learnHomePage()));
    }
    if (category.id == 3) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const skillsHomePage()));
    }
    if (category.id == 4) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const addChild()));
    }
    if (category.id == 5) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ChildrenList()));
    }
    if (category.id == 6) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => objecDetecHomepage()));
    }
  }
}
