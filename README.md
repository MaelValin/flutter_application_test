# TP2 - Application Quiz Flutter

## 📱 Description du projet

Application mobile développée dans le cadre du **TP2 - Création d'un Quiz** pour le cours de développement d'applications mobiles (S6). Cette application Flutter propose un quiz interactif avec un système de questions-réponses et un calcul de score.

## 👨‍🎓 Informations

- **Étudiant** : Mael Valin
- **Semestre** : S6
- **Cours** : Développement d'applications mobiles
- **Travail** : TP2 - Création d'un Quizz

## ✨ Fonctionnalités

### Quiz Interactif
- **Questions à choix multiples** : Questions sur des informations personnelles
- **Système de sélection** : Sélection visuelle d'une réponse avant validation
- **Bouton "Suivant"** : Débloqué uniquement après avoir sélectionné une réponse
- **Compteur de progression** : Affichage du nombre de questions (ex: "Questions : 1 / 4")
- **Calcul du score** : Score final affiché à la fin du quiz
- **Messages personnalisés** : Feedback adapté selon le score obtenu

### Page Portfolio
- **En-tête avec profil** : Photo de profil et image de fond
- **Carte d'informations** : Nom, date de naissance, ville, profession
- **Carte QR Code** : Lien vers YouTube
- **Icônes technologies** : Affichage des technologies maîtrisées

### Splash Screen
- **Splash screen personnalisé** : Logo blanc sur fond sombre (#232323)
- **Support Android 12+** : Configuration spécifique pour les nouvelles versions d'Android
- **Mode plein écran** : Masquage de la barre de notification

## 🛠️ Technologies utilisées

- **Flutter** : Framework de développement
- **Dart** : Langage de programmation
- **Google Fonts** : Typographie personnalisée (Barlow)
- **Font Awesome Flutter** : Bibliothèque d'icônes
- **URL Launcher** : Ouverture de liens externes
- **Share Plus** : Partage de contenu
- **Flutter Native Splash** : Gestion du splash screen

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
```

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
├── main.dart              # Point d'entrée de l'application
├── quizz.dart            # Page du quiz
├── profil.dart           # Page portfolio
├── models.dart           # Modèles de données (Question, Answer)
└── composant/
    └── question_text.dart # Widget texte de question
```

## 🎨 Design

- **Thème sombre** : Fond gris foncé (#232323)
- **Dégradés bleus** : Boutons avec gradient (bleu foncé vers bleu clair)
- **Feedback visuel** : 
  - Bordure blanche sur la réponse sélectionnée
  - Gradient inversé pour la réponse sélectionnée
  - Bouton "Suivant" grisé quand désactivé
- **Ombres portées** : Effet de profondeur sur les cartes et boutons

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

**Screen**

<img src="screen app/quizz1.png">
<img src="screen app/quizz2.png">