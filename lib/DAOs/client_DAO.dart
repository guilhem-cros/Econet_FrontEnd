import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/utils/constants.dart';
import '../models/client.dart';

/// DAO used to get client objects from the DB
class ClientDAO {

  /// Create a client in the DB
  /// Need the full_name, the pseudo, the email and the firebaseId of the client
  /// Return an APIResponse of a ClientModel, containing the created client if no everything
  /// worked, an error message if not
  Future<APIResponse<ClientModel>> createClient({
    required String fullName,
    required String pseudo,
    required String email,
    required String firebaseId,
  }) async {
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'full_name': fullName,
          'pseudo': pseudo,
          'email': email,
          'firebaseId': firebaseId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return APIResponse<ClientModel>(data: ClientModel.fromJson(jsonData));
      } else {
        return APIResponse<ClientModel>(error: true, errorMessage: jsonData['message']);
      }

    } catch (err){
      return APIResponse<ClientModel>(error: true, errorMessage: err.toString());
    }
  }

  /// Check if a specified string doesn't match any existing email or pseudo in the DB
  /// Return an APIResponse containing the result of the request if no error
  /// An APIResponse containing an error message if not
  Future<APIResponse<Map<String, dynamic>>> checkEmailPseudoUnique({
    required String email,
    required String pseudo,
  }) async {
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint + Constants.checkEndpoint;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'pseudo': pseudo}),
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 201) {
        Map<String, dynamic> data = jsonData;
        // If the server returns a successful response
        return APIResponse<Map<String, dynamic>>(data: data);
      } else {
        // If the server returns an error response
        return APIResponse<Map<String, dynamic>>(error: true, errorMessage: "Erreur innatendu durant la vérification des données.");
      }
    }catch(err){
      return APIResponse<Map<String, dynamic>>(error: true, errorMessage: err.toString());
    }
  }

  /// Check if a specified string doesn't match any existing email or pseudo in the DB
  /// but the one of the client linked to the specified id
  /// Return an APIResponse containing the result of the request if no error
  /// An APIResponse containing an error message if not
  Future<APIResponse<Map<String, dynamic>>> checkEmailPseudoUniqueForUpdate({
    required String email,
    required String pseudo,
    required String id
  }) async {
    final String apiUrl = '${Constants.baseUrl}${Constants.clientEndpoint}${Constants.checkEndpoint}/$id';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'pseudo': pseudo}),
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 201) {
        Map<String, dynamic> data = jsonData;
        // If the server returns a successful response
        return APIResponse<Map<String, dynamic>>(data: data);
      } else {
        // If the server returns an error response
        return APIResponse<Map<String, dynamic>>(error: true, errorMessage: "Erreur innatendu durant la vérification des données.");
      }
    }catch(err){
      return APIResponse<Map<String, dynamic>>(error: true, errorMessage: err.toString());
    }
  }


  /// Get a client by its firebaseId from the DB
  /// Return an APIResponse of a clientModel containing the matched client if the request worked
  /// An APIResponse containing an error message if not
  Future<APIResponse<ClientModel>> getByFirebaseId({required String uid}) async{
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint + Constants.firebaseEndpoint + uid;

    try {
      final response = await http.get(
          Uri.parse(apiUrl));

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return APIResponse<ClientModel>(data: ClientModel.fromJson(jsonData));
      }
      else {
        return APIResponse<ClientModel>(error: true, errorMessage: jsonData['message']);
      }
    } catch(err){
      return APIResponse<ClientModel>(error: true, errorMessage: err.toString());
    }
  }


  /// Update the specified client in the database
  /// Return an APIResponse containing the just updated client if request worked
  /// An APIResponse containing an error message if not
  Future<APIResponse<ClientModel>> updateClient({
    required ClientModel updateClient,
  }) async {
    final String apiUrl = '${Constants.baseUrl}${Constants.clientEndpoint}/${updateClient.id}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(updateClient.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return APIResponse<ClientModel>(data: ClientModel.fromJson(jsonData));
      } else {
        return APIResponse<ClientModel>(error: true, errorMessage: jsonData['message']);
      }
    } catch (err){
      return APIResponse<ClientModel>(error: true, errorMessage: err.toString());
    }
  }

}
