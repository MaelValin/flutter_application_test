class Answer {
  final String question;
  final bool isCorrect;

  Answer({required this.question, required this.isCorrect});
}

class Question {
  final String question;
  final List<Answer> answers;

  Question({required this.question, required this.answers});
}