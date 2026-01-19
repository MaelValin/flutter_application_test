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
  List<int> userAnswers = []; // Stocke les indices des réponses de l'utilisateur

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
      userAnswers.add(selectedAnswerIndex!); // Sauvegarde la réponse de l'utilisateur
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Score
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 26, 36, 130),
                        Color.fromARGB(255, 59, 137, 192),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      
                      Text(
                        'Score final : $score / ${questions.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        score == questions.length
                            ? 'Bravo ! Parfait !'
                            : score >= questions.length / 2
                                ? 'Pas mal !'
                                : 'Peux mieux faire !',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Récapitulatif des questions
                Text(
                  'Récapitulatif',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Liste de toutes les questions avec les réponses
                ...List.generate(questions.length, (questionIndex) {
                  final question = questions[questionIndex];
                  final userAnswerIndex = userAnswers[questionIndex];
                  final correctAnswerIndex = question.answers
                      .indexWhere((answer) => answer.isCorrect);
                  final isUserAnswerCorrect = userAnswerIndex == correctAnswerIndex;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 45, 45, 45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isUserAnswerCorrect 
                            ? Colors.green 
                            : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isUserAnswerCorrect ? Icons.check_circle : Icons.cancel,
                              color: isUserAnswerCorrect ? Colors.green : Colors.red,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Question ${questionIndex + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          question.question,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        // Affichage de toutes les réponses
                        ...question.answers.asMap().entries.map((entry) {
                          int answerIndex = entry.key;
                          Answer answer = entry.value;
                          bool isUserAnswer = answerIndex == userAnswerIndex;
                          bool isCorrectAnswer = answer.isCorrect;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12, 
                              vertical: 8
                            ),
                            decoration: BoxDecoration(
                              color: isCorrectAnswer
                                  ? Color.fromARGB(100, 76, 175, 80)
                                  : isUserAnswer
                                      ? Color.fromARGB(100, 244, 67, 54)
                                      : Color.fromARGB(50, 100, 100, 100),
                              borderRadius: BorderRadius.circular(8),
                              border: isUserAnswer || isCorrectAnswer
                                  ? Border.all(
                                      color: isCorrectAnswer 
                                          ? Colors.green 
                                          : Colors.red,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCorrectAnswer
                                      ? Icons.check
                                      : isUserAnswer
                                          ? Icons.close
                                          : Icons.circle_outlined,
                                  color: isCorrectAnswer
                                      ? Colors.green
                                      : isUserAnswer
                                          ? Colors.red
                                          : Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    answer.question,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: (isUserAnswer || isCorrectAnswer)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isUserAnswer && !isCorrectAnswer)
                                  Text(
                                    'Votre réponse',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                if (isCorrectAnswer)
                                  Text(
                                    'Bonne réponse',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }),
                
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
                        userAnswers.clear();
                        selectedAnswerIndex = null;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.replay, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Rejouer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Quizz', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 26, 84, 200),
        ),
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
