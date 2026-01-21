# 🎬 TP3 - Application Visualisation de Films

## 📱 Description du projet

Application mobile développée dans le cadre du **TP3 - Application Visualisation de Films** pour le cours de développement d'applications mobiles (S6). Cette application Flutter permet de parcourir des films récents via l'API Watchmode, consulter leurs détails complets, gérer une liste de favoris et visionner les bandes-annonces.

## 👨‍🎓 Informations

- **Étudiant** : Mael Valin
- **Semestre** : S6
- **Cours** : Développement d'applications mobiles
- **Travail** : TP3 - Application de gestion de films avec API

## ✨ Fonctionnalités principales

### 🎬 Liste des Films (Page principale)
- **Chargement API** : Récupération de films récents depuis l'API Watchmode avec Dio
- **Gestion des états** : Affichage clair des états de chargement, erreur et succès
- **Première lettre colorée** : Avatar avec la première lettre du titre et couleur générée automatiquement
- **Système de favoris** : 
  - Ajout/retrait de films en favoris d'un simple clic
  - Badge avec compteur de favoris dans l'AppBar
  - Icône cœur qui change de couleur selon l'état
- **Gestion des erreurs** : 
  - Messages d'erreur clairs et explicites
  - Bouton "Réessayer" pour relancer les appels API
  - Validation de la clé API au démarrage
- **Navigation fluide** : Accès rapide aux détails et aux favoris

### 📄 Page Détails d'un Film
- **Chargement dynamique** : Second appel API pour récupérer toutes les informations complètes
- **Affichage riche** : 
  - Poster haute résolution (ou placeholder si indisponible)
  - Titre et année de sortie
  - Note utilisateur (user_rating) avec icône étoile
  - Liste des genres sous forme de chips
  - Synopsis complet (plot_overview)
- **Bande-annonce YouTube** : 
  - Bouton pour ouvrir la bande-annonce si disponible
  - Lancement via `url_launcher` dans l'application YouTube
  - Gestion des erreurs si le lien est invalide
- **Gestion des états** : Loading, erreur et succès avec messages clairs

### ❤️ Page Favoris
- **Collection personnelle** : Tous les films marqués comme favoris
- **Gestion facilitée** : Retrait rapide des favoris
- **Navigation vers détails** : Accès aux détails complets depuis les favoris
- **État synchronisé** : Mise à jour en temps réel entre les pages

## 🛠️ Technologies utilisées

- **Flutter** : Framework de développement cross-platform
- **Dart** : Langage de programmation
- **Dio** : Client HTTP performant pour les appels API REST
- **Watchmode API** : API de films pour récupérer les données (liste et détails)
- **Google Fonts** : Typographie personnalisée (Barlow)
- **Font Awesome Flutter** : Bibliothèque d'icônes vectorielles
- **URL Launcher** : Ouverture des bandes-annonces YouTube dans l'app externe
- **YouTube Player Flutter** : Lecteur vidéo intégré pour les bandes-annonces
- **Flutter Native Splash** : Gestion du splash screen

## 📦 Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  dio: ^5.4.0                          # Client HTTP pour API
  url_launcher: ^6.3.2                 # Ouverture liens externes
  share_plus: ^12.0.1                  # Partage de contenu
  font_awesome_flutter: ^10.12.0       # Icônes
  google_fonts: ^7.0.2                 # Fonts personnalisées
  flutter_native_splash: ^2.4.7        # Splash screen
  youtube_player_flutter: ^9.0.3       # Lecteur YouTube
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

## 🔑 Configuration de la clé API Watchmode

