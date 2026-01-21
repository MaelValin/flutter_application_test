import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loup_garou_models.dart';

class PartieService extends ChangeNotifier {
  List<Joueur> _joueurs = [];
  List<TourDeJeu> _tours = [];
  int _tourActuel = 0;
  Phase _phaseActuelle = Phase.preparation;
  bool _partieEnCours = false;
  int _indexRoleActuel = 0; // Index du rôle actuel dans l'ordre de nuit
  String? _victimedeLaNuit; // ID du joueur ciblé par les loups

  // Getters
  List<Joueur> get joueurs => _joueurs;
  List<Joueur> get joueursVivants =>
      _joueurs.where((j) => j.estVivant).toList();
  List<TourDeJeu> get tours => _tours;
  int get tourActuel => _tourActuel;
  Phase get phaseActuelle => _phaseActuelle;
  bool get partieEnCours => _partieEnCours;
  int get indexRoleActuel => _indexRoleActuel;
  String? get victimeDeLaNuit => _victimedeLaNuit;

  // Obtenir l'ordre de jeu pour la nuit
  List<Role> get ordreNuit {
    // Ne garder que les rôles qui ont une action pendant la nuit (ordre < 100)
    final rolesPresents = joueursVivants
        .map((j) => j.role)
        .where(
          (role) => role.ordre < 100,
        ) // Exclure les rôles sans action nocturne
        .toSet()
        .toList();
    rolesPresents.sort((a, b) => a.ordre.compareTo(b.ordre));
    return rolesPresents;
  }

  // Obtenir le rôle actuel dans l'ordre de nuit
  Role? get roleActuel {
    final ordre = ordreNuit;
    if (ordre.isEmpty || _indexRoleActuel >= ordre.length) return null;
    return ordre[_indexRoleActuel];
  }

  // Obtenir les joueurs ayant le rôle actuel
  List<Joueur> get joueursRoleActuel {
    final role = roleActuel;
    if (role == null) return [];
    return joueursVivants.where((j) => j.role == role).toList();
  }

  // Passer au rôle suivant dans l'ordre de nuit
  void passerRoleSuivant() {
    final ordre = ordreNuit;
    if (_indexRoleActuel < ordre.length - 1) {
      _indexRoleActuel++;
    } else {
      // Fin de la nuit, passer au jour
      _indexRoleActuel = 0;
      _phaseActuelle = Phase.jour;
    }
    notifyListeners();
    _sauvegarder();
  }

  // Réinitialiser l'index des rôles au début de la nuit
  void _reinitialiserIndexRole() {
    _indexRoleActuel = 0;
    _victimedeLaNuit = null;
  }

  // Démarrer une nouvelle partie
  void demarrerPartie() {
    _partieEnCours = true;
    _tourActuel = 1;
    _phaseActuelle = Phase.nuit;
    _tours = [TourDeJeu(numero: 1)];
    _reinitialiserIndexRole();
    notifyListeners();
    _sauvegarder();
  }

  // Ajouter un joueur
  void ajouterJoueur(String nom, Role role) {
    final joueur = Joueur(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nom: nom,
      role: role,
    );
    _joueurs.add(joueur);
    notifyListeners();
    _sauvegarder();
  }

  // Modifier un joueur
  void modifierJoueur(String id, {String? nom, Role? role}) {
    final index = _joueurs.indexWhere((j) => j.id == id);
    if (index != -1) {
      if (nom != null) _joueurs[index].nom = nom;
      if (role != null) _joueurs[index].role = role;
      notifyListeners();
      _sauvegarder();
    }
  }

  // Supprimer un joueur
  void supprimerJoueur(String id) {
    _joueurs.removeWhere((j) => j.id == id);
    notifyListeners();
    _sauvegarder();
  }

  // Éliminer un joueur
  void eliminerJoueur(String id, {String? raison}) {
    final index = _joueurs.indexWhere((j) => j.id == id);
    if (index == -1) return; // Joueur introuvable

    final joueur = _joueurs[index];
    joueur.estVivant = false;

    // Si le joueur est amoureux, éliminer aussi son amoureux (si présent)
    if (joueur.estAmoureux && joueur.idAmoureux != null) {
      final amoureuxIndex = _joueurs.indexWhere(
        (j) => j.id == joueur.idAmoureux && j.estVivant,
      );
      if (amoureuxIndex != -1) {
        final amoureux = _joueurs[amoureuxIndex];
        amoureux.estVivant = false;
        ajouterAction(
          Role.cupidon,
          '${amoureux.nom} meurt de chagrin (amoureux)',
          cibleId: amoureux.id,
        );
      }
    }

    if (_tours.isNotEmpty) {
      _tours.last.joueurElimine = id;
    }

    if (raison != null) {
      ajouterAction(Role.loupGarou, raison, cibleId: id);
    }

    notifyListeners();
    _sauvegarder();
    _verifierFinPartie();
  }

