import 'package:flutter/material.dart';
import 'services/film_service.dart';
import 'services/favorite_service.dart';
import 'composant/video_player_dialog.dart';

class FavoritePage extends StatelessWidget {
  final FavoriteService favoriteService;
  final List<Movie> allMovies;

  const FavoritePage({
    super.key,
    required this.favoriteService,
    required this.allMovies,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = favoriteService.getFavorites(allMovies);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        
        title: const Text('❤️ Mes Favoris', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 20, 22, 28),
      ),
      backgroundColor: Color.fromARGB(255, 35, 35, 35),
      body: favoriteMovies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun favori',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des films à vos favoris',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
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
                          Color.fromARGB(255, 130, 26, 26),
                          Color.fromARGB(255, 192, 59, 59),
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
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                favoriteService.toggleFavorite(movie);
                                // Force le rebuild en remontant dans l'arbre
                                (context as Element).markNeedsBuild();
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
