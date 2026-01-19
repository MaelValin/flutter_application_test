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

## 📝 Fonctionnement du Quiz

1. L'utilisateur lit la question affichée
2. Il sélectionne une réponse parmi les choix proposés
3. La réponse sélectionnée est mise en surbrillance
4. Le bouton "Suivant" se débloque
5. L'utilisateur clique sur "Suivant" pour valider
6. Le score est mis à jour si la réponse est correcte
7. La question suivante s'affiche
8. À la fin, l'écran de résultat affiche le score avec un message personnalisé
9. Possibilité de recommencer le quiz

## 🎯 Points techniques importants

- **État local** : Utilisation de `StatefulWidget` pour gérer l'état du quiz
- **Listes dynamiques** : Génération dynamique des boutons de réponses
- **Conditions d'affichage** : Bouton "Suivant" activé conditionnellement
- **Réinitialisation** : Reset du quiz après complétion

## 📸 Assets

```
assets/
└── images/
    ├── logo.png           # Logo pour splash screen (standard)
    ├── logo-blanc.png     # Logo pour splash screen (Android 12+)
    ├── background.png     # Image de fond du profil
    ├── profil.png         # Photo de profil
    └── qrcode.png         # QR Code YouTube
```

## 🔧 Configuration

### Splash Screen
Le splash screen est configuré dans `pubspec.yaml` avec :
- Couleur de fond : #232323
- Image : logo blanc
- Mode plein écran activé
- Support Android 12+ avec configuration spécifique

## 📱 Plateformes supportées

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ Linux
- ✅ macOS

## 📄 Licence

Ce projet est un travail académique réalisé dans le cadre d'un cours universitaire.

---

**Dernière mise à jour** : Janvier 2026
