import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_upload/screens/map/map_bar.dart';
import 'package:image_upload/screens/map/marked_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_upload/utils/extensions.dart';
import 'package:image_upload/widgets/ecospot_card.dart';

import '../../models/ecospot.dart';
import '../home/home.dart';

class MapScreen extends StatefulWidget {

  final List<EcospotModel>? ecospots;
  final String errMsg;

  const MapScreen({super.key, this.ecospots, this.errMsg = ""});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late Future<LocationPermission> permissionStatus;
  late List<EcospotModel> displayedEcospots;

  bool loadingMarkers = false;

  final List<Marker> _markers = [];
  Map<String, BitmapDescriptor> loadedUrl = {};

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

  Future<Uint8List> _loadMarkerIcon(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;

    final ui.Codec markerImageCodec = await instantiateImageCodec(
      bytes.buffer.asUint8List(),
      targetHeight: 70,
      targetWidth: 70,
    );

    final ui.FrameInfo frameinfo = await markerImageCodec.getNextFrame();

    final ByteData? byteData = await frameinfo.image.toByteData(
      format: ImageByteFormat.png,
    );

    return byteData!.buffer.asUint8List();

  }

  void showSpotInfo(EcospotModel ecospot){
    showDialog(context: context,
        builder: (context) {
          return EcospotCard(displayedEcospot: ecospot, favEcospots: Home.currentClient!.favEcospots, isAdmin: Home.currentClient!.isAdmin,);
        }
    );
  }

  void fillMarkers() async {
    setState(() {
      loadingMarkers = true;
    });
    if(widget.ecospots!=null) {
      for (EcospotModel spot in widget.ecospots!) {
        BitmapDescriptor icon;
        if(!loadedUrl.containsKey(spot.mainType.logoUrl)){
          icon = BitmapDescriptor.fromBytes(await _loadMarkerIcon(spot.mainType.logoUrl));
          loadedUrl[spot.mainType.logoUrl] = icon;
        } else {
          icon = loadedUrl[spot.mainType.logoUrl]!;
        }
        _markers.add(Marker(
          markerId: MarkerId(spot.id),
          position: spot.address.toLocation(),
          icon:icon,
          onTap: (){showSpotInfo(spot);},
        ));
      }
    }
    setState(() {
      loadingMarkers = false;
    });
  }


  @override
  void initState() {
    permissionStatus = getPermissionStatus();
    displayedEcospots = widget.ecospots == null ? [] : widget.ecospots!;
    fillMarkers();
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
            loadingMarkers ?
            const CircularProgressIndicator()
            :
            SafeArea(
                child: FutureBuilder<LocationPermission>(
                    future: permissionStatus,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data! == LocationPermission.whileInUse ||
                            snapshot.data! == LocationPermission.always) {
                          return MarkedMap(permission: snapshot.data!, markers: _markers,);
                        } else {
                          return FutureBuilder<LocationPermission>(
                              future: requestPermission(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return MarkedMap(permission: snapshot.data!, markers: _markers,);
                                } else if (snapshot.hasError) {
                                  return MarkedMap(
                                      permission: LocationPermission.denied, markers: _markers,);
                                }
                                else {
                                  return const Center(
                                    child: CircularProgressIndicator(),);
                                }
                              }
                          );
                        }
                      } else {
                        return FutureBuilder<LocationPermission>(
                            future: requestPermission(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return MarkedMap(permission: snapshot.data!, markers: _markers,);
                              } else if (snapshot.hasError) {
                                return MarkedMap(
                                    permission: LocationPermission.denied, markers: _markers,);
                              }
                              else {
                                return const Center(
                                  child: CircularProgressIndicator(),);
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
                //TODO update markers
              });
            }
          ),)
        ]
      ),
    );
  }
}
