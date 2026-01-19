# 🎬 Application Films & Quiz - Flutter

## 📱 Description du projet

Application mobile complète développée dans le cadre du cours de développement d'applications mobiles (S6). Cette application Flutter combine une bibliothèque de films interactive avec un système de recommandation basé sur un quiz de préférences personnalisé.

## 👨‍🎓 Informations

- **Étudiant** : Mael Valin
- **Semestre** : S6
- **Cours** : Développement d'applications mobiles
- **Travail** : Application de gestion de films avec système de recommandation

## ✨ Fonctionnalités principales

### 🎬 Page Films (Page principale)
- **Catalogue de films** : Liste de 15 films avec affiches, années et descriptions
- **Design moderne** : Cards avec dégradés bleus et mise en page élégante
- **Système de favoris** : 
  - Ajout/retrait de films en favoris d'un simple clic
  - Badge avec compteur de favoris dans l'AppBar
  - Icône cœur qui change de couleur selon l'état
- **Lecteur vidéo intégré** : 
  - Appui long sur un film pour voir sa bande-annonce
  - Lecteur WebView intégré pour YouTube
  - Dialog modal avec contrôles de lecture
- **Navigation fluide** : Accès rapide aux favoris et au quiz

### 🎯 Quiz de Recommandation de Genre
- **Quiz intelligent** : 5 questions pour déterminer les préférences de genre
- **8 genres analysés** : 
  - Action
  - Science-Fiction
  - Drame
  - Aventure
  - Romance
  - Thriller
  - Animation
  - Comédie
- **Système de points** : Algorithme de scoring sophistiqué pour chaque réponse
- **Barre de progression** : Suivi visuel de l'avancement du quiz
- **Interface intuitive** : Boutons stylisés avec feedback visuel

### 🏆 Page de Résultats du Quiz
- **Top 3 des genres** : Affichage des genres préférés avec scores
- **Recommandations personnalisées** : 3 films suggérés selon les préférences
- **Podium visuel** : Badges or, argent, bronze pour le classement
- **Détails des films** : Affiches, descriptions et années
- **Actions disponibles** :
  - Visualisation des bandes-annonces (appui long)
  - Possibilité de refaire le quiz
- **Design attractif** : Gradient matching avec le thème de l'app

### ❤️ Page Favoris
- **Collection personnelle** : Tous les films marqués comme favoris
- **Gestion facilitée** : Retrait rapide des favoris
- **Interface cohérente** : Même design que la page principale
- **État synchronisé** : Mise à jour en temps réel

### 👤 Page Profil
- **En-tête personnalisé** : Photo de profil et image de fond
- **Informations personnelles** : Nom, date de naissance, ville, profession
- **QR Code** : Lien vers contenu externe
- **Technologies** : Affichage des compétences techniques

