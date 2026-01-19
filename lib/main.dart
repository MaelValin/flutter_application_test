import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profil.dart';
import 'quizz.dart';
import 'FilmPage.dart';
import 'services/film_service.dart';
import 'services/favorite_service.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteService = FavoriteService();
    
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.barlowTextTheme()),
      title: 'Flutter Demo',
      // home: const PortfolioPage(),
      // home: const QuizPage(),
      home: FilmPage(
        movieService: MovieService(), 
        favoriteService: favoriteService,
      ),
      

    );
  }
}