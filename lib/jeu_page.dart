import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'partie_service.dart';
import 'loup_garou_models.dart';

class JeuPage extends StatelessWidget {
  const JeuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final partieService = Provider.of<PartieService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '${partieService.phaseActuelle.emoji} ${partieService.phaseActuelle.nom}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              'Tour ${partieService.tourActuel}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A237E),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'reinitialiser') {
                _showReinitialiserDialog(context, partieService);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reinitialiser',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Réinitialiser'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A237E),
              Color(0xFF283593),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: partieService.phaseActuelle == Phase.termine
            ? _buildFinPartie(context, partieService)
            : Column(
                children: [
                  // Ordre de jeu (pour la nuit)
                  if (partieService.phaseActuelle == Phase.nuit)
                    _buildOrdreNuit(partieService),

                  // Liste des joueurs
                  Expanded(
                    child: _buildListeJoueurs(context, partieService),
                  ),

                  // Bouton phase suivante
                  _buildControlsBottom(context, partieService),
                ],
              ),
      ),
    );
  }

  Widget _buildOrdreNuit(PartieService service) {
    final ordreRoles = service.ordreNuit;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF000051),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFFD700), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.list, color: Color(0xFFFFD700)),
              SizedBox(width: 8),
              Text(
                'Ordre de la nuit',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ordreRoles.asMap().entries.map((entry) {
              final index = entry.key;
              final role = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFD700)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${index + 1}.',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(role.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Text(
                      role.nom,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildListeJoueurs(BuildContext context, PartieService service) {
    final joueurs = service.joueurs;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: joueurs.length,
      itemBuilder: (context, index) {
        final joueur = joueurs[index];
        return _buildJoueurCard(context, service, joueur);
      },
    );
  }

  Widget _buildJoueurCard(
    BuildContext context,
    PartieService service,
    Joueur joueur,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: joueur.estVivant
          ? const Color(0xFF283593)
          : const Color(0xFF424242),
      elevation: joueur.estVivant ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: joueur.estVivant
              ? const Color(0xFFFFD700)
              : Colors.white24,
          width: joueur.estVivant ? 2 : 1,
        ),
      ),
      child: ExpansionTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFFD700),
              radius: 28,
              child: Text(
                joueur.role.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            if (!joueur.estVivant)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            if (joueur.estAmoureux)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('💕', style: TextStyle(fontSize: 14)),
                ),
              ),
          ],
        ),
        title: Text(
          joueur.nom,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: joueur.estVivant ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              joueur.role.nom,
              style: TextStyle(
                color: joueur.estVivant
                    ? const Color(0xFFFFD700)
                    : Colors.white38,
              ),
            ),
            if (joueur.effets.where((e) => e.actif).isNotEmpty)
              const SizedBox(height: 4),
            if (joueur.effets.where((e) => e.actif).isNotEmpty)
              Wrap(
                spacing: 4,
                children: joueur.effets
                    .where((e) => e.actif)
                    .map((effet) => Chip(
                          label: Text(
                            effet.type.emoji,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: effet.type.couleur,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
          ],
        ),
        trailing: joueur.estVivant
            ? const Icon(Icons.expand_more, color: Color(0xFFFFD700))
            : const Icon(Icons.block, color: Colors.red),
        collapsedIconColor: const Color(0xFFFFD700),
        iconColor: const Color(0xFFFFD700),
        children: [
          if (joueur.estVivant) ...[
            const Divider(color: Color(0xFFFFD700)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Description du rôle
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      joueur.role.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Actions rapides
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showAjouterEffetDialog(context, service, joueur),
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Effet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: const Color(0xFF1A237E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showEliminerDialog(context, service, joueur),
                          icon: const Icon(Icons.dangerous),
                          label: const Text('Éliminer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlsBottom(BuildContext context, PartieService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              service.passerPhase();
              if (service.phaseActuelle == Phase.nuit) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🌙 La nuit tombe...'),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color(0xFF1A237E),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward, size: 28),
            label: Text(
              _getNextPhaseText(service.phaseActuelle),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: const Color(0xFF1A237E),
              elevation: 8,
              shadowColor: const Color(0xFFFFD700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getNextPhaseText(Phase current) {
    switch (current) {
      case Phase.preparation:
        return 'DÉMARRER LA NUIT';
      case Phase.nuit:
        return 'PASSER AU JOUR';
      case Phase.jour:
        return 'PHASE DE VOTE';
      case Phase.vote:
        return 'NUIT SUIVANTE';
      case Phase.termine:
        return 'PARTIE TERMINÉE';
    }
  }

  Widget _buildFinPartie(BuildContext context, PartieService service) {
    final loups =
        service.joueurs.where((j) => j.role == Role.loupGarou && j.estVivant);
    final gagnant = loups.isEmpty ? 'VILLAGEOIS' : 'LOUPS-GAROUS';
    final emoji = loups.isEmpty ? '🎉' : '🐺';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFD700), width: 3),
              ),
              child: Column(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 100)),
                  const SizedBox(height: 20),
                  const Text(
                    'VICTOIRE',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    gagnant,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Partie terminée en ${service.tourActuel} tours',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home, size: 28),
                label: const Text(
                  'RETOUR À L\'ACCUEIL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAjouterEffetDialog(
    BuildContext context,
    PartieService service,
    Joueur joueur,
  ) {
    TypeEffet effetSelectionne = TypeEffet.protection;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF283593),
          title: const Text(
            'Ajouter un effet',
            style: TextStyle(color: Color(0xFFFFD700)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sur : ${joueur.nom}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<TypeEffet>(
                value: effetSelectionne,
                dropdownColor: const Color(0xFF1A237E),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Type d\'effet',
                  labelStyle: TextStyle(color: Color(0xFFFFD700)),
                ),
                items: TypeEffet.values.map((effet) {
                  return DropdownMenuItem(
                    value: effet,
                    child: Row(
                      children: [
                        Text(effet.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(effet.nom),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => effetSelectionne = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler',
                  style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                service.ajouterEffet(
                  joueur.id,
                  effetSelectionne,
                  '${effetSelectionne.nom} appliqué',
                );
                service.ajouterAction(
                  joueur.role,
                  '${effetSelectionne.emoji} ${effetSelectionne.nom} sur ${joueur.nom}',
                  cibleId: joueur.id,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF1A237E),
              ),
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEliminerDialog(
    BuildContext context,
    PartieService service,
    Joueur joueur,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF283593),
        title: const Text(
          '⚠️ Éliminer un joueur',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          'Voulez-vous éliminer ${joueur.nom} (${joueur.role.nom}) ?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              service.eliminerJoueur(
                joueur.id,
                raison: '${joueur.nom} a été éliminé',
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Éliminer'),
          ),
        ],
      ),
    );
  }

  void _showReinitialiserDialog(BuildContext context, PartieService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF283593),
        title: const Text(
          '⚠️ Réinitialiser',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Voulez-vous vraiment réinitialiser la partie ? Toutes les données seront perdues.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              service.reinitialiserPartie();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }
}
