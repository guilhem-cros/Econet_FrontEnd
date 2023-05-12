import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_upload/DAOs/ecospot_DAO.dart';
import 'package:image_upload/screens/map/map_bar.dart';
import 'package:image_upload/screens/map/marked_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_upload/utils/extensions.dart';
import 'package:image_upload/widgets/custom_buttons/icon_button.dart';
import 'package:image_upload/screens/ecospots/ecospot_card.dart';
import 'package:provider/provider.dart';

import '../../DAOs/client_DAO.dart';
import '../../models/displayed_ecospot.dart';
import '../../models/ecospot.dart';
import '../ecospots/ecospot_form.dart';
import '../home/home.dart';

class MapScreen extends StatefulWidget {

  final List<EcospotModel>? ecospots;
  final String errMsg;
  final Future<void> Function() reload;

  const MapScreen({super.key, this.ecospots, this.errMsg = "", required this.reload});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late Future<LocationPermission> permissionStatus;
  late List<EcospotModel> displayedEcospots;

  bool loadingMarkers = false;

  final List<Marker> _markers = [];
  Map<String, BitmapDescriptor> loadedUrl = {};
  LatLng? searchedLocation;

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

  void updateEcospotInList(EcospotModel updatedEcospot, List<EcospotModel> toUpdate){
    int index = toUpdate.indexWhere((ecospot) => ecospot.id == updatedEcospot.id);
    if (index != -1) {
      toUpdate[index] = updatedEcospot;
    }
    toUpdate.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
  }

  void updateLists(EcospotModel toUpdate){
    updateEcospotInList(toUpdate, widget.ecospots!);
    updateEcospotInList(toUpdate, displayedEcospots);
    updateEcospotInList(toUpdate, Home.currentClient!.createdEcospots);
    updateEcospotInList(toUpdate, Home.currentClient!.favEcospots);
    fillMarkers();
    setState(() {});
  }

  void deleteIn(EcospotModel toDelete, List<EcospotModel> list){
    int index = list.indexWhere((spot) => spot.id == toDelete.id);
    if(index!=-1){
      list.removeAt(index);
    }
  }

  void onDelete(EcospotModel toDelete){

    final EcospotDAO dao = EcospotDAO();
    dao.delete(id: toDelete.id);

    deleteIn(toDelete, widget.ecospots!);
    deleteIn(toDelete, displayedEcospots);
    deleteIn(toDelete, Home.currentClient!.favEcospots);
    deleteIn(toDelete, Home.currentClient!.createdEcospots);

    int index = _markers.indexWhere((element) => element.markerId.value == toDelete.id);
    if(index!=-1){
      _markers.removeAt(index);
    }
    setState(() {});
  }

  void onFav(bool isFav, EcospotModel ecospot){
    if(isFav){
      Home.currentClient!.favEcospots.add(ecospot);
    } else {
      int index = Home.currentClient!.favEcospots.indexWhere((spot) => ecospot.id == spot.id);
      Home.currentClient!.favEcospots.removeAt(index);
    }
    final ClientDAO clientDAO = ClientDAO();
    clientDAO.updateClient(updateClient: Home.currentClient!);
  }

  void showSpotInfo() async {
    await showDialog(context: context,
        builder: (context) {
          EcospotModel? ecospot = Provider.of<DisplayedEcospot>(context, listen: false).value;
          if(ecospot!=null) {
            return EcospotCard(
              displayedEcospot: ecospot,
              favEcospots: Home.currentClient!.favEcospots,
              isAdmin: Home.currentClient!.isAdmin,
              onUpdate: (EcospotModel spot) {
                  Provider.of<DisplayedEcospot>(context, listen: false).value = spot;
                  updateLists(spot);
              },
              onDelete: () {
                onDelete(Provider.of<DisplayedEcospot>(context, listen: false).value!);
              },
              onFav: (bool isFav) {
                onFav(isFav, ecospot);
              },
            );
          } else {
            return const AlertDialog(
              title: Text("Erreur"),
              content: Text("L'ecospot n'a pas pu être chargé."),
            );
          }
        },
    ).then((value){
      if(value){
        setState(() {
          searchedLocation = null;
        });
        Provider.of<DisplayedEcospot>(context, listen: false).value=null;
      }
    });
  }

