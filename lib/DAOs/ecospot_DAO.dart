import 'dart:convert';

import 'package:image_upload/models/ecospot.dart';
import 'package:http/http.dart' as http;


import '../models/api_response.dart';
import '../services/auth.dart';
import '../utils/constants.dart';

class EcospotDAO{

  final AuthService _auth = AuthService();

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


