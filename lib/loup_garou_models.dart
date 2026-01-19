import 'package:flutter/material.dart';

// Énumération des rôles disponibles dans le jeu
enum Role {
  loupGarou('Loup-Garou', '🐺', 'Élimine un villageois chaque nuit', 1),
  voyante('Voyante', '🔮', 'Peut voir le rôle d\'un joueur', 2),
  sorciere('Sorcière', '🧪', 'Possède une potion de vie et une de mort', 3),
  chasseur('Chasseur', '🎯', 'Peut éliminer quelqu\'un s\'il meurt', 4),
  cupidon('Cupidon', '💘', 'Désigne deux amoureux au début', 5),
  petiteFille('Petite Fille', '👧', 'Peut espionner les loups-garous', 6),
  voleur('Voleur', '🎭', 'Peut échanger son rôle en début de partie', 7),
  villageois('Villageois', '👤', 'Aucun pouvoir spécial', 100);

  final String nom;
  final String emoji;
  final String description;
  final int ordre; // Ordre de jeu pendant la nuit

  const Role(this.nom, this.emoji, this.description, this.ordre);
}

// Classe représentant un joueur
class Joueur {
  final String id;
  String nom;
  Role role;
  bool estVivant;
  List<Effet> effets;
  bool estAmoureux;
  String? idAmoureux;

  Joueur({
    required this.id,
    required this.nom,
    this.role = Role.villageois,
    this.estVivant = true,
    List<Effet>? effets,
    this.estAmoureux = false,
    this.idAmoureux,
  }) : effets = effets ?? [];

  // Ajouter un effet au joueur
  void ajouterEffet(Effet effet) {
    effets.add(effet);
  }

  // Retirer un effet
  void retirerEffet(String idEffet) {
    effets.removeWhere((e) => e.id == idEffet);
  }

  // Vérifier si le joueur a un effet spécifique
  bool aEffet(TypeEffet type) {
    return effets.any((e) => e.type == type && e.actif);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'role': role.name,
    'estVivant': estVivant,
    'estAmoureux': estAmoureux,
    'idAmoureux': idAmoureux,
    'effets': effets.map((e) => e.toJson()).toList(),
  };

  factory Joueur.fromJson(Map<String, dynamic> json) => Joueur(
    id: json['id'],
    nom: json['nom'],
    role: Role.values.firstWhere((r) => r.name == json['role']),
    estVivant: json['estVivant'],
    estAmoureux: json['estAmoureux'] ?? false,
    idAmoureux: json['idAmoureux'],
    effets:
        (json['effets'] as List?)?.map((e) => Effet.fromJson(e)).toList() ?? [],
  );
}

// Types d'effets possibles
enum TypeEffet {
  protection('Protection', '🛡️', Colors.green),
  poison('Poison', '☠️', Colors.red),
  vision('Vision', '👁️', Colors.purple),
  charme('Charme', '💕', Colors.pink),
  cible('Cible', '🎯', Colors.orange);

  final String nom;
  final String emoji;
  final Color couleur;

  const TypeEffet(this.nom, this.emoji, this.couleur);
}

// Classe représentant un effet sur un joueur
class Effet {
  final String id;
  final TypeEffet type;
  final String description;
  bool actif;
  final int tourApplication;

  Effet({
    required this.id,
    required this.type,
    required this.description,
    this.actif = true,
    required this.tourApplication,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'description': description,
    'actif': actif,
    'tourApplication': tourApplication,
  };

  factory Effet.fromJson(Map<String, dynamic> json) => Effet(
    id: json['id'],
    type: TypeEffet.values.firstWhere((t) => t.name == json['type']),
    description: json['description'],
    actif: json['actif'],
    tourApplication: json['tourApplication'],
  );
}

// Phases de jeu
enum Phase {
  preparation('Préparation', '⚙️'),
  nuit('Nuit', '🌙'),
  jour('Jour', '☀️'),
  vote('Vote', '🗳️'),
  termine('Terminé', '🏁');

  final String nom;
  final String emoji;

  const Phase(this.nom, this.emoji);
}

// Classe représentant un tour de jeu
class TourDeJeu {
  final int numero;
  Phase phase;
  List<ActionJeu> actions;
  String? joueurElimine;

  TourDeJeu({
    required this.numero,
    this.phase = Phase.nuit,
    List<ActionJeu>? actions,
    this.joueurElimine,
  }) : actions = actions ?? [];

  void ajouterAction(ActionJeu action) {
    actions.add(action);
  }

  Map<String, dynamic> toJson() => {
    'numero': numero,
    'phase': phase.name,
    'joueurElimine': joueurElimine,
    'actions': actions.map((a) => a.toJson()).toList(),
  };

  factory TourDeJeu.fromJson(Map<String, dynamic> json) => TourDeJeu(
    numero: json['numero'],
    phase: Phase.values.firstWhere((p) => p.name == json['phase']),
    joueurElimine: json['joueurElimine'],
    actions:
        (json['actions'] as List?)
            ?.map((a) => ActionJeu.fromJson(a))
            .toList() ??
        [],
  );
}

// Classe représentant une action effectuée pendant le jeu
class ActionJeu {
  final String id;
  final Role roleActeur;
  final String description;
  final DateTime timestamp;
  final String? cibleId;

  ActionJeu({
    required this.id,
    required this.roleActeur,
    required this.description,
    required this.timestamp,
    this.cibleId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'roleActeur': roleActeur.name,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'cibleId': cibleId,
  };

  factory ActionJeu.fromJson(Map<String, dynamic> json) => ActionJeu(
    id: json['id'],
    roleActeur: Role.values.firstWhere((r) => r.name == json['roleActeur']),
    description: json['description'],
    timestamp: DateTime.parse(json['timestamp']),
    cibleId: json['cibleId'],
  );
}
