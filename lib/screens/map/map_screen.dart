import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_upload/screens/map/map_bar.dart';
import 'package:image_upload/screens/map/marked_map.dart';
import 'package:location/location.dart';

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

  late Future<PermissionStatus> permissionStatus;
  late List<EcospotModel> displayedEcospots;

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


  @override
  void initState() {
    permissionStatus = getPermissionStatus();
    displayedEcospots = widget.ecospots == null ? [] : widget.ecospots!;
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
            child: FutureBuilder<PermissionStatus>(
              future: permissionStatus,
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  if(snapshot.data! == PermissionStatus.authorizedWhenInUse || snapshot.data! == PermissionStatus.authorizedAlways) {
                    return MarkedMap(permission: snapshot.data!);
                  } else {
                    return FutureBuilder<PermissionStatus>(
                        future: requestPermission(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return MarkedMap(permission: snapshot.data!);
                          } else if(snapshot.hasError) {
                            return const MarkedMap(permission: PermissionStatus.denied);
                          }
                          else{
                            return const Center(child: CircularProgressIndicator(),);
                          }
                        }
                    );
                  }
                } else {
                  return FutureBuilder<PermissionStatus>(
                      future: requestPermission(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return MarkedMap(permission: snapshot.data!);
                        } else if(snapshot.hasError) {
                          return const MarkedMap(permission: PermissionStatus.denied);
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
          Positioned(bottom: 0,
            child: MapBar(currentEcospotsList: widget.ecospots == null ? [] : widget.ecospots!,
            updateList: (List<EcospotModel> updatedList){
              setState(() {
                displayedEcospots = updatedList;
              });
            }
          ),)
        ]
      ),
    );
  }
}