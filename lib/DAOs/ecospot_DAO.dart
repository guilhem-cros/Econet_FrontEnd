import 'dart:convert';

import 'package:image_upload/models/ecospot.dart';
import 'package:http/http.dart' as http;


import '../models/api_response.dart';
import '../utils/constants.dart';

class EcospotDAO{

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
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
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
      final response = await http.get(
          Uri.parse(apiUrl));
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
    required String pictureUrl
  }) async {
    if(tips.isEmpty){ tips = " ";}
    final String apiUrl = '${Constants.baseUrl}${Constants.ecospotEndpoint}/${id}';

    try{
      final body = jsonEncode({
        'name': name,
        'address': address,
        'details': details,
        'tips': tips,
        'main_type_id': mainTypeId,
        'other_types': otherTypes,
        'picture_url': pictureUrl,
      });

      final response = await http.put(
        Uri.parse(apiUrl),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        }
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
}


