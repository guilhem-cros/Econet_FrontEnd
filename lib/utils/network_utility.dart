import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_upload/utils/extensions.dart';

class NetworkUtility{
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async{
    try{
      final response = await http.get(uri, headers: headers);
      if(response.statusCode == 200){
        return response.body;
      }
    } catch(e){
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<String> getPlaceAddress(String latLng) async {
    double lat = latLng.toLocation().latitude;
    double long = latLng.toLocation().longitude;
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${dotenv.env['API_KEY']}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson['status'] == 'OK') {
        return responseJson['results'][0]['formatted_address'];
      } else {
        throw Exception('Failed to get address');
      }
    } else {
      throw Exception('Failed to get address');
    }
  }

  static Future<LatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  static Future<LatLng> getLatLng(String address) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/geocode/json',
        {
          "address": address,
          "key": dotenv.env['API_KEY'],
        }
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson['status'] == 'OK') {
        final location = responseJson['results'][0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      }
    }
    throw Exception('Failed to get LatLng');
  }
}
