# 🐺 Loup-Garou - Application Maître du Jeu

## 📱 Description du projet

Application mobile complète développée pour faciliter le rôle du Maître du Jeu lors de parties de Loup-Garou. Cette application Flutter permet de gérer les joueurs, leurs rôles, l'ordre de jeu, les effets et de suivre l'évolution de la partie en temps réel.

## 👨‍🎓 Informations

- **Étudiant** : Mael Valin
- **Semestre** : S6
- **Cours** : Développement d'applications mobiles
- **Projet** : Application Loup-Garou pour Maître du Jeu

## ✨ Fonctionnalités principales

### 🏠 Page d'accueil
- **Design immersif** : Interface avec fond bleu et accents dorés
- **Nouvelle partie** : Bouton pour démarrer une nouvelle configuration
- **Continuer** : Reprise d'une partie en cours (sauvegarde automatique)
- **Logo animé** : Présentation professionnelle avec bordure dorée

### ⚙️ Configuration de la partie
- **Ajout de joueurs** : Formulaire simple avec nom et rôle
- **8 rôles disponibles** :
  - 🐺 Loup-Garou
  - 🔮 Voyante
  - 🧪 Sorcière
  - 🎯 Chasseur
  - 💘 Cupidon
  - 👧 Petite Fille
  - 🎭 Voleur
  - 👤 Villageois
- **Liste visuelle** : Affichage des joueurs avec leurs rôles
- **Validation** : Vérifications (minimum 4 joueurs, au moins 1 loup)
- **Suppression** : Possibilité de retirer un joueur

### 🎮 Page de jeu principale
- **Ordre de la nuit** : Affichage automatique de l'ordre de jeu des rôles
- **Phases de jeu** :
  - 🌙 Nuit : Tour des rôles spéciaux
  - ☀️ Jour : Discussion entre joueurs
  - 🗳️ Vote : Élimination d'un joueur
- **Gestion des joueurs** :
  - Carte expandable pour chaque joueur
  - Rôle visible en un coup d'œil
  - Statut vivant/mort
  - Badge amoureux (💕) si Cupidon actif
- **Actions disponibles** :
  - ➕ Ajouter un effet (protection, poison, vision, etc.)
  - ⚠️ Éliminer un joueur
  - 📝 Enregistrer des actions
- **Effets visuels** :
  - 🛡️ Protection (vert)
  - ☠️ Poison (rouge)
  - 👁️ Vision (violet)
  - 💕 Charme (rose)
  - 🎯 Cible (orange)
- **Système d'amoureux** : Gestion automatique (si l'un meurt, l'autre aussi)

### 🏆 Fin de partie
- **Détection automatique** : Victoire des loups ou des villageois
- **Écran de victoire** : Affichage du gagnant avec statistiques
- **Retour à l'accueil** : Nouvelle partie possible

### 💾 Persistance des données
- **Sauvegarde automatique** : L'état de la partie est sauvegardé en permanence
- **Reprise de partie** : Possibilité de fermer l'app et de reprendre plus tard
- **Historique des actions** : Toutes les actions sont enregistrées

## 🎨 Design et thème

### Palette de couleurs
- **Fond principal** : Dégradé bleu (`#1A237E` → `#283593`)
- **Accent doré** : `#FFD700` pour tous les boutons et bordures
- **Cartes** : `#283593` avec bordure dorée
- **Texte** : Blanc avec variations d'opacité

### Composants UI
- **Boutons dorés** : Style uniforme avec ombre portée
- **Cartes joueurs** : Effet de profondeur avec expansion
- **Badges animés** : Icônes émojis pour les rôles
- **Dialogs modaux** : Confirmation des actions importantes
- **Transitions fluides** : Navigation avec animations natives

## 🛠️ Technologies utilisées

- **Flutter** : Framework cross-platform (version 3.10.7+)
- **Dart** : Langage de programmation
- **Provider** : Gestion d'état réactive (^6.1.1)
- **SharedPreferences** : Persistance locale des données (^2.2.2)

## 📦 Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.1
  shared_preferences: ^2.2.2
```

## 🎯 Architecture et Patterns

### Models (`loup_garou_models.dart`)
- **Joueur** : Représente un joueur avec son nom, rôle, état et effets
- **Role** : Énumération des 8 rôles avec emoji, description et ordre de jeu
- **Effet** : Système d'effets applicables aux joueurs
- **TourDeJeu** : Représente un tour avec ses actions
- **Phase** : Énumération des phases (Préparation, Nuit, Jour, Vote, Terminé)
- **ActionJeu** : Enregistrement de chaque action pendant la partie

### Service (`partie_service.dart`)
- **PartieService** : Service principal avec ChangeNotifier
  - Gestion des joueurs (ajout, modification, suppression)
  - Gestion des tours et phases
  - Système d'élimination avec gestion des amoureux
  - Effets et actions
  - Sauvegarde/chargement automatique
  - Détection de fin de partie

### Pages
- **AccueilPage** : Page d'accueil avec logo et boutons
- **ConfigurationPage** : Configuration de la partie et ajout des joueurs
- **JeuPage** : Page principale du jeu avec gestion en temps réel

## 📂 Structure du projet

```
lib/
├── main.dart                    # Point d'entrée avec Provider
├── loup_garou_models.dart       # Tous les modèles de données
├── partie_service.dart          # Service de gestion de partie
├── accueil_page.dart           # Page d'accueil
├── configuration_page.dart      # Configuration des joueurs
└── jeu_page.dart               # Page de jeu principale
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

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🎮 Guide d'utilisation