### Obtenir une clé API
1. Inscris-toi sur [Watchmode API](https://api.watchmode.com/)
2. Récupère ta clé API gratuite (100 requêtes/jour)

### Utiliser la clé API

#### En ligne de commande
```bash
flutter run --dart-define=WATCHMODE_API_KEY=ta_clé_api_ici
```

#### Dans VS Code
Crée un fichier `.vscode/launch.json` à la racine du projet :

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Development)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=WATCHMODE_API_KEY=ta_clé_api_ici"
      ]
    }
  ]
}
```

#### Dans Android Studio
- Va dans **Run** → **Edit Configurations**
- Dans **Additional run args**, ajoute : `--dart-define=WATCHMODE_API_KEY=ta_clé_api_ici`

⚠️ **Important** : Ne jamais hardcoder la clé API dans le code source ! Utilise toujours `--dart-define` pour la sécurité.

## 🎯 Architecture et Patterns

### Modèles de données

#### `MovieListItem` (liste légère)
```dart
class MovieListItem {
  final int id;
  final String title;
  final int year;
}
```
Utilisé pour la liste principale. Contient uniquement les informations essentielles retournées par l'endpoint `/list-titles/`.

#### `Movie` (détails complets)
```dart
class Movie {
  final int id;
  final String title;
  final String plotOverview;
  final int year;
  final String? poster;
  final String? backdrop;
  final double userRating;
  final List<String> genreNames;
  final String? trailer;
}
```
Utilisé pour la page de détails. Contient toutes les informations complètes retournées par l'endpoint `/title/{id}/details/`.

### Services

#### `MovieService`
Gère tous les appels API vers Watchmode avec Dio :
- `getMovies({int limit})` : Récupère la liste des films récents
- `getMovieDetails(int movieId)` : Récupère les détails complets d'un film
- Validation de la clé API
- Gestion des erreurs réseau

### Architecture en 2 appels API

**Pourquoi 2 appels ?**
1. **Premier appel** (`/list-titles/`) : Rapide, retourne uniquement id, title, year
2. **Second appel** (`/title/{id}/details/`) : Plus lourd, retourne toutes les infos (poster, synopsis, genres, note, trailer)

**Avantages** :
- ✅ Liste chargée rapidement
- ✅ Économie de bande passante
- ✅ Détails chargés uniquement quand nécessaire
- ✅ Meilleure expérience utilisateur

### Gestion des états
Chaque page utilise 3 états distincts :
- `isLoading` : Affiche un CircularProgressIndicator
- `errorMessage` : Affiche l'erreur avec bouton "Réessayer"
- `données chargées` : Affiche le contenu

### Pages

- **MovieListPage** : Liste principale avec favoris et navigation
- **MovieDetailPage** : Détails complets avec chargement dynamique
- **FavoritesPage** : Liste filtrée des films favoris

### Composants réutilisables
- **MovieListCard** : Card de film avec avatar coloré et bouton favori
- **VideoPlayerDialog** : Dialog modal pour la lecture YouTube (si utilisé)

## 🚀 Installation et utilisation

### Prérequis
- Flutter SDK (version 3.10.7 ou supérieure)
- Dart SDK
- Un émulateur Android/iOS ou un appareil physique
- Clé API Watchmode (gratuite)

### Installation

1. **Cloner le projet**
```bash
git clone <url-du-repo>
cd flutter_application_test
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Générer le splash screen** (optionnel)
```bash
dart run flutter_native_splash:create
```

4. **Lancer l'application avec la clé API**
```bash
flutter run --dart-define=WATCHMODE_API_KEY=ta_clé_api_ici
```

5. **Build pour production** (optionnel)
```bash
# Android
flutter build apk --release --dart-define=WATCHMODE_API_KEY=ta_clé

# iOS
flutter build ios --release --dart-define=WATCHMODE_API_KEY=ta_clé

# Web
flutter build web --release --dart-define=WATCHMODE_API_KEY=ta_clé
```

## 🧭 Guide d'utilisation

### Navigation dans l'application

