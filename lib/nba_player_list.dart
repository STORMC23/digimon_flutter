import 'nba_player_card.dart'; 
import 'package:flutter/material.dart'; 
import 'nba_player_model.dart'; 

class NbaPlayerList extends StatelessWidget {
  final List<NbaPlayer> nbaPlayers; // Llista de jugadors de la NBA

  const NbaPlayerList(this.nbaPlayers, {super.key}); // Constructor per passar la llista de jugadors

  @override
  Widget build(BuildContext context) {
    return _buildList(context); // Retorna la llista amb els jugadors
  }

  // Funció per construir la llista de jugadors
  ListView _buildList(context) {
    return ListView.builder(
      itemCount: nbaPlayers.length, // Nombre d'elements a la llista (jugadors)
      itemBuilder: (context, int) {
        return NbaPlayerCard(nbaPlayers[int]); // Crea una targeta per cada jugador
      },
    );
  }
}
