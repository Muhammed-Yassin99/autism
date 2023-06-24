// ignore_for_file: use_build_context_synchronously

import 'package:autism_zz/HomePage/ParentView/ChildrenList.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:autism_zz/model/question.dart';
import 'package:autism_zz/HomePage/ParentView/parentChat.dart';
import 'package:autism_zz/HomePage/ParentView/questions.dart';
import 'package:autism_zz/HomePage/ParentView/trainersList.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => QuestionnaireState();
}

class QuestionnaireState extends State<QuestionnairePage> {
  //define the datas
  List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  int totalScore = 0;
  Answer? selectedAnswer;

  var userName;
  var trainerName;
  var assignedTrainer = "";
  List children = [];
  String currentChild = "";
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  var uid = FirebaseAuth.instance.currentUser!.uid;
  //String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference ChildrenRef =
      FirebaseFirestore.instance.collection("parents");

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
    //getChildren();
    setCurrentChild();
    getTrainerName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName.toString()),
              accountEmail: Text(mail),
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
                child: Text(
                    style: const TextStyle(fontSize: 22, color: Colors.black),
                    "${"الطفل الحالي"}: $currentChild"),
              ),
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
            'إستبيان عن حالة الطفل',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _questionWidget(),
          _answerList(),
          _nextButton(),
        ]),
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          textAlign: TextAlign.right,
          "${currentQuestionIndex + 1}/${questionList.length.toString()} السؤال",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 80, 161, 227),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedAnswer;

    return GestureDetector(
      onTap: () {
        if (selectedAnswer == null) {
          setState(() {
            selectedAnswer = answer;
            score = answer.score;
          });
        } else {
          setState(() {
            selectedAnswer = null;
            score = answer.score;
          });
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 64, // Increase the height of the button
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textAlign: TextAlign.right,
                answer.answerText,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 22, // Increase the font size of the answer text
                ),
              ),
              Icon(
                isSelected ? Icons.check : Icons.radio_button_unchecked,
                color: isSelected ? Colors.white : Colors.black,
                size: 24, // Increase the size of the check/radio button
              ),
            ],
          ),
        ),
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          if (selectedAnswer != null) {
            // Check if an answer has been selected
            totalScore += score;
            if (isLastQuestion) {
              //display score
              showDialog(context: context, builder: (_) => _showScoreDialog());
            } else {
              //next question
              setState(() {
                selectedAnswer = null;
                currentQuestionIndex++;
              });
            }
          } else {
            AwesomeDialog(
              context: context,
              body: const Text(
                textAlign: TextAlign.center,
                "اختر الإجابة أولا قبل الانتقال الي السؤال التالي",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              dialogType: DialogType.info,
              animType: AnimType.leftSlide,
            ).show();
          }
        },
        child: Text(
          isLastQuestion ? "تاكيد" : "التالي",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  _showScoreDialog() {
    bool isPassed = false;

    if (totalScore >= questionList.length * 0.6) {
      //pass if 60 %
      isPassed = true;
    }
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.5;
    double buttonHeight = screenWidth * 0.125;

    return AlertDialog(
      title: Text(
        textAlign: TextAlign.right,
        "$totalScore : الناتج النهائي",
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              child: const Text("إعادة", style: TextStyle(fontSize: 22)),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                  selectedAnswer = null;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              child: const Text("إنهاء", style: TextStyle(fontSize: 22)),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("parentHomePage");
              },
            ),
          ),
        ],
      ),
    );
  }
}
