import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension StringExtension on Color {
  String toHexString() {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}

extension LatLngExtension on String {
  toLocation() {
    List<String> gpsList = split(";");

    double latitude = double.parse(gpsList[0]);
    double longitude = double.parse(gpsList[1]);

    return LatLng(latitude, longitude);
  }
}

extension GPSStringExtension on LatLng {
  toStoredString() {
    return("$latitude;$longitude");
  }
}