  void fillMarkers() async {
    setState(() {
      _markers.clear();
      loadingMarkers = true;
    });
    if(widget.ecospots!=null) {
      for (EcospotModel spot in displayedEcospots) {
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
          onTap: (){
            Provider.of<DisplayedEcospot>(context, listen: false).value=spot;
          },
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

  void hasCreated() async {
    final addedItem = await Navigator.push<EcospotModel>(context, MaterialPageRoute(builder:
        (context) => const EcospotFormScreen(isPublicationForm: false,)
    ));
    if(addedItem!=null) {
      if(Home.currentClient!.isAdmin) { //adding to map if client is admin (means that ecospot is set as published)
        if (widget.ecospots != null) {
          widget.ecospots!.add(addedItem);
        }
        displayedEcospots.add(addedItem);
        BitmapDescriptor icon = BitmapDescriptor.fromBytes(
            await _loadMarkerIcon(addedItem.mainType.logoUrl));
        _markers.add(Marker(
          markerId: MarkerId(addedItem.id),
          position: addedItem.address.toLocation(),
          icon: icon,
          onTap: () {
            Provider.of<DisplayedEcospot>(context, listen: false).value = addedItem;
          },
        ));
      }
      int index2 = Home.currentClient!.createdEcospots.indexWhere((spot) => spot.name.toUpperCase().compareTo(addedItem.name.toUpperCase()) > 0);
      index2 == -1 ? Home.currentClient!.createdEcospots.add(addedItem) : Home.currentClient!.createdEcospots.insert(index2, addedItem);
      setState(() {});
    }
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
                          return MarkedMap(permission: snapshot.data!, markers: _markers, showSpot: showSpotInfo, searchedLocation: searchedLocation,);
                        } else {
                          return FutureBuilder<LocationPermission>(
                              future: requestPermission(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return MarkedMap(permission: snapshot.data!, markers: _markers,showSpot: showSpotInfo, searchedLocation: searchedLocation);
                                } else if (snapshot.hasError) {
                                  return MarkedMap(
                                      permission: LocationPermission.denied, markers: _markers,showSpot: showSpotInfo, searchedLocation: searchedLocation);
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
                                return MarkedMap(permission: snapshot.data!, markers: _markers, showSpot: showSpotInfo, searchedLocation: searchedLocation);
                              } else if (snapshot.hasError) {
                                return MarkedMap(
                                  permission: LocationPermission.denied,
                                  markers: _markers,
                                  showSpot: showSpotInfo,
                                  searchedLocation: searchedLocation
                                );
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
          Positioned(
            bottom: 150,
            right: 15,
            child: CustomIconButton(
              onPressed: hasCreated,
              icon: const Icon(Icons.add),
              backgroundColor: Colors.white,
              iconColor: const Color.fromRGBO(3, 208, 36, 1),
              radius: 30,
              size: 30,
              stroke: true,
            ),
          ),
          Positioned(bottom: 0,
            child: MapBar(currentEcospotsList: displayedEcospots, allEcospots: widget.ecospots == null ? [] : widget.ecospots!,
            updateList: (List<EcospotModel> updatedList){
              setState(() {
                displayedEcospots = updatedList;
                fillMarkers();
              });
            },
            onSearch: (LatLng? latlgn){
              setState(() {
                searchedLocation = latlgn;
              });
            },
          ),)
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.reload();
          setState(() {
            displayedEcospots = widget.ecospots == null ? [] : widget.ecospots!;
            fillMarkers();
            if(widget.errMsg.isNotEmpty){
              showError(context);
            }
          });
        },
        child: const Icon(Icons.refresh)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