### Démarrer une partie

1. **Page d'accueil** : Cliquez sur "NOUVELLE PARTIE"
2. **Configuration** :
   - Ajoutez les joueurs un par un
   - Sélectionnez leur rôle dans le menu déroulant
   - Minimum 4 joueurs et au moins 1 Loup-Garou requis
3. **Démarrer** : Cliquez sur "DÉMARRER LA PARTIE"

### Pendant le jeu

#### Phase Nuit
1. Consultez l'ordre de la nuit en haut de l'écran
2. Réveillez les rôles dans l'ordre indiqué
3. Pour chaque action :
   - Cliquez sur le joueur concerné
   - Ajoutez un effet si nécessaire
   - Enregistrez l'action

#### Phase Jour
1. Laissez les joueurs discuter
2. Notez les informations importantes
3. Passez au vote

#### Phase Vote
1. Éliminez le joueur désigné par le vote
2. Cliquez sur "Éliminer" dans sa carte
3. Passez à la nuit suivante

### Fonctionnalités avancées

- **Système Cupidon** : Définissez deux amoureux (si l'un meurt, l'autre aussi)
- **Effets** : Appliquez protection, poison, vision, etc.
- **Historique** : Toutes les actions sont sauvegardées
- **Pause** : Fermez l'app, la partie est sauvegardée automatiquement

## 🎯 Points techniques importants

### Gestion d'état
- **Provider** : Pattern Observer pour la réactivité
- **ChangeNotifier** : Notifications automatiques des changements
- **Context.watch** : Reconstruction automatique des widgets

### Persistance
- **SharedPreferences** : Stockage local JSON
- **Auto-save** : Sauvegarde à chaque action
- **Sérialisation** : toJson/fromJson pour tous les modèles

### Logique métier
- **Ordre automatique** : Calcul de l'ordre de nuit basé sur les rôles vivants
- **Détection de victoire** : Vérification automatique après chaque élimination
- **Gestion des amoureux** : Élimination en cascade

## 📱 Plateformes supportées

- ✅ **Android** : Testé sur Android 8.0+
- ✅ **iOS** : Compatible iOS 12.0+
- ✅ **Web** : Fonctionnel
- ✅ **Desktop** : Windows, macOS, Linux

## 🎲 Règles du jeu Loup-Garou

### Objectifs
- **Villageois** : Éliminer tous les Loups-Garous
- **Loups-Garous** : Égaler ou dépasser le nombre de villageois

### Rôles détaillés

**🐺 Loup-Garou** (Ordre 1)
- Se réveille la nuit avec les autres loups
- Choisit une victime à éliminer

**🔮 Voyante** (Ordre 2)
- Peut voir le rôle d'un joueur chaque nuit

**🧪 Sorcière** (Ordre 3)
- Potion de vie : Ressuscite la victime des loups (1 fois)
- Potion de mort : Élimine un joueur (1 fois)

**🎯 Chasseur** (Ordre 4)
- Quand il meurt, peut éliminer un autre joueur

**💘 Cupidon** (Ordre 5)
- Premier tour uniquement : Désigne deux amoureux
- Si l'un meurt, l'autre meurt de chagrin

**👧 Petite Fille** (Ordre 6)
- Peut espionner les loups-garous (avec risque)

**🎭 Voleur** (Ordre 7)
- Premier tour : Peut échanger son rôle avec une carte non distribuée

**👤 Villageois** (Ordre 100)
- Aucun pouvoir spécial
- Participe aux votes

## 🏆 Points forts du projet

### Techniques
- ✅ Architecture propre avec séparation des responsabilités
- ✅ Gestion d'état moderne avec Provider
- ✅ Persistance automatique des données
- ✅ Code bien structuré et commenté
- ✅ Modèles de données complets avec sérialisation

### Design
- ✅ Thème cohérent bleu et or
- ✅ Interface intuitive et professionnelle
- ✅ Animations et feedback visuels
- ✅ Composants réutilisables

### Fonctionnalités
- ✅ Gestion complète du jeu
- ✅ Système d'effets flexible
- ✅ Détection automatique de fin
- ✅ Sauvegarde automatique
- ✅ Support de tous les rôles classiques

## 💡 Améliorations futures

- [ ] Mode multijoueur avec synchronisation
- [ ] Ajout de rôles supplémentaires (Ancien, Idiot, etc.)
- [ ] Statistiques de parties
- [ ] Mode tutoriel interactif
- [ ] Sons et musiques d'ambiance
- [ ] Thèmes personnalisables
- [ ] Export de l'historique de partie

## 🐛 Dépannage

### Les données ne se sauvegardent pas
- Vérifiez que SharedPreferences est bien installé
- Sur iOS, les permissions peuvent être requises

### Erreur de build
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Apprentissages clés

- **Flutter avancé** : Provider, state management
- **Architecture** : Séparation models/services/views
- **Persistance** : SharedPreferences, JSON
- **UX/UI** : Design cohérent, feedback utilisateur
- **Logique métier** : Règles de jeu complexes

## 👥 Crédits

- **Développeur** : Mael Valin
- **Cours** : S6 - Développement mobile
- **Inspiration** : Jeu de société Loup-Garou de Thiercelieux

## 📄 Licence

Projet académique - S6 2026

---

**Développé avec** ❤️ **et Flutter**

**Version** : 1.0.0  
**Dernière mise à jour** : Janvier 2026
