import 'package:flutter/material.dart';
import 'services/film_service.dart';
import 'composant/video_player_dialog.dart';

class QuizResultsPage extends StatelessWidget {
  final List<String> topGenres;
  final List<Movie> recommendedMovies;
  final Map<String, int> genreScores;

  const QuizResultsPage({
    super.key,
    required this.topGenres,
    required this.recommendedMovies,
    required this.genreScores,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎬 Vos Recommandations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 22, 28),
      ),
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Message de résultat
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
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 50,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Vos genres préférés :',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ...topGenres.asMap().entries.map((entry) {
                      int index = entry.key;
                      String genre = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}. ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              genre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${genreScores[genre]} pts',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 20, 22, 28),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Titre des recommandations
              const Text(
                '🎯 Films recommandés pour vous :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Liste des films recommandés
              if (recommendedMovies.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Aucun film trouvé pour vos préférences.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...recommendedMovies.asMap().entries.map((entry) {
                  int index = entry.key;
                  Movie movie = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onLongPress: () {
                        if (movie.video != null && movie.video!.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => VideoPlayerDialog(
                              videoUrl: movie.video!,
                              movieTitle: movie.title,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Aucune vidéo disponible pour ce film',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 26, 36, 130),
                                Color.fromARGB(255, 59, 137, 192),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  // Badge de position
                                  Container(
                                    width: 40,
                                    height: 175,
                                    decoration: BoxDecoration(
                                      color: index == 0
                                          ? Colors.amber
                                          : index == 1
                                          ? Colors.grey[400]
                                          : const Color.fromARGB(
                                              255,
                                              205,
                                              127,
                                              50,
                                            ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Poster
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      movie.poster,
                                      width: 120,
                                      height: 175,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 120,
                                        height: 175,
                                        color: const Color.fromARGB(
                                          255,
                                          71,
                                          71,
                                          71,
                                        ),
                                        
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Informations du film
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            movie.year.toString(),
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                179,
                                                236,
                                                236,
                                                236,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            movie.description,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                179,
                                                207,
                                                207,
                                                207,
                                              ),
                                              fontSize: 12,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

              const SizedBox(height: 20),

              // Bouton pour refaire le quiz
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                
                label: const Text('Finir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 59, 137, 192),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Message informatif
              const Center(
                child: Text(
                  'Appuyez longuement sur un film pour voir sa bande-annonce',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
