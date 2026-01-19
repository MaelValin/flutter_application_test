import 'package:flutter/material.dart';
import 'models.dart';
import 'composant/question_text.dart';
import 'services/film_service.dart';
import 'services/favorite_service.dart';
import 'FavoritePage.dart';
import 'composant/video_player_dialog.dart';

class FilmPage extends StatefulWidget {
  final MovieService movieService;
  final FavoriteService favoriteService;

  const FilmPage({
    super.key,
    required this.movieService,
    required this.favoriteService,
  });

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final loadedMovies = await widget.movieService.loadLocalMovies();
    setState(() => movies = loadedMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Film', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 20, 22, 28),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritePage(
                        favoriteService: widget.favoriteService,
                        allMovies: movies,
                      ),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              if (widget.favoriteService.favoriteCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${widget.favoriteService.favoriteCount}',
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
      backgroundColor: Color.fromARGB(255, 35, 35, 35),

      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
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
                          content: Text('Aucune vidéo disponible pour ce film'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Card(
                    child: Container(
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
                    padding: const EdgeInsets.all(8),

                    child: Container(
                      height: 175,
                      padding: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Row(
                            children: [
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
                                    color: const Color.fromARGB(255, 71, 71, 71),
                                    child: const Icon(
                                      Icons.movie,
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      movie.year.toString(),
                                      style: const TextStyle(
                                        color: Color.fromARGB(179, 236, 236, 236),
                                      ),
                                    ),

                                    const SizedBox(height: 4),
                                    
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          movie.description,
                                          style: const TextStyle(
                                            color: Color.fromARGB(179, 207, 207, 207),
                                            fontSize: 8,
                                          ),
                                        ),
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
                                widget.favoriteService.isFavorite(movie)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: widget.favoriteService.isFavorite(movie)
                                    ? Colors.red
                                    : Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.favoriteService.toggleFavorite(movie);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                );
              },
            ),
    );
  }
}
