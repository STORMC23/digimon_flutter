import 'dart:convert'; 
import 'dart:io'; 
import 'dart:async';

class NbaPlayer {
  final String name; // Nom del jugador
  String? imageUrl; // URL de la imatge del jugador (pot ser nul)
  String? levelNbaPlayer; // Nivell del jugador a la NBA (pot ser nul)

  int rating = 10; 

  NbaPlayer(this.name); // Constructor que rep el nom del jugador

  // Funció per obtenir la URL de la imatge del jugador
  Future getImageUrl() async {
    // Si la URL de la imatge ja existeix, no es fa cap petició
    if (imageUrl != null) {
      return;
    }
    HttpClient http = HttpClient(); // Crea un objecte HttpClient per fer la petició HTTP
    try {
      // Crea la URL de la petició amb el nom del jugador com a paràmetre
      var uri = Uri.https('673e16560118dbfe860a153c.mockapi.io', '/APIPROVA', {"name": name});
      var request = await http.getUrl(uri); // Fa la petició HTTP per obtenir la informació
      var response = await request.close(); // Espera la resposta de la petició
      var responseBody = await response.transform(utf8.decoder).join(); // Descodifica la resposta en JSON

      List data = json.decode(responseBody); // Converteix la resposta JSON en una llista
      imageUrl = data[0]["imatge"]; // Assigna la URL de la imatge del primer element de la llista
      levelNbaPlayer = data[0]["level"] ?? null; // Assigna el nivell del jugador si existeix

    } catch (e) {
      print(e); // En cas d'error, imprimeix l'error
    }
  }

  // Sobreescrivim l'operador == per comparar dos jugadors per nom
  @override
  bool operator ==(Object other) =>
      identical(this, other) || // Compara si són la mateixa instància
      other is NbaPlayer && runtimeType == other.runtimeType && name == other.name; // Compara pel nom

  // Sobreescriu el mètode hashCode per garantir que dos objectes amb el mateix nom tinguin el mateix hash
  @override
  int get hashCode => name.hashCode;
}
