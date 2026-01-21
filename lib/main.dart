import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profil.dart';
import 'quizz.dart';
import 'FilmPage.dart';
import 'services/film_service.dart';
import 'services/favorite_service.dart';
import 'services/movie_service.dart' as movie_service;
import 'pages/movie_list_page.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instance globale du service MovieService
    final movieService = movie_service.MovieService();
    final favoriteService = FavoriteService();
    
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.barlowTextTheme()),
      title: 'Flutter Demo',
      // home: const PortfolioPage(),
      // home: const QuizPage(),
      // Ancienne page (peut être commentée si vous voulez garder)
      // home: FilmPage(
      //   movieService: MovieService(), 
      //   favoriteService: favoriteService,
      // ),
      
      // Nouvelle page avec API Watchmode
      home: MovieListPage(movieService: movieService),
    );
  }
}