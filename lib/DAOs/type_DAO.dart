import 'dart:convert';

import 'package:image_upload/models/type.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class TypeDAO{
  Future<List<TypeModel>> getAll() async{
    final String apiUrl = Constants.baseUrl + Constants.typeEndpoint;
    final response = await http.get(
        Uri.parse(apiUrl));
    if (response.statusCode == 200){
      return typeListFromJson(response.body);
    }
    else{
      throw Exception("Failed to load client");
    }
  }
}
