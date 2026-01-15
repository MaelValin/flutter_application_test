import 'package:flutter/material.dart';
import 'models.dart';
import 'composant/question_text.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswerIndex;

  final List<Question> questions = [
    Question(
      question: 'Comment je m\'appelle ?',
      answers: [
        Answer(question: 'Mael', isCorrect: false),
        Answer(question: 'Aaron', isCorrect: true),
        Answer(question: 'Kay', isCorrect: false),
        Answer(question: 'staine', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel est mon super heros préféré ?',
      answers: [
        Answer(question: 'Superman', isCorrect: false),
        Answer(question: 'Flash', isCorrect: false),
        Answer(question: 'Spider-Man', isCorrect: true),
        Answer(question: 'Thunderman', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel est mon film préféré ?',
      answers: [
        Answer(question: 'Stateman', isCorrect: false),
        Answer(question: 'Real steel', isCorrect: true),
        Answer(question: 'the fantastic four', isCorrect: false),
        Answer(question: 'Iron man', isCorrect: false),
        Answer(question: 'ça', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel est ma saga préférée ?',
      answers: [
        Answer(question: 'The hobbit', isCorrect: false),
        Answer(question: 'Spider-Man', isCorrect: false),
        Answer(question: 'Harry Potter', isCorrect: true),
      ],
    ),
  ];

  void answerQuestion(bool isCorrect) {
    setState(() {
      if (isCorrect) score++;
      currentQuestion++;
      selectedAnswerIndex = null; // Reset la sélection
    });
  }

  void selectAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Résultat', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 26, 84, 200),
        ),
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score final : $score / ${questions.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                score == questions.length
                    ? 'Bravo !'
                    : score >= questions.length / 2
                    ? 'Pas mal !'
                    : 'Peux mieux faire !',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              Container(
                width: 150,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 26, 36, 130),
                      Color.fromARGB(255, 59, 137, 192),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(50, 0, 0, 0),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      currentQuestion = 0;
                      score = 0;
                    });
                  },
                  child: const Text(
                    'Rejouer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 35, 35),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Column(
              children: [
                QuestionText(questionText: question.question),

                const SizedBox(height: 20),

                // On génère les boutons de réponse directement ici
                ...question.answers.asMap().entries.map((entry) {
                  int index = entry.key;
                  Answer answer = entry.value;
                  bool isSelected = selectedAnswerIndex == index;
                  
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isSelected
                            ? [
                                Color.fromARGB(255, 59, 137, 192),
                                Color.fromARGB(255, 26, 36, 130),
                              ]
                            : [
                                Color.fromARGB(255, 26, 36, 130),
                                Color.fromARGB(255, 59, 137, 192),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(50, 0, 0, 0),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () => selectAnswer(index),

                      child: Text(
                        answer.question,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Text(
                  'Questions : $currentQuestion / ${questions.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            
            Container(
                width: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: selectedAnswerIndex != null
                        ? [
                            Color.fromARGB(255, 26, 36, 130),
                            Color.fromARGB(255, 59, 137, 192),
                          ]
                        : [
                            Color.fromARGB(100, 100, 100, 100),
                            Color.fromARGB(100, 150, 150, 150),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(50, 0, 0, 0),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: selectedAnswerIndex != null
                      ? () {
                          answerQuestion(
                              question.answers[selectedAnswerIndex!].isCorrect);
                        }
                      : null,
                  child: Text(
                    'Suivant',
                    style: TextStyle(
                      color: selectedAnswerIndex != null
                          ? Colors.white
                          : Colors.white38,
                    ),
                  ),
                ),
              ),



            Spacer(),
          ],
        ),
      ),
    );
  }
}
