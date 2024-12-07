import 'package:flutter/material.dart';
import 'nba_player_model.dart';
import 'dart:async';

class NbaPlayerDetailPage extends StatefulWidget {
  final NbaPlayer nbaPlayer; // Jugador de la NBA passat com a paràmetre

  const NbaPlayerDetailPage(this.nbaPlayer, {super.key});

  @override
  _NbaPlayerDetailPageState createState() => _NbaPlayerDetailPageState();
}

class _NbaPlayerDetailPageState extends State<NbaPlayerDetailPage> {
  final double nbaPlayerAvatarSize = 150.0; // Mida de la imatge del jugador
  double _sliderValue = 10.0; // Valor inicial del slider per la valoració del jugador

  // Widget per mostrar la valoració del jugador amb un slider
  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  activeColor: const Color(0xFF4A90E2), // Color actiu del slider
                  inactiveColor: Colors.grey.shade300, // Color inactiu del slider
                  min: 0.0, // Valor mínim
                  max: 10.0, // Valor màxim
                  value: _sliderValue, // Valor actual del slider
                  onChanged: (newRating) { // Funció quan el valor del slider canvia
                    setState(() {
                      _sliderValue = newRating; // Actualitza el valor de la valoració
                    });
                  },
                ),
              ),
              // Mostra el valor numèric de la valoració
              Container(
                  width: 50.0,
                  alignment: Alignment.center,
                  child: Text(
                    '${_sliderValue.toInt()}',
                    style: const TextStyle(
                        color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        submitRatingButton, // Botó per enviar la valoració
      ],
    );
  }

  // Funció per actualitzar la valoració del jugador
  void updateRating() {
    if (_sliderValue < 5) { // Si la valoració és inferior a 5, mostra un missatge d'error
      _ratingErrorDialog();
    } else {
      setState(() {
        widget.nbaPlayer.rating = _sliderValue.toInt(); // Actualitza la valoració del jugador
      });
    }
  }

  // Mostra un diàleg d'error si la valoració és massa baixa
  Future<void> _ratingErrorDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            title: const Text('Error!',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            content: const Text("Come on! They're good!"), // Missatge d'error
            actions: <Widget>[
              TextButton(
                child: const Text('Try Again',
                    style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.of(context).pop(), // Tanca el diàleg
              )
            ],
          );
        });
  }

  // Botó per enviar la valoració del jugador
  Widget get submitRatingButton {
    return ElevatedButton(
      onPressed: () => updateRating(), // Quan es prem el botó, actualitza la valoració
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2), // Color de fons del botó
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      ),
      child: const Text('Submit', style: TextStyle(fontSize: 18.0)), // Text del botó
    );
  }

  // Widget per mostrar la imatge del jugador amb un efecte Hero (transició d'animació)
  Widget get nbaPlayerImage {
    return Hero(
      tag: widget.nbaPlayer.name, // Efecte Hero basat en el nom del jugador
      child: Container(
        height: nbaPlayerAvatarSize, // Mida de la imatge
        width: nbaPlayerAvatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Forma circular de la imatge
          boxShadow: const [
            // Ombratge per donar profunditat a la imatge
            BoxShadow(
              offset: Offset(1.0, 2.0),
              blurRadius: 2.0,
              spreadRadius: -1.0,
              color: Color(0x33000000),
            ),
            BoxShadow(
              offset: Offset(2.0, 1.0),
              blurRadius: 3.0,
              spreadRadius: 0.0,
              color: Color(0x24000000),
            ),
            BoxShadow(
              offset: Offset(3.0, 1.0),
              blurRadius: 4.0,
              spreadRadius: 2.0,
              color: Color(0x1f000000),
            ),
          ],
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.nbaPlayer.imageUrl ?? "")), // Carrega la imatge del jugador
        ),
      ),
    );
  }

  // Widget per mostrar la valoració del jugador
  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.star,
          size: 40.0,
          color: Colors.amber, // Color de l'estrella
        ),
        Text('${widget.nbaPlayer.rating}/10',
            style: const TextStyle(color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold)) // Mostra la valoració
      ],
    );
  }

  // Widget per mostrar el perfil del jugador, incloent la imatge, nom, nivell i valoració
  Widget get nbaPlayerProfile {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFFABCAED)], // Gradient de colors del fons
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          nbaPlayerImage, // La imatge del jugador
          Text(widget.nbaPlayer.name,
              style: const TextStyle(
                  color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.bold)), // Nom del jugador
          Text('${widget.nbaPlayer.levelNbaPlayer}',
              style: const TextStyle(color: Colors.white70, fontSize: 20.0)), // Nivell del jugador
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: rating, // La valoració del jugador
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.nbaPlayer.rating.toDouble(); // Inicialitza el valor del slider amb la valoració del jugador
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fons blanc de la pàgina
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2), // Color de fons de la barra superior
        title: Text(
          'Meet ${widget.nbaPlayer.name}', // Títol de la pàgina amb el nom del jugador
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[nbaPlayerProfile, addYourRating], // Mostra el perfil del jugador i la secció de valoració
      ),
    );
  }
}
