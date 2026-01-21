import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_list_page.dart';

class FavoritesPage extends StatelessWidget {
  final MovieService movieService;
  final Set<int> favorites;
  final List<MovieListItem> movies;
  final Function(int) toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.movieService,
    required this.favorites,
    required this.movies,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = movies.where((movie) => favorites.contains(movie.id)).toList();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('❤️ Mes favoris', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 20, 22, 28),
      ),
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
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
                    'Aucun favori pour le moment',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des films à vos favoris !',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) => MovieListCard(
                movieService: movieService,
                movie: favoriteMovies[index],
                isFavorite: true,
                onFavoriteTap: () => toggleFavorite(favoriteMovies[index].id),
                favoriteIcon: Icons.delete,
              ),
            ),
    );
  }
}
