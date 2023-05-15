import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  ///Extension which allows to capitalize the first letter of a string and the others letters in lower case
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension ColorExtension on String {
  ///Extension which allows to convert a String to a Color object
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension StringExtension on Color {
  ///Extension which allows to convert a Color to a String (on hex format)
  String toHexString() {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}

extension LatLngExtension on String {
  ///Extension which allows to transform a String in "double;double" format to a LatLng object
  toLocation() {
    List<String> gpsList = split(";");

    double latitude = double.parse(gpsList[0]);
    double longitude = double.parse(gpsList[1]);

    return LatLng(latitude, longitude);
  }
}

extension GPSStringExtension on LatLng {
  ///Extension which allows to transform a LatLng object to a String "double;double"
  toStoredString() {
    return("$latitude;$longitude");
  }
}
