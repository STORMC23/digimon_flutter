import 'dart:convert'; 
import 'dart:io'; 
import 'package:flutter_form_builder/flutter_form_builder.dart'; 
import 'nba_player_model.dart'; 
import 'package:flutter/material.dart'; 

class AddNbaPlayerFormPage extends StatefulWidget {
  const AddNbaPlayerFormPage({super.key});

  @override
  _AddNbaPlayerFormPageState createState() => _AddNbaPlayerFormPageState();
}

class _AddNbaPlayerFormPageState extends State<AddNbaPlayerFormPage> {
  TextEditingController nameController = TextEditingController(); // Controlador per al nom del jugador
  final _formKey = GlobalKey<FormBuilderState>(); // Clau global per gestionar l'estat del formulari
  static final List<String> jugadors = []; // Llista de noms de jugadors

  // Funció per obtenir la llista de jugadors de l'API
  void obtenirLlista() async {
    if (jugadors.isNotEmpty) return; // Si la llista ja està carregada, no la recarreguem

    HttpClient http = HttpClient(); // Crea un client HTTP per realitzar la petició

    try {
      // Fa una petició GET a l'API amb la llista de jugadors
      var uri = Uri.https('673e16560118dbfe860a153c.mockapi.io', '/APIPROVA');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      List data = json.decode(responseBody); // Decodifica la resposta JSON

      // Afegim els noms dels jugadors a la llista jugadors
      for (int i = 0; i < data.length; i++) {
        jugadors.add(data[i]['name']);
      }
    } catch (e) {
      print(e); // En cas d'error, imprimeix l'error
    }
  }

  // Funció per gestionar el botó de submissió del formulari
  void submitPup(BuildContext context) {
    // Comprovem si el jugador ha estat seleccionat
    if (_formKey.currentState?.value["nameplayer"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Escull un jugador'),
      ));
    } else {
      // Creem un nou objecte NbaPlayer i el retornem
      NbaPlayer newNbaPlayer =
          NbaPlayer(_formKey.currentState?.value["nameplayer"]);
      Navigator.of(context).pop(newNbaPlayer); // Tanca la pàgina i retorna el jugador creat
    }
  }

  @override
  Widget build(BuildContext context) {
    obtenirLlista(); // Carreguem la llista de jugadors
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afegeix un nou jugador'),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A90E2), // Color de la barra superior
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFABCAED), Color(0xFF4A90E2)], // Gradient de fons
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tria un jugador',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              FormBuilder(
                key: _formKey, // Assigna la clau global al formulari
                onChanged: () {
                  _formKey.currentState!.save(); // Desa l'estat del formulari quan canviï
                },
                child: FormBuilderDropdown<String>( // Crea el desplegable per seleccionar el jugador
                  name: 'nameplayer', // Nom del camp
                  decoration: InputDecoration(
                    labelText: 'Tria el jugador', 
                    labelStyle: TextStyle(color: Colors.blue), // Color de l'etiqueta
                    filled: true, // Activa el fons omplert
                    fillColor: Colors.white, // Fons blanc
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0), // Bordes arrodonits
                      borderSide: BorderSide.none, // Sense línias de bord
                    ),
                  ),
                  dropdownColor: Colors.white, // Fons del menú desplegable
                  style: const TextStyle(color: Colors.green), // Color del text seleccionat
                  items: jugadors
                      .map((jugador) => DropdownMenuItem(
                            value: jugador,
                            child: Text(
                              jugador,
                              style: const TextStyle(color: Colors.black), // Color dels ítems desplegables
                            ),
                          ))
                      .toList(),
                  alignment: AlignmentDirectional.centerStart, // Alineació dels ítems
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () => submitPup(context), // Quan es prem el botó, es fa la submissió
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2), // Color de fons del botó
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0), // Bordes arrodonits
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0), // Mida del botó
                ),
                child: const Text(
                  'Crea el Jugador', // Text del botó
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
