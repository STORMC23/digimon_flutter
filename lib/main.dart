import 'package:flutter/material.dart';
import 'dart:async';
import 'nba_player_model.dart';
import 'nba_player_list.dart';
import 'new_nba_player_form.dart';

void main() => runApp(const MyApp()); // Inicia l'aplicació

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All-star salesians 24/25', // Títol de l'aplicació
      debugShowCheckedModeBanner: false, // Desactiva la marca de depuració
      theme: ThemeData(
        brightness: Brightness.dark, // Tema fosc
        primarySwatch: Colors.blue, // Color principal de l'aplicació
        scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Color de fons de l'estructura
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F3460), // Color de la barra superior
          elevation: 4, // Elevació de la barra superior
        ),
      ),
      home: const MyHomePage(
        title: 'All-star salesians 24/25', // Títol de la pàgina d'inici
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title; // Títol que es passa a la pàgina
  const MyHomePage({super.key, required this.title});

  @override
  // Crea l'estat per la pàgina d'inici
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Llista inicial de jugadors de la NBA
  List<NbaPlayer> initialNbaPlayers = [NbaPlayer('LeBron James'), NbaPlayer('Stephen Curry'), NbaPlayer('Kevin Durant')];

  // Funció que mostra el formulari per afegir un nou jugador de la NBA
  Future _showNewNbaPlayerForm() async {
    NbaPlayer newNbaPlayer = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const AddNbaPlayerFormPage(); // Afegeix un nou jugador a través del formulari
    }));
    if (newNbaPlayer == null) {
      // Si el jugador és null, mostra un missatge d'error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Jugador desconegut'),
      ));
    } else {
      // Si el jugador no és null, l'afegim a la llista si no hi és ja
      if (!initialNbaPlayers.contains(newNbaPlayer)) {
        initialNbaPlayers.add(newNbaPlayer); // Afegim el jugador a la llista
        setState(() {}); // Actualitzem l'estat per mostrar els canvis
      } else {
        // Si el jugador ja existeix, mostrem un missatge
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('El jugador ja està present'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey<ScaffoldState>(); // Creem una clau per gestionar l'estructura de la pantalla
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), // Títol de la barra superior
        centerTitle: true, // Centra el títol
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)], // Gradient de fons
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Afegim espai als costats
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16), // Espai superior
                Expanded(
                  child: NbaPlayerList(initialNbaPlayers), // Llista de jugadors de la NBA
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewNbaPlayerForm, // Quan es prem el botó, s'obre el formulari per afegir un nou jugador
        backgroundColor: const Color(0xFF0F3460), // Color de fons del botó
        label: const Text(
          'Add Nba Player', // Text del botó
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white), // Icona del botó
      ),
    );
  }
}
