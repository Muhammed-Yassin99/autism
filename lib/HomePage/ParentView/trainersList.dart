// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'package:Autism_Helper/HomePage/ParentView/ChildrenList.dart';
import 'package:Autism_Helper/HomePage/ParentView/addChild.dart';
import 'package:Autism_Helper/HomePage/ParentView/parentChat.dart';
import 'package:Autism_Helper/HomePage/ParentView/questions.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:fl_chart/fl_chart.dart'
    show
        BarAreaData,
        FlBorderData,
        FlGridData,
        FlLine,
        FlSpot,
        FlTitlesData,
        LineChart,
        LineChartBarData,
        LineChartData,
        SideTitles;

class trainersList extends StatefulWidget {
  const trainersList({Key? key}) : super(key: key);

  @override
  FiChartPageState createState() => FiChartPageState();
}

class FiChartPageState extends State<trainersList> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var trainerName;
  var userName;
  var currentRequest;
  List trainers = [];
  var assignedTrainer;
  var children = [];
  bool isDialogShowing = false;
  CollectionReference ChildrenRef =
      FirebaseFirestore.instance.collection("parents");
  String gmail = FirebaseAuth.instance.currentUser!.email.toString();
  var parentUid = FirebaseAuth.instance.currentUser?.uid;
  //String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference trainerRef =
      FirebaseFirestore.instance.collection("trainers");
  CollectionReference parentRef =
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
      isDialogShowing = true;
    }
    print(isDialogShowing);
  }

  getTrainers() async {
    await getChildren();
    var response = await trainerRef.get();
    for (var element in response.docs) {
      setState(() {
        trainers.add(element.data());
      });
    }
    if (kDebugMode) {
      print(trainers);
    }
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
            setState(() {
              userName = element['username'].toString();
              currentRequest = element['currentRequest'].toString();
              assignedTrainer = element['assignedTrainer'].toString();
            });
          });
          break;
        }
      }
    });
  }

  Widget applyButton(String usermail, String trainerUid) {
    DocumentReference ref = parentRef.doc(uid);
    if (isDialogShowing == true) {
      return Positioned(
        top: 40,
        left: 5,
        child: Container(
          width: 120,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue,
          ),
          child: ElevatedButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "لم تقم بإضافة أي طفل بعد",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const addChild()));
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(150, 40)),
                      ),
                      child: const Text(
                        'أضف طفل',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
                dialogType: DialogType.info,
                animType: AnimType.leftSlide,
              ).show();
            },
            child: const Center(
              child: Text(
                'تقديم طلب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (isDialogShowing == false &&
        currentRequest == "" &&
        assignedTrainer == "") {
      return Positioned(
        top: 40,
        left: 5,
        child: Container(
          width: 120,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue,
          ),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                ref.update({"currentRequest": usermail});
                setUserName();
              });
              var trainerRef1 = trainerRef.doc(trainerUid);
              trainerRef1.update({
                'pendingRequests': FieldValue.arrayUnion([parentUid])
              });
            },
            child: const Center(
              child: Text(
                'تقديم طلب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (isDialogShowing == false &&
        currentRequest != "" &&
        currentRequest != usermail &&
        assignedTrainer == "") {
      return Positioned(
        top: 40,
        left: 5,
        child: Container(
          width: 120,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue,
          ),
          child: ElevatedButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                title: "Error",
                body: const Text(
                  "لديك طلب قيد الانتظار, قم بالغائه حتي تسطيع تقديم طلب اخر",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ).show();
            },
            child: const Center(
              child: Text(
                'تقديم طلب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (isDialogShowing == false &&
        currentRequest == usermail &&
        assignedTrainer == "") {
      return Positioned(
        top: 40,
        left: 5,
        child: Container(
          width: 120,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 243, 33, 33),
          ),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                ref.update({"currentRequest": ""});
                var trainerRef1 = trainerRef.doc(trainerUid);
                trainerRef1.update({
                  'pendingRequests': FieldValue.arrayRemove([parentUid])
                });
                setUserName();
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: const Center(
              child: Text(
                'الغاء طلب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (isDialogShowing == false && assignedTrainer != "") {
      return Positioned(
        top: 40,
        left: 5,
        child: Container(
          width: 120,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue,
          ),
          child: ElevatedButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                title: "Error",
                body: const Text(
                  "!لقد انضممت الي طبيب معالج بالفعل, لا يمكنك الالتحاق لاكثر من طبيب في وقت واحد",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ).show();
            },
            child: const Center(
              child: Text(
                'تقديم طلب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Text("error");
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

  @override
  void initState() {
    getChildren();
    getTrainers();
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
              accountEmail: Text(gmail),
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
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.blue,
              ),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'الصفحة الرئيسية'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("parentHomePage");
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.child_care,
                color: Colors.blue,
              ),
              title: const Text(style: TextStyle(fontSize: 18), 'الأطفال'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChildrenList()));
              },
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
              title:
                  const Text(style: TextStyle(fontSize: 18), 'قائمة المدربين'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const trainersList()));
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.chat,
                color: Colors.blue,
              ),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'المدرب الحالي'),
              onTap: () {
                if (assignedTrainer == "") {
                  AwesomeDialog(
                    context: context,
                    body: const Text(
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
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.question_mark,
                color: Colors.blue,
              ),
              title:
                  const Text(style: TextStyle(fontSize: 18), 'الأسئلة الشائعة'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FaqsPage()));
              },
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            ListTile(
              title: const Text(style: TextStyle(fontSize: 18), 'تسجيل الخروج'),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
              onTap: () async {
                // await FirebaseAuth.instance.signOut();
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
        backgroundColor: Colors.black,
        titleSpacing: 0.0,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'قائمة المدربين',
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
      ),
      body: Container(
        color: const Color.fromARGB(255, 96, 139, 115),
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      itemCount: trainers.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                            child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ExpansionTile(
                            backgroundColor: Colors.black,
                            title: SizedBox(
                              height: 110,
                              child: Stack(
                                children: [
                                  applyButton(
                                      trainers[i]['gmail'], trainers[i]['uid']),
                                  Positioned(
                                      top: 10,
                                      right: 85,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${trainers[i]['username']}",
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
                                          ])),
                                  Positioned(
                                    height: 90,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 4,
                                              color: const Color.fromARGB(
                                                  255, 33, 37, 243),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  trainers[i]['profilePic']),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Divider(color: Colors.red),
                              Card(
                                color: Colors.grey,
                                child: ListTile(
                                  title: Text(
                                      style: const TextStyle(fontSize: 26),
                                      textAlign: TextAlign.right,
                                      "${"سنين الخبرة"}: ${trainers[i]['yearsOfExp']}"),
                                ),
                              ),
                              const Divider(color: Colors.red),
                              Card(
                                color: Colors.grey,
                                child: ListTile(
                                  title: Text(
                                      style: const TextStyle(fontSize: 26),
                                      textAlign: TextAlign.right,
                                      "${"محل العمل"}: ${trainers[i]['location']}"),
                                ),
                              ),
                              const Divider(color: Colors.red),
                              Card(
                                color: Colors.grey,
                                child: ListTile(
                                  title: Text(
                                      style: const TextStyle(fontSize: 26),
                                      textAlign: TextAlign.right,
                                      "${"أوقات العمل"}: ${trainers[i]['availabeTimes']}"),
                                ),
                              ),
                              const Divider(color: Colors.red),
                              Card(
                                color: Colors.grey,
                                child: ListTile(
                                  title: Text(
                                      style: const TextStyle(fontSize: 26),
                                      textAlign: TextAlign.right,
                                      "${trainers[i]['gmail']}:${"البريد الالكتروني"}"),
                                ),
                              ),
                            ],
                          ),
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
