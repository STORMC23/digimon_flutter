import 'nba_player_model.dart';
import 'nba_player_detail_page.dart';
import 'package:flutter/material.dart';

class NbaPlayerCard extends StatefulWidget {
  final NbaPlayer nbaPlayer; // Jugador de la NBA que es passarà al widget

  const NbaPlayerCard(this.nbaPlayer, {super.key});

  @override
  // Crea l'estat per a la targeta del jugador de la NBA
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _NbaPlayerCardState createState() => _NbaPlayerCardState(nbaPlayer);
}

class _NbaPlayerCardState extends State<NbaPlayerCard> {
  NbaPlayer nbaPlayer; // Instància del jugador de la NBA
  String? renderUrl; // URL de la imatge del jugador

  _NbaPlayerCardState(this.nbaPlayer);

  @override
  void initState() {
    super.initState();
    renderNbaPlayerPic(); // Carrega la imatge del jugador quan es crea l'estat
  }

  // Widget per mostrar la imatge del jugador de la NBA
  Widget get nbaPlayerImage {
    var nbaPlayerAvatar = Hero(
      tag: nbaPlayer.name, // Efecte de transició d'animació amb el nom del jugador
      child: Container(
        width: 90.0,
        height: 90.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Forma circular de la imatge
          image: DecorationImage(
            fit: BoxFit.cover, // Ajusta la imatge perquè cobreixi el contenidor
            image: NetworkImage(renderUrl ?? ''), // Carrega la imatge des de la URL
          ),
        ),
      ),
    );

    // Si la imatge no està carregada, es mostra un placeholder (espai reservat)
    var placeholder = Container(
      width: 90.0,
      height: 90.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey, Colors.blueGrey],
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'DIGI', // Text de placeholder
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    // Realitza una transició animada entre el placeholder i la imatge real del jugador
    var crossFade = AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: nbaPlayerAvatar,
      crossFadeState: renderUrl == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000), // Durada de la transició
    );

    return crossFade; // Retorna el widget amb la transició
  }

  // Funció per carregar la imatge del jugador
  void renderNbaPlayerPic() async {
    await nbaPlayer.getImageUrl(); // Obté la URL de la imatge del jugador
    if (mounted) { // Comprova si el widget encara està en la jerarquia de la UI
      setState(() {
        renderUrl = nbaPlayer.imageUrl; // Actualitza l'URL de la imatge
      });
    }
  }

  // Widget per crear la targeta amb la informació del jugador
  Widget get nbaPlayerCard {
    return Positioned(
      right: 0.0,
      child: SizedBox(
        width: 290,
        height: 115,
        child: Card(
          elevation: 5.0, // Elevació de la targeta
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), // Bordes arrodonits
          color: const Color(0xFFFDFDFD), // Color de fons de la targeta
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 64), // Espais dins de la targeta
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: [
                    const Icon(Icons.person, color: Color(0xFF004D40), size: 20), // Icona de persona
                    const SizedBox(width: 6),
                    Text(
                      widget.nbaPlayer.name, // Nom del jugador
                      style: const TextStyle(
                        color: Color(0xFF004D40),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star, color: Colors.amber, size: 18), // Icona d'estrella per la qualificació
                    const SizedBox(width: 4),
                    Text(
                      '${widget.nbaPlayer.rating}/10', // Qualificació del jugador
                      style: const TextStyle(color: Color(0xFF616161), fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Funció per mostrar la pàgina de detalls del jugador
  showNbaPlayerDetailPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NbaPlayerDetailPage(nbaPlayer))) // Navega a la pàgina de detalls
        .then((_) {
      setState(() {}); // Actualitza l'estat quan es torna de la pàgina de detalls
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showNbaPlayerDetailPage(), // Quan es toca la targeta, mostra la pàgina de detalls
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Espais dins de la targeta
        child: SizedBox(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              nbaPlayerCard, // La targeta del jugador
              Positioned(top: 12.5, left: 8, child: nbaPlayerImage), // La imatge del jugador
            ],
          ),
        ),
      ),
    );
  }
}
