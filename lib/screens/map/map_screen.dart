import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_upload/screens/map/map_bar.dart';
import 'package:image_upload/screens/map/marked_map.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/ecospot.dart';

class MapScreen extends StatefulWidget {

  final List<EcospotModel>? ecospots;
  final String errMsg;

  const MapScreen({super.key, this.ecospots, this.errMsg = ""});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late Future<LocationPermission> permissionStatus;

  final List<Marker> _markers = [];

  final List<LatLng> _latLang = <LatLng>[
  ];

  void showError(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Erreur"),
          content: Text("Les ecospots n'ont pas pu être chargés.\n${widget.errMsg}"),
        );
      },
    );
  }

  Future<LocationPermission> getPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }


  @override
  void initState() {
    permissionStatus = getPermissionStatus();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(widget.errMsg.isNotEmpty){
        showError(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SafeArea(
                child: FutureBuilder<LocationPermission>(
                    future: permissionStatus,
                    builder: (context, snapshot){
                      if (snapshot.hasData) {
                        if(snapshot.data! == LocationPermission.whileInUse || snapshot.data! == LocationPermission.always) {
                          return MarkedMap(permission: snapshot.data!);
                        } else {
                          return FutureBuilder<LocationPermission>(
                              future: requestPermission(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  return MarkedMap(permission: snapshot.data!);
                                } else if(snapshot.hasError) {
                                  return const MarkedMap(permission: LocationPermission.denied);
                                }
                                else{
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                              }
                          );
                        }
                      } else {
                        return FutureBuilder<LocationPermission>(
                            future: requestPermission(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return MarkedMap(permission: snapshot.data!);
                              } else if(snapshot.hasError) {
                                return const MarkedMap(permission: LocationPermission.denied);
                              }
                              else{
                                return const Center(child: CircularProgressIndicator(),);
                              }
                            }
                        );
                      }
                    }
                )
            ),
            Positioned(bottom: 0,child: MapBar(currentEcospotsList: [], updateList: (){}),)
          ]
      ),
    );
  }
}
