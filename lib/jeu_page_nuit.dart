import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'partie_service.dart';
import 'loup_garou_models.dart';

class JeuPageNuit extends StatelessWidget {
  const JeuPageNuit({super.key});

  @override
  Widget build(BuildContext context) {
    final partieService = Provider.of<PartieService>(context);
    final roleActuel = partieService.roleActuel;

    if (roleActuel == null) {
      // Fin de la nuit
      return _buildFinNuit(context, partieService);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌙 Phase de Nuit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000051), Color(0xFF1A237E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Indicateur de progression
            _buildProgressBar(partieService),

            // Carte du rôle actuel
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildRoleCard(context, partieService, roleActuel),
                ),
              ),
            ),

            // Bouton suivant
            _buildBottomButton(context, partieService, roleActuel),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(PartieService service) {
    final ordre = service.ordreNuit;
    final indexActuel = service.indexRoleActuel;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black26,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rôle ${indexActuel + 1}/${ordre.length}',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tour ${service.tourActuel}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (indexActuel + 1) / ordre.length,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    PartieService service,
    Role role,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF283593),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji du rôle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFFFD700),
              shape: BoxShape.circle,
            ),
            child: Text(role.emoji, style: const TextStyle(fontSize: 80)),
          ),
          const SizedBox(height: 20),

          // Nom du rôle
          Text(
            role.nom,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            role.description,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Actions spécifiques au rôle
          _buildRoleActions(context, service, role),
        ],
      ),
    );
  }

  Widget _buildRoleActions(
    BuildContext context,
    PartieService service,
    Role role,
  ) {
    switch (role) {
      case Role.loupGarou:
        return _buildLoupGarouActions(context, service);
      case Role.voyante:
        return _buildVoyanteActions(context, service);
      case Role.sorciere:
        return _buildSorciereActions(context, service);
      case Role.chasseur:
        return _buildPasserAction(context, service, 'Le chasseur se repose...');
      case Role.cupidon:
        return _buildCupidonActions(context, service);
      case Role.petiteFille:
        return _buildPasserAction(
          context,
          service,
          'La petite fille observe...',
        );
      case Role.voleur:
        return _buildPasserAction(context, service, 'Le voleur se repose...');
      case Role.villageois:
        return _buildPasserAction(
          context,
          service,
          'Les villageois dorment...',
        );
    }
  }

  Widget _buildLoupGarouActions(BuildContext context, PartieService service) {
    final joueursVivants = service.joueursVivants
        .where((j) => j.role != Role.loupGarou)
        .toList();

    return Column(
      children: [
        const Text(
          '🐺 Qui voulez-vous éliminer ?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...joueursVivants.map(
          (joueur) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () {
                service.definirVictimeDeLaNuit(joueur.id);
                _showConfirmation(
                  context,
                  '${joueur.nom} sera éliminé au lever du jour',
                  Icons.dangerous,
                  Colors.red,
                );
                Future.delayed(const Duration(seconds: 1), () {
                  service.passerRoleSuivant();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(joueur.role.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(joueur.nom, style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            service.ajouterAction(
              Role.loupGarou,
              'Les loups ne tuent personne cette nuit',
            );
            service.passerRoleSuivant();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD700),
            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Ne tuer personne', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildVoyanteActions(BuildContext context, PartieService service) {
    final joueursVivants = service.joueursVivants
        .where((j) => j.role != Role.voyante)
        .toList();

    return Column(
      children: [
        const Text(
          '🔮 Qui voulez-vous espionner ?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...joueursVivants.map(
          (joueur) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () {
                _showRoleReveal(context, service, joueur);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(joueur.nom, style: const TextStyle(fontSize: 18)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            service.ajouterAction(
              Role.voyante,
              'La voyante ne regarde personne',
            );
            service.passerRoleSuivant();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD700),
            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Ne pas espionner', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildSorciereActions(BuildContext context, PartieService service) {
    // Récupérer la victime de la nuit de façon sûre (évite "Bad state: No element")
    Joueur? victime;
    if (service.victimeDeLaNuit != null) {
      final matches = service.joueurs.where(
        (j) => j.id == service.victimeDeLaNuit,
      );
      victime = matches.isNotEmpty ? matches.first : null;
    } else {
      victime = null;
    }

    return Column(
      children: [
        const Text(
          '🧪 Que voulez-vous faire ?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (victime != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Text(
              '⚠️ ${victime.nom} a été ciblé par les loups',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              service.ajouterAction(
                Role.sorciere,
                '${victime!.nom} a été sauvé par la potion de vie',
                cibleId: victime!.id,
              );
              service.definirVictimeDeLaNuit(''); // Annuler la mort
              _showConfirmation(
                context,
                '${victime.nom} a été sauvé !',
                Icons.favorite,
                Colors.green,
              );
              Future.delayed(const Duration(seconds: 1), () {
                service.passerRoleSuivant();
              });
            },
            icon: const Icon(Icons.favorite, size: 24),
            label: const Text(
              'Utiliser la potion de vie',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),
        ],
        ElevatedButton.icon(
          onPressed: () => _showPoisonChoice(context, service),
          icon: const Icon(Icons.dangerous, size: 24),
          label: const Text(
            'Utiliser la potion de mort',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            service.ajouterAction(
              Role.sorciere,
              'La sorcière n\'utilise pas ses potions',
            );
            service.passerRoleSuivant();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD700),
            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Ne rien faire', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildCupidonActions(BuildContext context, PartieService service) {
    // Cupidon agit seulement au premier tour
    if (service.tourActuel > 1) {
      return _buildPasserAction(context, service, 'Cupidon se repose...');
    }

    return Column(
      children: [
        const Text(
          '💘 Choisissez deux amoureux',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _showCupidonChoice(context, service),
          icon: const Icon(Icons.favorite, size: 24),
          label: const Text(
            'Sélectionner les amoureux',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            service.ajouterAction(
              Role.cupidon,
              'Cupidon ne désigne pas d\'amoureux',
            );
            service.passerRoleSuivant();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD700),
            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Passer', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildPasserAction(
    BuildContext context,
    PartieService service,
    String message,
  ) {
    return Column(
      children: [
        Text(
          message,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            service.passerRoleSuivant();
          },
          icon: const Icon(Icons.arrow_forward, size: 24),
          label: const Text('Passer', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700),
            foregroundColor: const Color(0xFF1A237E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    PartieService service,
    Role role,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.black26),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${role.emoji} ${role.nom}',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${service.indexRoleActuel + 1}/${service.ordreNuit.length}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinNuit(BuildContext context, PartieService service) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌙 Fin de la Nuit'),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000051), Color(0xFF1A237E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF283593),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 3,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text('🌅', style: TextStyle(fontSize: 80)),
                      SizedBox(height: 20),
                      Text(
                        'Le jour se lève',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tous les rôles ont agi',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      service.passerPhase();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.wb_sunny, size: 28),
                    label: const Text(
                      'PASSER AU JOUR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF1A237E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmation(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showRoleReveal(
    BuildContext context,
    PartieService service,
    Joueur joueur,
  ) {
    service.ajouterAction(
      Role.voyante,
      'La voyante a vu le rôle de ${joueur.nom}',
      cibleId: joueur.id,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF283593),
        title: const Text(
          '🔮 Vision',
          style: TextStyle(color: Color(0xFFFFD700)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              joueur.nom,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700),
                shape: BoxShape.circle,
              ),
              child: Text(
                joueur.role.emoji,
                style: const TextStyle(fontSize: 60),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              joueur.role.nom,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              service.passerRoleSuivant();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: const Color(0xFF1A237E),
            ),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }

  void _showPoisonChoice(BuildContext context, PartieService service) {
    final joueursVivants = service.joueursVivants;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF283593),
        title: const Text(
          '☠️ Potion de Mort',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Qui voulez-vous empoisonner ?',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: joueursVivants.length,
                itemBuilder: (context, index) {
                  final joueur = joueursVivants[index];
                  return ListTile(
                    title: Text(
                      joueur.nom,
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: Text(
                      joueur.role.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    onTap: () {
                      service.eliminerJoueur(
                        joueur.id,
                        raison: '${joueur.nom} a été empoisonné',
                      );
                      Navigator.pop(context);
                      _showConfirmation(
                        context,
                        '${joueur.nom} a été empoisonné',
                        Icons.dangerous,
                        Colors.red,
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        service.passerRoleSuivant();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  void _showCupidonChoice(BuildContext context, PartieService service) {
    final joueursVivants = service.joueursVivants;
    Joueur? joueur1;
    Joueur? joueur2;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF283593),
          title: const Text(
            '💘 Amoureux',
            style: TextStyle(color: Colors.pink),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sélectionnez deux joueurs',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: joueursVivants.length,
                  itemBuilder: (context, index) {
                    final joueur = joueursVivants[index];
                    final isSelected = joueur == joueur1 || joueur == joueur2;
                    return ListTile(
                      title: Text(
                        joueur.nom,
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: Text(
                        joueur.role.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.favorite, color: Colors.pink)
                          : null,
                      selected: isSelected,
                      selectedTileColor: Colors.pink.withOpacity(0.2),
                      onTap: () {
                        setState(() {
                          if (joueur1 == null) {
                            joueur1 = joueur;
                          } else if (joueur2 == null && joueur != joueur1) {
                            joueur2 = joueur;
                          } else if (joueur == joueur1) {
                            joueur1 = null;
                          } else if (joueur == joueur2) {
                            joueur2 = null;
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: joueur1 != null && joueur2 != null
                  ? () {
                      service.definirAmoureux(joueur1!.id, joueur2!.id);
                      Navigator.pop(context);
                      _showConfirmation(
                        context,
                        '${joueur1!.nom} et ${joueur2!.nom} sont amoureux',
                        Icons.favorite,
                        Colors.pink,
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        service.passerRoleSuivant();
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }
}
