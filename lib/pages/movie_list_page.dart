import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_detail_page.dart';
import 'favorites_page.dart';
import '../genre_quiz_page.dart';
import '../quiz_results_page.dart';

class MovieListPage extends StatefulWidget {
  final MovieService movieService;

  const MovieListPage({super.key, required this.movieService});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<MovieListItem> movies = [];
  bool isLoading = true;
  String? errorMessage;
  final Set<int> favorites = {};

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedMovies = await widget.movieService.getMovies(limit: 30);
      setState(() {
        movies = loadedMovies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void toggleFavorite(int movieId) {
    setState(() {
      favorites.contains(movieId)
          ? favorites.remove(movieId)
          : favorites.add(movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎬 Films récents',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 22, 28),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadMovies,
          ),
          IconButton(
            icon: const Icon(Icons.quiz, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenreQuizPage(allMovies: movies),
                ),
              );

              if (result != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizResultsPage(
                      topGenres: result['genres'],
                      recommendedMovies: result['movies'],
                      genreScores: result['scores'],
                    ),
                  ),
                );
              }
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FavoritesPage(
                      movieService: widget.movieService,
                      favorites: favorites,
                      movies: movies,
                      toggleFavorite: toggleFavorite,
                    ),
                  ),
                ),
              ),
              if (favorites.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${favorites.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMovies,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 59, 137, 192),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => MovieListCard(
                movieService: widget.movieService,
                movie: movies[index],
                isFavorite: favorites.contains(movies[index].id),
                onFavoriteTap: () => toggleFavorite(movies[index].id),
              ),
            ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  final MovieService movieService;
  final MovieListItem movie;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final IconData? favoriteIcon;

  const MovieListCard({
    super.key,
    required this.movieService,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.favoriteIcon,
  });

  // Génère une couleur basée sur la première lettre du titre
  Color _getColorFromLetter(String title) {
    if (title.isEmpty) return Colors.grey;

    final letter = title[0].toUpperCase();
    final colorIndex = letter.codeUnitAt(0) % 10;

    const colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.brown,
    ];

    return colors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MovieDetailPage(movieService: movieService, movieId: movie.id),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          padding: const EdgeInsets.all(8),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Image du poster au lieu de la lettre
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.poster,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 120,
                          decoration: BoxDecoration(
                            color: _getColorFromLetter(movie.title),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              movie.title.isNotEmpty
                                  ? movie.title[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Année : ${movie.year}',
                            style: const TextStyle(
                              color: Color.fromARGB(179, 236, 236, 236),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      favoriteIcon ??
                          (isFavorite ? Icons.favorite : Icons.favorite_border),
                      color: isFavorite && favoriteIcon == null
                          ? Colors.red
                          : Colors.white,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
