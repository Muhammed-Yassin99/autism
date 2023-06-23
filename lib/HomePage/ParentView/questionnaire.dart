import 'package:flutter/material.dart';
import 'package:autism_zz/model/question.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Text(
            "إستبيان سلوك الطفل",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
            ),
          ),
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
      children: [
        Text(
          textAlign: TextAlign.right,
          "${currentQuestionIndex + 1}/${questionList.length.toString()} السؤال",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
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
              fontSize: 22,
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
    String title = isPassed ? "Passed " : "Failed";
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.5;
    double buttonHeight = screenWidth * 0.125;

    return AlertDialog(
      title: Text(
        textAlign: TextAlign.right,
        "$title | الناتج النهائي : $totalScore",
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
