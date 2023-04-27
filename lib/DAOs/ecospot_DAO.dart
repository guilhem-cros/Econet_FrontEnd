import 'dart:convert';

import 'package:image_upload/models/Ecospot.dart';
import 'package:http/http.dart' as http;


import '../models/api_response.dart';
import '../utils/constants.dart';

class EcospotDAO{

  Future<APIResponse<EcospotModel>> createEcospot({
    required String name,
    required String address,
    required String details,
    required String tips,
    required String main_type_id,
    String? other_types,
    bool isPublished = false,
    required String picture_url,
    required String clientId,

  }) async {
    final String apiUrl = Constants.baseUrl + Constants.ecospotEndpoint;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'name': name,
          'address': address,
          'details': details,
          'tips': tips,
          'main_type_id': main_type_id,
          'other_types': other_types,
          'isPublished': isPublished,
          'picture_url': picture_url,
          'clientId': clientId
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return APIResponse<EcospotModel>(data: EcospotModel.fromJson(jsonData));
      } else {
        return APIResponse<EcospotModel>(error: true, errorMessage: jsonData.error);
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
        return APIResponse<Map<String, dynamic>>(error: true, errorMessage: jsonData.error);
      }
    }catch(err){
      return APIResponse<Map<String, dynamic>>(error: true, errorMessage: err.toString());
    }
  }
}
