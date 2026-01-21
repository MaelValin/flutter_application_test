# TP3 - Application Visualisation de film

## 📱 Description du projet

Application mobile développée dans le cadre du **TP3 - Application Visualisation de film** pour le cours de développement d'applications mobiles (S6). Cette application Flutter permet de parcourir une liste de films locaux, afficher les détails, gérer une liste de favoris et lire une vidéo (bande-annonce) via un appui long.

## 👨‍🎓 Informations

- **Étudiant** : Mael Valin
- **Semestre** : S6
- **Cours** : Développement d'applications mobiles

## ✨ Fonctionnalités principales

- **Parcourir les films** : Liste de films chargée depuis `data/filmdata.json` et affichée dans `FilmPage`.
- **Détail du film** : Affichage du titre, année, description et poster.
- **Favoris** : Ajouter/supprimer un film aux favoris via le bouton cœur (service `FavoriteService`).
- **Compteur de favoris** : Icône en haut indiquant le nombre de favoris.
- **Lecture vidéo** : Appui long sur une carte de film pour ouvrir un lecteur vidéo (si `movie.video` est présent) via `VideoPlayerDialog`.
- **Chargement local** : Les données sont préchargées localement (fichier JSON dans `data/`).

## 🛠️ Fichiers importants

- `lib/FilmPage.dart` : écran principal listant les films et gérant les favoris.
- `lib/main.dart` : point d'entrée et injection des services (`MovieService`, `FavoriteService`).
- `lib/services/film_service.dart` : chargement des films depuis les assets/local.
- `lib/services/favorite_service.dart` : logique de gestion des favoris.
- `data/filmdata.json` : données locales des films.

## 📦 Dépendances

Les dépendances principales utilisées sont listées dans `pubspec.yaml` (ex : `google_fonts`, `font_awesome_flutter`, `url_launcher`, `share_plus`).

## 📸 Assets

Le dossier `assets/` contient les images d'interface et `data/` contient `filmdata.json` utilisé pour peupler l'application.

## ▶️ Lancer l'application (localement)

1. Assurez-vous d'avoir Flutter installé et configuré.
2. Depuis la racine du projet, installez les dépendances :

```bash
flutter pub get
```

3. Lancez l'application sur un simulateur ou un appareil :

```bash
flutter run
```

## 🧭 Notes techniques

- L'écran principal est `FilmPage` (voir `lib/FilmPage.dart`).
- L'appui long sur une carte provoque l'ouverture d'une boîte de dialogue vidéo via `VideoPlayerDialog` (fichier dans `lib/composant/`).
- Le service de favoris expose `isFavorite(movie)`, `toggleFavorite(movie)` et une propriété `favoriteCount` utilisée pour l'affichage.

## 📄 Licence

Travail académique réalisé dans le cadre d'un cours universitaire.

---

**Dernière mise à jour** : Janvier 2026

**Screens**

<img src="screen app/film1.png">
<img src="screen app/film2.png">
<img src="screen app/film3.png">

