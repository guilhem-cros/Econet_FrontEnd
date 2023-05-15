import 'dart:convert';

import 'package:image_upload/models/ecospot.dart';
import 'package:http/http.dart' as http;


import '../models/api_response.dart';
import '../services/auth.dart';
import '../utils/constants.dart';

class EcospotDAO{

  final AuthService _auth = AuthService();

  /// Create an EcoSpot in the DB
  /// Need the name, the address, the details, the tips, the mainTypeId and the pictureUrl of the ecospot.
  /// Also need the clientId of the client who creates the ecospot
  /// A list of the other types of the EcoSpot (otherTypes) can also be provided.
  /// By default, the EcoSpot isn't directly published (isPublished = false)
  /// Return an APIResponse of an EcospotModel, containing the created ecospot if everything
  /// worked, an error message if not
  ///
  /// Parameters:
  /// - name: string -> the name of the ecospot
  /// - address: string -> the address of the ecospot ("Lattitude;Longitude")
  /// - details: string -> the details concerning the ecospot
  /// - tips: string -> the tips concerning the ecospot
  /// - mainTypeId: string -> the id of the Type object linked to the ecospot
  /// - otherTypes: List<String>? -> an optional list containing the id of the the others Type objects linked to the ecospot
  /// - isPublished: bool -> a boolean by default equals to false which indicates if the ecospot is directly visible by all the clients
  /// - pictureUrl: string -> the url of the picture associated to the ecospot
  /// - clientId: string -> the id of the client who creates the ecospot
  Future<APIResponse<EcospotModel>> createEcospot({
    required String name,
    required String address,
    required String details,
    required String tips,
    required String mainTypeId,
    List<String>? otherTypes,
    bool isPublished = false,
    required String pictureUrl,
    required String clientId,

  }) async {
    final String apiUrl = '${Constants.baseUrl}${Constants.ecospotEndpoint}/$clientId';
    otherTypes ??= [];
    if(tips.isEmpty){ tips = " ";}
    try {

      String? token = await _auth.getUserToken();

      final body = jsonEncode({
        'name': name,
        'address': address,
        'details': details,
        'tips': tips,
        'main_type_id': mainTypeId,
        'other_types': otherTypes,
        'isPublished': isPublished,
        'picture_url': pictureUrl,
        });
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return APIResponse<EcospotModel>(data: EcospotModel.fromJson(jsonData));
      } else {
        return APIResponse<EcospotModel>(error: true, errorMessage: jsonData['message']);
      }

    } catch (err){
      return APIResponse<EcospotModel>(error: true, errorMessage: err.toString());
    }
  }


  /// Check if a specified string doesn't match any existing address in the DB
  /// Return an APIResponse containing the result of the request if no error
  /// An APIResponse containing an error message if not
  ///
  /// Parameters:
  /// - address: string -> the string corresponding to the address to verify
  Future<APIResponse<Map<String, dynamic>>> checkAddressUnique({
    required String address
  }) async {
    final String apiUrl = Constants.baseUrl + Constants.ecospotEndpoint + Constants.checkAddressEndpoint;

    try {

      String? token = await _auth.getUserToken();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({'address': address}),
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 201) {
        Map<String, dynamic> data = jsonData;
        // If the server returns a successful response
        return APIResponse<Map<String, dynamic>>(data: data);
      } else {
        // If the server returns an error response
        return APIResponse<Map<String, dynamic>>(error: true, errorMessage: jsonData['message']);
      }
    }catch(err){
      return APIResponse<Map<String, dynamic>>(error: true, errorMessage: err.toString());
    }
  }

  /// Get all the ecospots
  /// Return an APIResponse of a List<EcospotModel> containing the list of ecospots if the request worked
  /// An APIResponse containing an error message if not
  Future<APIResponse<List<EcospotModel>>> getAllEcoSpots() async{
    final String apiUrl = Constants.baseUrl + Constants.ecospotEndpoint;

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
      if (response.statusCode == 200){
        return APIResponse<List<EcospotModel>>(data:ecospotListFromJson(response.body));
      }
      else {
        return APIResponse(error: true, errorMessage: jsonData['message']);
      }
    } catch(err){
      return APIResponse(error: true, errorMessage: err.toString());
    }

  }

  /// Get all the unpublished ecospots
  /// Return an APIResponse of a List<EcospotModel> containing the list of unpublished ecospots if the request worked
  /// An APIResponse containing an error message if not
  Future<APIResponse<List<EcospotModel>>> getUnpublishedEcoSpots() async{
    final String apiUrl = Constants.baseUrl + Constants.ecospotEndpoint + Constants.unpublishedEndpoint;

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
      if (response.statusCode == 200){
        return APIResponse<List<EcospotModel>>(data:ecospotListFromJson(response.body));
      }
      else {
        return APIResponse(error: true, errorMessage: jsonData['message']);
      }
    } catch(err){
      return APIResponse(error: true, errorMessage: err.toString());
    }

  }

  /// Get all the published ecospots
  /// Return an APIResponse of a List<EcospotModel> containing the list of published ecospots if the request worked
  /// An APIResponse containing an error message if not
  Future<APIResponse<List<EcospotModel>>> getPublishedEcoSpots() async{
    final String apiUrl = Constants.baseUrl + Constants.ecospotEndpoint + Constants.publishedEndpoint;

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
      if (response.statusCode == 200){
        return APIResponse<List<EcospotModel>>(data:ecospotListFromJson(response.body));
      }
      else {
        return APIResponse(error: true, errorMessage: jsonData['message']);
      }
    } catch(err){
      return APIResponse(error: true, errorMessage: err.toString());
    }

  }


  /// Update the specified ecospot in the database
  /// Return an APIResponse containing the just updated ecospot if request worked
  /// An APIResponse containing an error message if not
  ///
  /// Parameters:
  /// - id: string -> the id of the ecospot to update
  /// - name: string -> the new name of the ecospot
  /// - address: string -> the new address of the ecospot ("Lattitude;Longitude")
  /// - details: string -> the new details concerning the ecospot
  /// - tips: string -> the new tips concerning the ecospot
  /// - mainTypeId: string -> the id of the new Type object linked to the ecospot
  /// - otherTypes: List<String>? -> a list containing the id of the the new others Type objects linked to the ecospot
  /// - isPublished: bool -> a boolean by default equals to false which indicates if the ecospot is directly visible by all the clients
  /// - pictureUrl: string -> the new url of the picture associated to the ecospot
  Future<APIResponse<EcospotModel>> updateEcospot({
    required String id,
    required String name,
    required String address,
    required String details,
    required String tips,
    required String mainTypeId,
    required List<String> otherTypes,
    required String pictureUrl,
    bool isPublished = false
  }) async {
    if(tips.isEmpty){ tips = " ";}
    final String apiUrl = '${Constants.baseUrl}${Constants.ecospotEndpoint}/${id}';

    try{

      String? token = await _auth.getUserToken();

      final body = jsonEncode({
        'name': name,
        'address': address,
        'details': details,
        'tips': tips,
        'main_type_id': mainTypeId,
        'other_types': otherTypes,
        'picture_url': pictureUrl,
        'isPublished': isPublished
      });

      final response = await http.put(
        Uri.parse(apiUrl),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final jsonData = json.decode(response.body);
      if(response.statusCode == 200) {
        return APIResponse(data: EcospotModel.fromJson(jsonData));
      } else{
        return APIResponse(error: true, errorMessage: jsonData['message']);
      }

    } catch(err) {
      return APIResponse(error: true, errorMessage: err.toString());
    }

  }


  /// Delete an ecospot from the DB by using its id
  /// Return the deleted spot in an APIResponse object
  /// Return an error in an APIResponse if an exception occured during operation
  ///
  /// Parameters:
  /// - id: string -> the id of the ecospot to delete
  Future<APIResponse<EcospotModel>> delete ({
    required String id
  }) async {
    final String apiUrl = '${Constants.baseUrl}${Constants.ecospotEndpoint}/${id}';

    try {

      String? token = await _auth.getUserToken();

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final jsonData = json.decode(response.body);
      if(response.statusCode == 200 || response.statusCode == 202 ||response.statusCode == 204) {
        return APIResponse(data: EcospotModel.fromJson(jsonData));
      } else{
        return APIResponse(error: true, errorMessage: jsonData['message']);
      }

    } catch (err) {
      return APIResponse(error: true, errorMessage: err.toString());
    }
}
}


