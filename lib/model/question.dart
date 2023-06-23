class Question {
  final String questionText;
  final List<Answer> answersList;

  Question(this.questionText, this.answersList);
}

class Answer {
  final String answerText;
  final int score;

  Answer(this.answerText, this.score);
}

List<Question> getQuestions() {
  List<Question> list = [];

  list.add(Question(
    "انه يفضل القيام باألشياء مع الاخرين بدال من التركيز على القيام بها بمفرده ",
    [
      Answer("أوافق بشدة", 1),
      Answer("أوافق قليلا", 2),
      Answer("أعارض قليلا ", 3),
      Answer("أعارض بشدة", 4),
    ],
  ));

  list.add(Question(
    "Who owns iPhone?",
    [
      Answer("Apple", 1),
      Answer("Microsoft", 2),
      Answer("Google", 4),
      Answer("Nokia", 5),
    ],
  ));

  list.add(Question(
    "YouTube is ___ platform?",
    [
      Answer("Music Sharing", 1),
      Answer("Video Sharing", 3),
      Answer("Live Streaming", 0),
      Answer("All of the above", 4),
    ],
  ));

  return list;
}
