import 'dart:convert';

import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/type.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

/// Get all existing types from the DB
/// Return an APIResponse of a list of TypeModel containing every type
/// AN APIResponse containing an error if the request didn't work
class TypeDAO{
  Future<APIResponse<List<TypeModel>>> getAll() async{
    final String apiUrl = Constants.baseUrl + Constants.typeEndpoint;

    try {
      final response = await http.get(
          Uri.parse(apiUrl));

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return APIResponse<List<TypeModel>>(data: typeListFromJson(response.body));
      }
      else {
        return APIResponse(error: true, errorMessage: jsonData['message']);
      }
    } catch(err){
      return APIResponse(error: true, errorMessage: err.toString());
    }
  }
}