  // Ajouter un effet à un joueur
  void ajouterEffet(String joueurId, TypeEffet type, String description) {
    final index = _joueurs.indexWhere((j) => j.id == joueurId);
    if (index == -1) return; // Joueur introuvable
    final joueur = _joueurs[index];
    final effet = Effet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      description: description,
      tourApplication: _tourActuel,
    );
    joueur.ajouterEffet(effet);
    notifyListeners();
    _sauvegarder();
  }

  // Retirer un effet
  void retirerEffet(String joueurId, String effetId) {
    final index = _joueurs.indexWhere((j) => j.id == joueurId);
    if (index == -1) return; // Joueur introuvable
    final joueur = _joueurs[index];
    joueur.retirerEffet(effetId);
    notifyListeners();
    _sauvegarder();
  }

  // Définir deux joueurs comme amoureux
  void definirAmoureux(String joueur1Id, String joueur2Id) {
    final index1 = _joueurs.indexWhere((j) => j.id == joueur1Id);
    final index2 = _joueurs.indexWhere((j) => j.id == joueur2Id);
    if (index1 == -1 || index2 == -1) return; // Un des joueurs introuvable

    final j1 = _joueurs[index1];
    final j2 = _joueurs[index2];

    j1.estAmoureux = true;
    j1.idAmoureux = joueur2Id;
    j2.estAmoureux = true;
    j2.idAmoureux = joueur1Id;

    ajouterAction(
      Role.cupidon,
      '${j1.nom} et ${j2.nom} sont maintenant amoureux',
    );

    notifyListeners();
    _sauvegarder();
  }

  // Ajouter une action au tour actuel
  void ajouterAction(Role role, String description, {String? cibleId}) {
    if (_tours.isEmpty) return;

    final action = ActionJeu(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roleActeur: role,
      description: description,
      timestamp: DateTime.now(),
      cibleId: cibleId,
    );

    _tours.last.ajouterAction(action);
    notifyListeners();
    _sauvegarder();
  }

  // Passer à la phase suivante
  void passerPhase() {
    switch (_phaseActuelle) {
      case Phase.preparation:
        _phaseActuelle = Phase.nuit;
        _reinitialiserIndexRole();
        break;
      case Phase.nuit:
        _phaseActuelle = Phase.jour;
        _reinitialiserIndexRole();
        // Appliquer la mort de la victime de la nuit
        if (_victimedeLaNuit != null) {
          eliminerJoueur(_victimedeLaNuit!, raison: 'Tué par les loups-garous');
          _victimedeLaNuit = null;
        }
        break;
      case Phase.jour:
        _phaseActuelle = Phase.vote;
        break;
      case Phase.vote:
        _tourActuel++;
        _tours.add(TourDeJeu(numero: _tourActuel));
        _phaseActuelle = Phase.nuit;
        _reinitialiserIndexRole();
        break;
      case Phase.termine:
        break;
    }
    notifyListeners();
    _sauvegarder();
  }

  // Définir la victime de la nuit (loups-garous)
  void definirVictimeDeLaNuit(String joueurId) {
    _victimedeLaNuit = joueurId;
    final joueur = _joueurs.firstWhere((j) => j.id == joueurId);
    ajouterAction(
      Role.loupGarou,
      '${joueur.nom} a été ciblé par les loups',
      cibleId: joueurId,
    );
    notifyListeners();
    _sauvegarder();
  }

  // Vérifier si la partie est terminée
  void _verifierFinPartie() {
    final loups = joueursVivants.where((j) => j.role == Role.loupGarou);
    final villageois = joueursVivants.where((j) => j.role != Role.loupGarou);

    if (loups.isEmpty) {
      _phaseActuelle = Phase.termine;
      ajouterAction(Role.villageois, 'Les villageois ont gagné !');
    } else if (villageois.isEmpty) {
      _phaseActuelle = Phase.termine;
      ajouterAction(Role.loupGarou, 'Les loups-garous ont gagné !');
    }
  }

  // Réinitialiser la partie
  void reinitialiserPartie() {
    _joueurs.clear();
    _tours.clear();
    _tourActuel = 0;
    _phaseActuelle = Phase.preparation;
    _partieEnCours = false;
    notifyListeners();
    _sauvegarder();
  }

  // Sauvegarder l'état de la partie
  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'joueurs': _joueurs.map((j) => j.toJson()).toList(),
      'tours': _tours.map((t) => t.toJson()).toList(),
      'tourActuel': _tourActuel,
      'phaseActuelle': _phaseActuelle.name,
      'partieEnCours': _partieEnCours,
      'indexRoleActuel': _indexRoleActuel,
      'victimeDeLaNuit': _victimedeLaNuit,
    };
    await prefs.setString('partie_loup_garou', jsonEncode(data));
  }

  // Charger l'état de la partie
  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final dataStr = prefs.getString('partie_loup_garou');
    if (dataStr != null) {
      final data = jsonDecode(dataStr);
      _joueurs = (data['joueurs'] as List)
          .map((j) => Joueur.fromJson(j))
          .toList();
      _tours = (data['tours'] as List)
          .map((t) => TourDeJeu.fromJson(t))
          .toList();
      _tourActuel = data['tourActuel'] ?? 0;
      _phaseActuelle = Phase.values.firstWhere(
        (p) => p.name == data['phaseActuelle'],
        orElse: () => Phase.preparation,
      );
      _partieEnCours = data['partieEnCours'] ?? false;
      _indexRoleActuel = data['indexRoleActuel'] ?? 0;
      _victimedeLaNuit = data['victimeDeLaNuit'];
      notifyListeners();
    }
  }
}