### 🎨 Splash Screen
- **Splash screen professionnel** : Logo sur fond sombre (#232323)
- **Support Android 12+** : Configuration adaptée aux nouvelles versions
- **Mode plein écran** : Expérience immersive au démarrage

## 🛠️ Technologies utilisées

- **Flutter** : Framework de développement cross-platform
- **Dart** : Langage de programmation
- **Google Fonts** : Typographie personnalisée (Barlow)
- **Font Awesome Flutter** : Bibliothèque d'icônes vectorielles
- **URL Launcher** : Ouverture de liens externes
- **Share Plus** : Partage de contenu sur les réseaux sociaux
- **Flutter Native Splash** : Gestion professionnelle du splash screen
- **Flutter InAppWebView** : Lecteur vidéo intégré pour les bandes-annonces
- **Path Provider** : Gestion du stockage local des favoris

## 📦 Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  url_launcher: ^6.3.2
  share_plus: ^12.0.1
  font_awesome_flutter: ^10.12.0
  google_fonts: ^7.0.2
  flutter_native_splash: ^2.4.7
  flutter_inappwebview: ^6.0.0
  path_provider: ^2.1.1
```

## 🎯 Architecture et Patterns

### Services
- **MovieService** : Gestion du chargement des films depuis JSON
- **FavoriteService** : Gestion des favoris avec persistance locale

### Models
- **Movie** : Modèle de données pour les films (titre, année, poster, description, vidéo)
- **Question & Answer** : Modèles pour le système de quiz
- **QuizQuestion & QuizOption** : Modèles pour le quiz de genres

### Pages
- **FilmPage** : Page principale avec la liste des films
- **FavoritePage** : Page dédiée aux films favoris
- **GenreQuizPage** : Quiz interactif pour déterminer les préférences
- **QuizResultsPage** : Affichage des résultats et recommandations
- **ProfilPage** : Page de profil utilisateur

### Composants réutilisables
- **VideoPlayerDialog** : Dialog modal pour la lecture des bandes-annonces
- **question_text** : Widget personnalisé pour l'affichage des questions

## 🚀 Installation et utilisation

### Prérequis
- Flutter SDK (version 3.10.7 ou supérieure)
- Dart SDK
- Un émulateur Android/iOS ou un appareil physique

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

3. **Générer le splash screen**
   ```bash
   dart run flutter_native_splash:create
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```

5. **Build pour production** (optionnel)
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web --release
   ```

## 🎮 Guide d'utilisation

### Navigation dans l'application

1. **Page Films** (Page d'accueil)
   - Parcourez la liste des films disponibles
   - Appuyez sur ❤️ pour ajouter aux favoris
   - **Appui long** sur un film pour voir sa bande-annonce
   - Cliquez sur le bouton **?** pour lancer le quiz de recommandation

2. **Quiz de Genre**
   - Répondez aux 5 questions sur vos préférences
   - Suivez la barre de progression
   - Consultez vos résultats et recommandations personnalisées

3. **Page Favoris**
   - Accédez à vos films favoris via l'icône ❤️
   - Le badge indique le nombre de favoris
   - Cliquez à nouveau sur ❤️ pour retirer un favori

4. **Bandes-annonces**
   - Maintenez appuyé sur n'importe quel film
   - Le lecteur vidéo s'ouvre automatiquement
   - Fermez avec le bouton X ou retour

### Astuces
- 💡 Le compteur de favoris se met à jour en temps réel
- 💡 Vous pouvez refaire le quiz autant de fois que vous voulez
- 💡 Les favoris sont sauvegardés localement et persistent après fermeture

## 📂 Structure du projet

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── FilmPage.dart               # Page principale avec la liste des films
├── FavoritePage.dart           # Page des films favoris
├── profil.dart                 # Page de profil utilisateur
├── quizz.dart                  # Quiz personnel (legacy)
├── genre_quiz_page.dart        # Quiz de recommandation de genres
├── quiz_results_page.dart      # Page de résultats du quiz
├── models.dart                 # Modèles de base (Question, Answer)
├── composant/
│   ├── question_text.dart      # Widget texte de question
│   └── video_player_dialog.dart # Dialog de lecture vidéo
└── services/
    ├── film_service.dart       # Service de gestion des films
    └── favorite_service.dart   # Service de gestion des favoris

assets/
├── data/
│   └── filmdata.json          # Base de données des films
└── images/
    ├── logo.png               # Logo standard
    ├── logo-blanc.png         # Logo splash screen
    ├── background.png         # Image de fond profil
    ├── profil.png            # Photo de profil
    └── qrcode.png            # QR Code
```

## 🎨 Design et UX

### Palette de couleurs
- **Fond principal** : `#232323` (Gris très foncé)
- **Fond secondaire** : `#141620` (Bleu-noir pour l'AppBar)
- **Gradient principal** : `#1A2482` → `#3B89C0` (Bleu foncé vers bleu clair)
- **Accent** : `#FF0000` (Rouge pour les favoris)
- **Texte** : `#FFFFFF` (Blanc) et variations de gris

### Composants UI
- **Cards avec gradients** : Effet de profondeur avec dégradés bleus
- **Badges interactifs** : Compteurs de favoris avec animations
- **Boutons stylisés** : Bordures colorées et feedback visuel au clic
- **Icons contextuelles** : Font Awesome et Material Icons
- **Transitions fluides** : Navigation avec animations natives

### Expérience utilisateur
- **Feedback immédiat** : Changements visuels instantanés (favoris, sélections)
- **Navigation intuitive** : Boutons clairs et accessibles
- **Gestes naturels** : Appui long pour les bandes-annonces
- **Messages informatifs** : SnackBars et dialogs pour guider l'utilisateur
- **Responsive** : Adaptation à toutes les tailles d'écran

## 📝 Fonctionnement du système de recommandation

### Algorithme de quiz
1. **Collection des préférences** : 5 questions ciblées sur les goûts de l'utilisateur
2. **Système de points pondérés** : 
   - Chaque réponse attribue des points à plusieurs genres
   - Points principaux (3) pour le genre principal
   - Points secondaires (1-2) pour les genres associés
3. **Calcul des scores** : Accumulation des points par genre
4. **Sélection du Top 3** : Tri et sélection des 3 genres avec les meilleurs scores

### Matching des films
1. **Base de données enrichie** : Chaque film est tagué avec 2-3 genres
2. **Calcul de correspondance** :
   - Score de 3 points pour le 1er genre préféré
   - Score de 2 points pour le 2ème genre préféré
   - Score de 1 point pour le 3ème genre préféré
3. **Classement intelligent** : Les films sont triés par score de correspondance
4. **Top 3 recommandations** : Sélection des 3 films les plus pertinents

### Exemple de mapping
```dart
'Inception': ['Science-Fiction', 'Thriller', 'Action']
'The Matrix': ['Science-Fiction', 'Action', 'Thriller']
'Forrest Gump': ['Drame', 'Romance', 'Comédie']
```

## 🎬 Catalogue de films

L'application inclut 15 films cultes :
- **Inception** (2010) - Science-Fiction, Thriller
- **Interstellar** (2014) - Science-Fiction, Aventure
- **The Dark Knight** (2008) - Action, Thriller
- **The Matrix** (1999) - Science-Fiction, Action
- **Pulp Fiction** (1994) - Thriller, Drame
- **Forrest Gump** (1994) - Drame, Romance
- **The Shawshank Redemption** (1994) - Drame
- **Gladiator** (2000) - Action, Aventure
- **Avatar** (2009) - Science-Fiction, Action
- **Titanic** (1997) - Romance, Drame
- **The Avengers** (2012) - Action, Science-Fiction
- **Jurassic Park** (1993) - Science-Fiction, Aventure
- **The Lord of the Rings** (2001) - Aventure, Fantasy
- **Spider-Man: No Way Home** (2021) - Action, Science-Fiction
- **Oppenheimer** (2023) - Drame, Thriller

Chaque film comprend :
- Titre et année de sortie
- Affiche haute qualité (TMDB)
- Description détaillée
- Lien vers la bande-annonce YouTube

## 🎯 Points techniques avancés

### Gestion d'état
- **StatefulWidget** : Gestion de l'état local pour les pages interactives
- **setState()** : Mise à jour réactive de l'interface
- **Callbacks** : Communication entre widgets parent-enfant
- **Navigation state** : Préservation de l'état lors des transitions

### Persistance des données
- **SharedPreferences** : Sauvegarde locale des favoris
- **JSON parsing** : Chargement et désérialisation des données films
- **Async/Await** : Gestion asynchrone du chargement des données

### Performance
- **ListView.builder** : Construction optimisée des listes longues
- **Image.network** : Chargement asynchrone des images avec cache
- **ErrorBuilder** : Gestion gracieuse des erreurs de chargement
- **Lazy loading** : Chargement à la demande des ressources

### Widgets avancés
- **GestureDetector** : Détection des interactions (tap, long press)
- **Dialog modal** : Affichage contextuel du lecteur vidéo
- **Stack & Positioned** : Superposition d'éléments (badges, overlays)
- **LinearProgressIndicator** : Suivi visuel de la progression

### Navigation
- **Navigator.push/pop** : Navigation entre les pages
- **MaterialPageRoute** : Transitions animées natives
- **Valeurs de retour** : Communication de données via navigation
- **Callbacks post-navigation** : Rafraîchissement après retour

## 💡 Fonctionnalités à venir (Roadmap)

- [ ] Recherche et filtres de films
- [ ] Tri par année, titre, genre
- [ ] Notes et avis utilisateurs
- [ ] Liste de visionnage (watchlist)
- [ ] Synchronisation cloud des favoris
- [ ] Mode clair/sombre
- [ ] Partage de recommandations
- [ ] Intégration API TMDB pour plus de films
- [ ] Notifications de sorties cinéma
- [ ] Mode hors-ligne complet

## 📸 Assets et ressources

### Structure des assets
```
assets/
├── data/
│   └── filmdata.json      # Base de données des 15 films
└── images/
    ├── logo.png           # Logo standard
    ├── logo-blanc.png     # Logo splash screen (Android 12+)
    ├── background.png     # Image de fond profil
    ├── profil.png         # Photo de profil
    └── qrcode.png         # QR Code
```

### Sources des images
- **Affiches de films** : The Movie Database (TMDB) API
- **Bandes-annonces** : YouTube (liens directs)

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

### Favoris (SharedPreferences)
Les favoris sont stockés localement avec la clé `favorite_movies` :
```dart
// Format: Liste d'IDs de films
['Inception', 'The Matrix', 'Interstellar']
```

## 🐛 Dépannage

### Problèmes courants

**Les images ne se chargent pas**
- Vérifiez votre connexion internet
- Les URLs TMDB sont parfois bloquées par certains pare-feu
- Solution : L'app affiche une icône de secours en cas d'erreur

**Les vidéos ne se lancent pas**
- Assurez-vous que flutter_inappwebview est bien installé
- Sur iOS, vérifiez les permissions dans Info.plist
- Les vidéos nécessitent une connexion internet active

**Les favoris ne persistent pas**
- Vérifiez que path_provider est correctement installé
- Sur iOS, les permissions de stockage peuvent être requises
- Réinstallez l'app si le problème persiste

**Erreur de build**
```bash
# Nettoyez et régénérez
flutter clean
flutter pub get
flutter run
```

## 📱 Plateformes supportées

- ✅ **Android** : Testé sur Android 8.0+
- ✅ **iOS** : Compatible iOS 12.0+
- ✅ **Web** : Fonctionnel sur tous les navigateurs modernes
- ✅ **Windows** : Support desktop complet
- ✅ **Linux** : Compatible
- ✅ **macOS** : Support natif

## 🏆 Points forts du projet

### Techniques
- ✅ Architecture propre avec séparation des responsabilités (Services, Models, Pages)
- ✅ Gestion d'état efficace avec StatefulWidget
- ✅ Persistance des données locale
- ✅ Algorithme de recommandation intelligent
- ✅ Gestion des erreurs et états de chargement
- ✅ Code formaté et commenté

### Design
- ✅ Interface moderne et cohérente
- ✅ Thème sombre élégant
- ✅ Animations et transitions fluides
- ✅ Feedback visuel immédiat
- ✅ Responsive design

### Fonctionnalités
- ✅ Système de favoris persistant
- ✅ Quiz de recommandation interactif
- ✅ Lecteur vidéo intégré
- ✅ Navigation intuitive
- ✅ Expérience utilisateur soignée

## 📚 Apprentissages clés

- **Flutter & Dart** : Maîtrise des concepts fondamentaux
- **Architecture mobile** : Organisation et structure d'une app complète
- **Gestion d'état** : StatefulWidget, callbacks, navigation state
- **Persistance** : SharedPreferences, JSON, stockage local
- **UI/UX** : Design patterns, Material Design, animations
- **Services** : Création de services réutilisables
- **Algorithmes** : Système de scoring et recommandation
- **Async/Await** : Programmation asynchrone en Dart

## 👥 Contributeurs

- **Mael Valin** - Développement complet
- **Enseignants** - Encadrement et conseils

## 📄 Licence

Ce projet est un travail académique réalisé dans le cadre d'un cours universitaire (S6 - 2026).

## 🙏 Remerciements

- The Movie Database (TMDB) pour les affiches de films
- YouTube pour l'hébergement des bandes-annonces
- La communauté Flutter pour les packages open-source
- Les enseignants pour leur accompagnement

---

**Développé avec** ❤️ **et Flutter**

**Dernière mise à jour** : Janvier 2026  
**Version** : 1.0.0
