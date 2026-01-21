import 'package:flutter/material.dart';
import 'models/movie.dart';

class GenreQuizPage extends StatefulWidget {
  final List<MovieListItem> allMovies;

  const GenreQuizPage({super.key, required this.allMovies});

  @override
  State<GenreQuizPage> createState() => _GenreQuizPageState();
}

class _GenreQuizPageState extends State<GenreQuizPage> {
  int currentQuestion = 0;
  Map<String, int> genreScores = {
    'Action': 0,
    'Science-Fiction': 0,
    'Drame': 0,
    'Aventure': 0,
    'Romance': 0,
    'Thriller': 0,
    'Animation': 0,
    'Comédie': 0,
  };

  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'Quel type d\'histoire préférez-vous ?',
      options: [
        QuizOption(
          text: 'Des combats et de l\'action intense',
          genres: {'Action': 3, 'Thriller': 1},
        ),
        QuizOption(
          text: 'Des voyages dans l\'espace ou le futur',
          genres: {'Science-Fiction': 3, 'Aventure': 1},
        ),
        QuizOption(
          text: 'Des histoires d\'amour émouvantes',
          genres: {'Romance': 3, 'Drame': 2},
        ),
        QuizOption(
          text: 'Des quêtes épiques et de l\'aventure',
          genres: {'Aventure': 3, 'Action': 1},
        ),
      ],
    ),
    QuizQuestion(
      question: 'Quelle ambiance recherchez-vous dans un film ?',
      options: [
        QuizOption(
          text: 'Suspense et mystère',
          genres: {'Thriller': 3, 'Science-Fiction': 1},
        ),
        QuizOption(
          text: 'Émotion et réflexion profonde',
          genres: {'Drame': 3, 'Romance': 1},
        ),
        QuizOption(
          text: 'Divertissement et rires',
          genres: {'Comédie': 3, 'Animation': 2},
        ),
        QuizOption(
          text: 'Adrénaline et explosions',
          genres: {'Action': 3, 'Aventure': 1},
        ),
      ],
    ),
    QuizQuestion(
      question: 'Quel personnage principal vous attire le plus ?',
      options: [
        QuizOption(
          text: 'Un super-héros ou un guerrier',
          genres: {'Action': 3, 'Aventure': 2},
        ),
        QuizOption(
          text: 'Un scientifique ou explorateur',
          genres: {'Science-Fiction': 3, 'Drame': 1},
        ),
        QuizOption(
          text: 'Un personnage avec une histoire touchante',
          genres: {'Drame': 3, 'Romance': 2},
        ),
        QuizOption(
          text: 'Un détective ou agent secret',
          genres: {'Thriller': 3, 'Action': 1},
        ),
      ],
    ),
    QuizQuestion(
      question: 'Quel setting préférez-vous ?',
      options: [
        QuizOption(
          text: 'Le futur, l\'espace ou des mondes virtuels',
          genres: {'Science-Fiction': 3, 'Action': 1},
        ),
        QuizOption(
          text: 'Des époques historiques ou fantasy',
          genres: {'Aventure': 3, 'Drame': 1},
        ),
        QuizOption(
          text: 'La vie quotidienne moderne',
          genres: {'Drame': 2, 'Romance': 2, 'Comédie': 1},
        ),
        QuizOption(
          text: 'Des villes sombres et dangereuses',
          genres: {'Thriller': 3, 'Action': 2},
        ),
      ],
    ),
    QuizQuestion(
      question: 'Qu\'est-ce qui vous captive le plus dans un film ?',
      options: [
        QuizOption(
          text: 'Les effets spéciaux et scènes d\'action',
          genres: {'Action': 3, 'Science-Fiction': 2},
        ),
        QuizOption(
          text: 'L\'histoire et les émotions des personnages',
          genres: {'Drame': 3, 'Romance': 2},
        ),
        QuizOption(
          text: 'L\'univers imaginaire et la créativité',
          genres: {'Science-Fiction': 2, 'Aventure': 2, 'Animation': 2},
        ),
        QuizOption(
          text: 'Le suspense et les rebondissements',
          genres: {'Thriller': 3, 'Drame': 1},
        ),
      ],
    ),
  ];

  void _selectAnswer(QuizOption option) {
    setState(() {
      option.genres.forEach((genre, points) {
        genreScores[genre] = (genreScores[genre] ?? 0) + points;
      });

      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    // Trier les genres par score
    var sortedGenres = genreScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<String> topGenres = sortedGenres.take(3).map((e) => e.key).toList();

    // Filtrer les films correspondants
    List<MovieListItem> recommendedMovies = _getMoviesForGenres(topGenres);

    Navigator.pop(context, {
      'genres': topGenres,
      'movies': recommendedMovies,
      'scores': genreScores,
    });
  }

  List<MovieListItem> _getMoviesForGenres(List<String> genres) {
    // Mapping des films aux genres (basé sur les films de filmdata.json)
    Map<String, List<String>> movieGenres = {
      'Inception': ['Science-Fiction', 'Thriller', 'Action'],
      'Interstellar': ['Science-Fiction', 'Drame', 'Aventure'],
      'The Dark Knight': ['Action', 'Thriller', 'Drame'],
      'The Matrix': ['Science-Fiction', 'Action', 'Thriller'],
      'Pulp Fiction': ['Thriller', 'Drame', 'Action'],
      'Forrest Gump': ['Drame', 'Romance', 'Comédie'],
      'The Shawshank Redemption': ['Drame', 'Thriller'],
      'Gladiator': ['Action', 'Aventure', 'Drame'],
      'Avatar': ['Science-Fiction', 'Action', 'Aventure'],
      'Titanic': ['Romance', 'Drame'],
      'The Avengers': ['Action', 'Science-Fiction', 'Aventure'],
      'Jurassic Park': ['Science-Fiction', 'Aventure', 'Thriller'],
      'The Lord of the Rings': ['Aventure', 'Action', 'Drame'],
      'Spider-Man: No Way Home': ['Action', 'Science-Fiction', 'Aventure'],
      'Oppenheimer': ['Drame', 'Thriller'],
    };

    // Calculer le score de correspondance pour chaque film
    Map<MovieListItem, int> movieScores = {};
    for (var movie in widget.allMovies) {
      int score = 0;
      List<String> filmGenres = movieGenres[movie.title] ?? [];

      for (var genre in genres) {
        if (filmGenres.contains(genre)) {
          score +=
              (3 -
              genres.indexOf(genre)); // Plus de points pour le premier genre
        }
      }

      if (score > 0) {
        movieScores[movie] = score;
      }
    }

    // Trier les films par score et prendre les 3 meilleurs
    var sortedMovies = movieScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedMovies.take(3).map((e) => e.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final progress = (currentQuestion + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎯 Quiz de Genre',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 22, 28),
      ),
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barre de progression
            Column(
              children: [
                Text(
                  'Question ${currentQuestion + 1}/${questions.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[700],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 59, 137, 192),
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Question
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 26, 36, 130),
                    Color.fromARGB(255, 59, 137, 192),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                question.question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ElevatedButton(
                      onPressed: () => _selectAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 50, 50, 60),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 59, 137, 192),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        option.text,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;

  QuizQuestion({required this.question, required this.options});
}

class QuizOption {
  final String text;
  final Map<String, int> genres;

  QuizOption({required this.text, required this.genres});
}