1. **Page Liste des Films** (Page d'accueil)
   - La liste se charge automatiquement au démarrage
   - Si erreur (pas de clé API, pas d'internet), message clair avec bouton "Réessayer"
   - Clique sur ❤️ pour ajouter/retirer des favoris
   - Clique sur un film pour voir ses détails complets
   - Icône refresh (🔄) pour recharger la liste
   - Badge avec compteur de favoris

2. **Page Détails**
   - Affichage du poster en grand format
   - Note, année, genres, synopsis complet
   - Bouton "Voir la bande-annonce" (si disponible) → ouvre YouTube
   - Bouton retour pour revenir à la liste

3. **Page Favoris**
   - Accès via l'icône ❤️ dans l'AppBar
   - Liste de tous les films favoris
   - Clique sur un film pour voir ses détails
   - Clique sur ❤️ pour retirer des favoris

### Astuces
- 💡 Les favoris sont stockés en mémoire (perdus à la fermeture de l'app)
- 💡 Les détails sont chargés à la demande (économie de bande passante)
- 💡 La première lettre du titre génère une couleur unique pour l'avatar
- 💡 Utilise le bouton refresh si la liste ne se charge pas

## 📂 Structure du projet

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── models/
│   └── movie.dart              # MovieListItem et Movie
├── services/
│   └── movie_service.dart      # Appels API Watchmode avec Dio
├── pages/
│   ├── movie_list_page.dart    # Liste des films avec favoris
│   ├── movie_detail_page.dart  # Détails complets d'un film
│   └── favorites_page.dart     # Page des favoris
└── composant/
    ├── movie_list_card.dart    # Widget card pour liste
    └── video_player_dialog.dart # Lecteur YouTube (optionnel)

assets/
└── images/
    ├── logo.png               # Logo standard
    └── logo-blanc.png         # Logo splash screen
```

**Note** : Plus de fichier JSON local, toutes les données viennent de l'API Watchmode.

## 🎨 Design et UX

### Palette de couleurs
- **Fond principal** : `#FFFFFF` (Blanc) / `#232323` (Gris foncé en mode sombre)
- **Cards** : Blanc avec ombres légères
- **Avatar première lettre** : 10 couleurs générées automatiquement selon la lettre
- **Accent** : `#FF0000` (Rouge pour les favoris)
- **Texte** : `#000000` (Noir) et variations de gris

### Composants UI
- **CircleAvatar coloré** : Première lettre du titre avec couleur unique
- **ListTile** : Design simple et efficace pour la liste
- **Chips** : Affichage des genres dans les détails
- **Badge favoris** : Compteur dans l'AppBar
- **Boutons d'action** : ElevatedButton pour les actions principales

### Expérience utilisateur
- **États de chargement** : CircularProgressIndicator pendant les appels API
- **Gestion d'erreur** : Messages clairs avec bouton "Réessayer"
- **Navigation intuitive** : Boutons clairs et accessibles
- **Responsive** : Adaptation à toutes les tailles d'écran
- **Feedback visuel** : InkWell ripple effect sur les interactions

## 🎯 Points techniques avancés

### Gestion d'état
- **StatefulWidget** : Gestion de l'état local (isLoading, errorMessage, données)
- **setState()** : Mise à jour réactive de l'interface
- **Callbacks** : Communication entre widgets (toggleFavorite)
- **Set<int>** : Stockage efficace des IDs favoris (pas de doublons)

### Appels API avec Dio
- **Dio instance** : Client HTTP réutilisable
- **Query parameters** : Passage de apiKey, limit, types
- **Try-Catch** : Gestion robuste des erreurs réseau
- **Async/Await** : Gestion asynchrone des requêtes
- **String.fromEnvironment()** : Variables de compilation sécurisées

### Performance
- **ListView.builder** : Construction optimisée des listes longues
- **Image.network** : Chargement asynchrone des images avec cache
- **ErrorBuilder** : Placeholder en cas d'erreur de chargement d'image
- **Chargement lazy** : Détails chargés uniquement à la demande
- **Modèles séparés** : MovieListItem (léger) vs Movie (complet)

### Widgets avancés
- **InkWell** : Rend les ListTile cliquables avec ripple effect
- **CircleAvatar** : Avatar rond avec première lettre colorée
- **Chip** : Affichage compact des genres
- **ElevatedButton.icon** : Bouton avec icône et texte
- **SingleChildScrollView** : Scroll pour contenus longs

### Navigation
- **Navigator.push/pop** : Navigation entre les pages
- **MaterialPageRoute** : Transitions animées natives
- **Passage d'ID** : Navigation vers détails avec movieId uniquement

## 🧪 Tests (à implémenter)

### Tests unitaires
- **MovieService** :
  - Test de `getMovies()` avec réponse valide
  - Test de gestion d'erreur si clé API manquante
  - Test de parsing JSON vers MovieListItem
  - Test de `getMovieDetails()` avec réponse valide

### Tests de widgets
- **MovieListPage** :
  - Test d'affichage du CircularProgressIndicator pendant le chargement
  - Test d'affichage de la liste après chargement réussi
  - Test d'affichage du message d'erreur en cas d'échec
  - Test du bouton "Réessayer"
  - Test d'ajout/retrait de favoris
- **MovieDetailPage** :
  - Test de chargement des détails
  - Test d'affichage des informations (poster, note, genres, synopsis)
  - Test du bouton bande-annonce

Exemple de structure de test :
```dart
test('getMovies retourne une liste de films', () async {
  final service = MovieService();
  final movies = await service.getMovies(limit: 10);
  expect(movies, isA<List<MovieListItem>>());
  expect(movies.length, lessThanOrEqualTo(10));
});
```
## 🔧 Configuration avancée

### Splash Screen
Configuration dans `pubspec.yaml` :
```yaml
flutter_native_splash:
  color: "#232323"
  image: assets/images/logo-blanc.png
  android_12:
    image: assets/images/logo-blanc.png
    color: "#232323"
  fullscreen: true
```

### Favoris (en mémoire)
Les favoris sont actuellement stockés en mémoire avec un `Set<int>` :
```dart
final Set<int> favorites = {}; // IDs des films favoris
```
⚠️ **Note** : Les favoris sont perdus à la fermeture de l'app (pas de persistance pour l'instant).

## 🐛 Dépannage

### Problèmes courants

**Erreur "Clé API manquante"**
```
Exception: Clé API manquante ! Lance l'app avec --dart-define=WATCHMODE_API_KEY=ta_clé
```
- **Solution** : Lance l'app avec `flutter run --dart-define=WATCHMODE_API_KEY=ta_clé`
- Vérifie que tu as bien configuré la clé dans `.vscode/launch.json` ou Android Studio

**Les films ne se chargent pas**
- Vérifie ta connexion internet
- Vérifie que ta clé API Watchmode est valide
- Clique sur le bouton "Réessayer" si l'erreur persiste
- Regarde les logs dans le terminal pour plus de détails

**Les images ne se chargent pas**
- Les URLs de posters peuvent être null pour certains films
- L'app affiche un placeholder (icône film grise) en cas d'erreur
- Vérifie ta connexion internet

**Erreur de build**
```bash
# Nettoyez et régénérez
flutter clean
flutter pub get
flutter run --dart-define=WATCHMODE_API_KEY=ta_clé
```

**Erreur Dio "DioException"**
- Problème de connexion réseau
- API Watchmode peut être temporairement indisponible
- Limite de requêtes API dépassée (100/jour en gratuit)

## 📱 Plateformes supportées

- ✅ **Android** : Testé sur Android 8.0+
- ✅ **iOS** : Compatible iOS 12.0+
- ⚠️ **Web** : Fonctionnel mais CORS peut bloquer les requêtes API
- ✅ **Windows** : Support desktop complet
- ✅ **Linux** : Compatible
- ✅ **macOS** : Support natif

## 🎯 Checklist des fonctionnalités du TP

### ✅ Objectifs complétés
- [x] Charger des films depuis l'API Watchmode avec Dio
- [x] Afficher une liste de films récents avec première lettre colorée et favoris
- [x] Gérer les états de chargement et d'erreur sur toutes les pages avec messages clairs et bouton réessayer
- [x] Faire un second appel API pour charger les détails complets (poster, synopsis, note, genres)
- [x] Afficher une page de détails riche avec toutes les informations du film
- [x] Gérer les favoris avec navigation entre liste principale et favoris
- [x] Respecter les bonnes pratiques (extraction de widgets, gestion d'erreurs, instance globale du service)

### 🔄 À implémenter
- [ ] Tests unitaires pour MovieService
- [ ] Tests de widgets pour MovieListPage et MovieDetailPage
- [ ] Persistance des favoris avec SharedPreferences (optionnel)

## 📚 Concepts clés expliqués

### String.fromEnvironment()
Récupère une variable passée via `--dart-define`. Permet de ne pas hardcoder les secrets dans le code.

### Deux modèles séparés
- `MovieListItem` : Léger (id, title, year) pour la liste
- `Movie` : Complet (+ poster, genres, synopsis, note) pour les détails
- **Avantage** : Économie de bande passante et chargement rapide

### Gestion des 3 états
1. `isLoading = true` → Affiche CircularProgressIndicator
2. `errorMessage != null` → Affiche erreur + bouton "Réessayer"
3. Données chargées → Affiche le contenu

### Nullable types (?)
`String?` signifie que la valeur peut être `null`. Certains films n'ont pas de poster ou trailer.

### Opérateurs null-safe
- `?.` : Appelle la méthode uniquement si non-null
- `??` : Retourne la valeur de droite si la gauche est null
- `!` : Force l'accès (crash si null, à utiliser avec précaution)

## 📄 Licence

Ce projet est un travail académique réalisé dans le cadre d'un cours universitaire (S6 - 2026).

---

**Développé avec** ❤️ **et Flutter**

**Dernière mise à jour** : Janvier 2026  
**Version** : 1.0.0

**Screens**

<img src="screen app/film1.png">
<img src="screen app/film2.png">