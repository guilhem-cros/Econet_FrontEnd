import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_upload/utils/constants.dart';
import '../models/client.dart';

class ClientDAO {

  Future<void> createClient({
    required String full_name,
    required String pseudo,
    required String email,
    required String firebaseId,
  }) async {
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint;

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'full_name': full_name,
        'pseudo': pseudo,
        'email': email,
        'firebaseId': firebaseId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Client created successfully');
    } else if (response.statusCode == 400) {
      throw Exception(response.body); // Récupérer le message d'erreur
    } else {
      print('Failed to create client');
    }
  }

  Future<Map<String, dynamic>> checkEmailPseudoUnique({
    required String email,
    required String pseudo,
  }) async {
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint + Constants.checkEndpoint;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'pseudo': pseudo}),
    );

    if (response.statusCode == 201) {
      // If the server returns a successful response
      Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody;
    } else {
      // If the server returns an error response
      throw Exception('Failed to check email and pseudo uniqueness');
    }
  }

  Future<ClientModel> getByFirebaseId({required String uid}) async{
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint + Constants.firebaseEndpoint + uid;
    final response = await http.get(
        Uri.parse(apiUrl));
    if (response.statusCode == 200){
      return ClientModel.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to load client");
    }
  }

}
