import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'partie_service.dart';
import 'accueil_page.dart';
import 'jeu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final partieService = PartieService();
  await partieService.charger();
  runApp(MyApp(partieService: partieService));
}

class MyApp extends StatelessWidget {
  final PartieService partieService;

  const MyApp({super.key, required this.partieService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: partieService,
      child: MaterialApp(
        title: 'Loup-Garou - Maître du Jeu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1A237E),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1A237E),
            secondary: Color(0xFFFFD700),
            surface: Color(0xFF283593),
            background: Color(0xFF1A237E),
          ),
          cardTheme: const CardThemeData(
            color: Color(0xFF283593),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: Color(0xFFFFD700), width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: const Color(0xFF1A237E),
              elevation: 4,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AccueilPage(),
          '/jeu': (context) => const JeuPage(),
        },
      ),
    );
  }
}
