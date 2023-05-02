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


  /// Check if a name and color is already taken by another type in DB
  /// If its the case returns false
  /// If not returns true
  Future<APIResponse<bool>> isTypeUnique({
    required String name,
    required String color,
    String? typeId
  }) async {
    final allTypes = await getAll();

    if(allTypes.error){
      return APIResponse(error: true, errorMessage: allTypes.errorMessage!);
    }

    final typeList = allTypes.data!;
    for(var currType in typeList){
      if(currType.color == color
      || currType.name.toUpperCase() == name.toUpperCase()) {
        if((typeId!=null && typeId != currType.id) || typeId == null){
          return APIResponse(data: false);
        }
      }
    }
    return APIResponse(data: true);
  }

  /// Tries to create a type into the DB
  /// Return the ApiResponse containing the type if sucess
  /// An APIResponse containing an error if not
  Future<APIResponse<TypeModel>> create({
    required String name,
    required String color,
    required String description,
    required String logoUrl
  }) async {
    final String apiUrl = Constants.baseUrl + Constants.typeEndpoint;

    try{
      final body = jsonEncode({
        'name': name,
        'color': color,
        'description': description,
        'logo_url': logoUrl
      });
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final jsonData = json.decode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        return APIResponse(data: TypeModel.fromJson(jsonData));
      } else {
        return APIResponse(error: true, errorMessage: jsonData['message']);
      }
    } catch(err) {
      return APIResponse(error: true, errorMessage: err.toString());
    }
  }
}
