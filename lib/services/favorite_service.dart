import 'package:flutter/foundation.dart';
import 'film_service.dart';

class FavoriteService extends ChangeNotifier {
  final Set<String> _favoriteMovieTitles = {};

  bool isFavorite(Movie movie) {
    return _favoriteMovieTitles.contains(movie.title);
  }

  void toggleFavorite(Movie movie) {
    if (_favoriteMovieTitles.contains(movie.title)) {
      _favoriteMovieTitles.remove(movie.title);
    } else {
      _favoriteMovieTitles.add(movie.title);
    }
    notifyListeners();
  }

  List<Movie> getFavorites(List<Movie> allMovies) {
    return allMovies
        .where((movie) => _favoriteMovieTitles.contains(movie.title))
        .toList();
  }

  int get favoriteCount => _favoriteMovieTitles.length;
}
