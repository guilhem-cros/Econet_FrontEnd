import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/services/auth.dart';
import 'package:image_upload/utils/constants.dart';
import '../models/client.dart';

/// DAO used to get client objects from the DB
class ClientDAO {

  final AuthService _auth = AuthService();

  /// Create a client in the DB
  /// Need the full_name, the pseudo, the email and the firebaseId of the client
  /// Return an APIResponse of a ClientModel, containing the created client if no everything
  /// worked, an error message if not
  ///
  /// Parameters:
  /// - fullName: string -> the complete name of the client
  /// - pseudo: string -> the pseudo of the client
  /// - email: string -> the email of the client
  /// - firebaseId: string -> during the creation of a client, we use Firebase services to authenticate
  /// the client : the firebaseId corresponds to a unique identifier for each client
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
          'firebaseId': firebaseId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final jsonData = json.decode(response.body);
      jsonData["email"]=email;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return APIResponse<ClientModel>(data: ClientModel.fromJson(jsonData));
      } else {
        return APIResponse<ClientModel>(error: true, errorMessage: jsonData['message']);
      }

    } catch (err){
      return APIResponse<ClientModel>(error: true, errorMessage: err.toString());
    }
  }

  /// Check if a specified string doesn't match any or pseudo in the DB
  /// Return an APIResponse containing the result of the request if no error
  /// An APIResponse containing an error message if not
  ///
  /// Parameters:
  /// - email: string -> the string corresponding to the email to verify
  /// - pseudo: string -> the string corresponding to the pseudo to verify
  Future<APIResponse<Map<String, dynamic>>> checkPseudoUnique({
    required String pseudo,
  }) async {
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint + Constants.checkEndpoint;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'pseudo': pseudo}),
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

  /// Check if a specified string doesn't match any existing pseudo in the DB
  /// but the one of the client linked to the specified id
  /// Return an APIResponse containing the result of the request if no error
  /// An APIResponse containing an error message if not
  ///
  /// Parameters:
  /// - email: string -> the string corresponding to the email to verify
  /// - pseudo: string -> the string corresponding to the pseudo to verify
  /// - id: string -> the id of the client in the database
  Future<APIResponse<Map<String, dynamic>>> checkPseudoUniqueForUpdate({
    required String pseudo,
    required String id
  }) async {
    final String apiUrl = '${Constants.baseUrl}${Constants.clientEndpoint}${Constants.checkEndpoint}/$id';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'pseudo': pseudo}),
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
  ///
  /// Parameters:
  /// - uid: string -> the firebaseId of the client for who we need more information
  Future<APIResponse<ClientModel>> getByFirebaseId({required String uid, required String email}) async{
    final String apiUrl = Constants.baseUrl + Constants.clientEndpoint + Constants.firebaseEndpoint + uid;


    try {
      String? token = await _auth.getUserToken();

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final jsonData = json.decode(response.body);
      jsonData["email"]=email;
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

  /// Get a client by its id from the DB
  /// Return an APIResponse of a clientModel containing the matched client if the request worked
  /// An APIResponse containing an error message if not
  ///
  /// Parameters:
  /// - id: string -> the id of the client for who we need more information
  Future<APIResponse<ClientModel>> getById({required String id, required String email}) async{
    final String apiUrl = '${Constants.baseUrl}${Constants.clientEndpoint}/$id';

    try {

      String? token = await _auth.getUserToken();

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final jsonData = json.decode(response.body);
      jsonData["email"]=email;
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
  ///
  /// Parameters:
  /// - updateClient: ClientModel -> a Client object containing the different
  /// information to update
  Future<APIResponse<ClientModel>> updateClient({
    required ClientModel updateClient,
    required String email
  }) async {
    final String apiUrl = '${Constants.baseUrl}${Constants.clientEndpoint}/${updateClient.id}';

    try {

      String? token = await _auth.getUserToken();

      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(updateClient.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final jsonData = json.decode(response.body);
      jsonData["email"]=email;
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
