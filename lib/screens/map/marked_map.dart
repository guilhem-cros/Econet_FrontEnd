import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkedMap extends StatefulWidget {

  final LocationPermission permission;

  const MarkedMap({Key? key, required this.permission}) : super(key: key);

  @override
  State<MarkedMap> createState() => _MarkedMapState();
}

class _MarkedMapState extends State<MarkedMap> {

  late Future<Position>? userPosition;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(
      50.610769,
      8.876716,
    ),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    if (widget.permission == LocationPermission.always || widget.permission == LocationPermission.whileInUse) {
      userPosition = Geolocator.getCurrentPosition();
    } else {
      userPosition = null;
    }
  }

  CameraPosition getCamera(Position position) {
    return CameraPosition(
      target: LatLng(
        position.latitude,
        position.longitude,
      ),
      zoom: 14,
    );
  }

  void showPopUp(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          userPosition == null
              ? const GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
          )
              : FutureBuilder<Position>(
              future: userPosition,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    initialCameraPosition: getCamera(snapshot.data!),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                  );
                } else if (snapshot.hasError) {
                  showPopUp(context, "Erreur lors de la localisation de l'appareil");
                  return const GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
          ),
        ]
    );
  }
}
