import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_upload/models/displayed_ecospot.dart';
import 'package:image_upload/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../models/ecospot.dart';

class MarkedMap extends StatefulWidget {

  final LocationPermission permission;
  final List<Marker> markers;
  final Position? cameraPosition;
  final void Function() showSpot;

  const MarkedMap({Key? key, required this.permission, required this.markers, this.cameraPosition, required this.showSpot}) : super(key: key);

  @override
  State<MarkedMap> createState() => _MarkedMapState();
}

class _MarkedMapState extends State<MarkedMap> {
  final Completer<GoogleMapController> _controller = Completer();

  late Future<Position>? userPosition;
  late bool userCentered;

  late DisplayedEcospot _changeNotifier;

  @override
  void initState() {
    super.initState();
    if (widget.permission == LocationPermission.always || widget.permission == LocationPermission.whileInUse) {
      userPosition = Geolocator.getCurrentPosition();
    } else {
      userPosition = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _changeNotifier = Provider.of<DisplayedEcospot>(context);
    setCameraAndOpenPopup(_changeNotifier.value);
  }

  void setCameraAndOpenPopup(EcospotModel? ecospot) async{
    if(ecospot!=null) {
      final mapController = await _controller.future;
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: ecospot.address.toLocation(), zoom: 17))
      );
      widget.showSpot();
    }
  }

  CameraPosition getCamera(Position position) {
    return CameraPosition(
      target: LatLng(
        position.latitude,
        position.longitude,
      ),
      zoom: 15,
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

    const CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(
        50.610769,
        8.876716,
      ),
      zoom: 15,
    );

    return Stack(
        children: [
          FutureBuilder<Position>(
              future: userPosition,
              builder: (context, snapshot) {
                if(snapshot.hasData || snapshot.hasError) {
                  if (snapshot.hasError) {
                    showPopUp(
                        context,
                        "Erreur lors de la localisation de l'appareil");
                  }
                  return GoogleMap(
                    initialCameraPosition: snapshot.hasData ? getCamera(
                        snapshot.data!) : kGooglePlex,
                    mapType: MapType.normal,
                    myLocationEnabled: userPosition != null,
                    markers: Set<Marker>.of(widget.markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
          ),
        ]
    );
  }
}
