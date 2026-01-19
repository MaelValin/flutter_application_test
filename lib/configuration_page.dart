import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'partie_service.dart';
import 'loup_garou_models.dart';
import 'jeu_page.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final _nomController = TextEditingController();
  Role _roleSelectionne = Role.villageois;

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  void _ajouterJoueur(PartieService service) {
    if (_nomController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un nom'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    service.ajouterJoueur(_nomController.text.trim(), _roleSelectionne);
    _nomController.clear();
    setState(() => _roleSelectionne = Role.villageois);
  }

  void _demarrerPartie(PartieService service) {
    if (service.joueurs.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Il faut au moins 4 joueurs pour commencer'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Vérifier qu'il y a au moins un loup-garou
    final hasLoup = service.joueurs.any((j) => j.role == Role.loupGarou);
    if (!hasLoup) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Il faut au moins un Loup-Garou !'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    service.demarrerPartie();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const JeuPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partieService = Provider.of<PartieService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '⚙️ Configuration de la partie',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
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
        child: Column(
          children: [
            // Formulaire d'ajout
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Champ nom
                  TextField(
                    controller: _nomController,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Nom du joueur',
                      labelStyle: const TextStyle(color: Color(0xFFFFD700)),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFFFFD700)),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFFD700)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFFD700), width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sélection du rôle
                  DropdownButtonFormField<Role>(
                    value: _roleSelectionne,
                    dropdownColor: const Color(0xFF283593),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Rôle',
                      labelStyle: const TextStyle(color: Color(0xFFFFD700)),
                      prefixIcon: Text(
                        _roleSelectionne.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFFD700)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
                      ),
                    ),
                    items: Role.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Row(
                          children: [
                            Text(role.emoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Text(role.nom),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Role? newValue) {
                      if (newValue != null) {
                        setState(() => _roleSelectionne = newValue);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bouton ajouter
                  ElevatedButton.icon(
                    onPressed: () => _ajouterJoueur(partieService),
                    icon: const Icon(Icons.add, size: 24),
                    label: const Text(
                      'AJOUTER',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF1A237E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Liste des joueurs
            Expanded(
              child: partieService.joueurs.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 80, color: Colors.white30),
                          SizedBox(height: 16),
                          Text(
                            'Aucun joueur ajouté',
                            style: TextStyle(color: Colors.white54, fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: partieService.joueurs.length,
                      itemBuilder: (context, index) {
                        final joueur = partieService.joueurs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: const Color(0xFF283593),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFFFD700),
                              child: Text(
                                joueur.role.emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                            title: Text(
                              joueur.nom,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              joueur.role.nom,
                              style: const TextStyle(color: Color(0xFFFFD700)),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                partieService.supprimerJoueur(joueur.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Bouton démarrer
            if (partieService.joueurs.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Text(
                        '${partieService.joueurs.length} joueur(s)',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _demarrerPartie(partieService),
                          icon: const Icon(Icons.play_arrow, size: 28),
                          label: const Text(
                            'DÉMARRER LA PARTIE',
                            style: TextStyle(
                              fontSize: 20,
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
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
