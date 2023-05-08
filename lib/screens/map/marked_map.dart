import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MarkedMap extends StatefulWidget{

  final PermissionStatus permission;

  const MarkedMap({super.key, required this.permission});

  @override
  State<MarkedMap> createState() => _MarkedMapState();

}

class _MarkedMapState extends State<MarkedMap>{

  late Future<LocationData>? userLocation;
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
    if(widget.permission == PermissionStatus.authorizedAlways || widget.permission == PermissionStatus.authorizedWhenInUse){
      userLocation = getLocation();
    } else {
      userLocation = null;
    }
  }

  CameraPosition getCamera(LocationData location) {
    return CameraPosition(
      target: LatLng(
        location.latitude!,
        location.longitude!,
      ),
      zoom: 14,
    );
  }

  void showPopUp(BuildContext context, String message){
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
      userLocation == null ?
        const GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
        )
      :
        FutureBuilder<LocationData>(
          future: userLocation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                initialCameraPosition: getCamera(snapshot.data!),
                mapType: MapType.normal,
                myLocationEnabled: true,
              );
            } else if (snapshot.hasError){
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