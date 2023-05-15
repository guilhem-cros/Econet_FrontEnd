import 'package:image_upload/DAOs/client_DAO.dart';
import 'package:image_upload/DAOs/ecospot_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/models/ecospot.dart';
import 'package:image_upload/screens/error/error_screen.dart';
import 'package:image_upload/screens/map/map_screen.dart';
import 'package:flutter/material.dart';

/// Home page of the app
class Home extends StatefulWidget{

  /// Firebase uid of the connected client
  final String firebaseId;
  /// Currently connected client
  static ClientModel? currentClient;

  const Home({super.key, required this.firebaseId});

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home>{

  /// Currently connected client fetched from the DB
  late Future<APIResponse<ClientModel>> _clientModel;
  /// List of published ecospots fetched from the DB
  late Future<APIResponse<List<EcospotModel>>> ecospots;
  late int _reloadCount;
  final ClientDAO clientDAO = ClientDAO();
  final EcospotDAO ecospotDAO = EcospotDAO();
  /// Ecospots to display on the map
  List<EcospotModel>? listToSend;
  /// Error message returned during the fetch of ecospots
  String errMsg="";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();


  /// Fetch published ecospots from the DB and store them into listToSend
  Future<void> _reloadData() async {
    final response = await ecospotDAO.getPublishedEcoSpots();
    setState(() {
      if (!response.error) {
        listToSend = response.data;
      } else {
        errMsg = response.errorMessage ?? "Unknown error";
      }
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    _clientModel = clientDAO.getByFirebaseId( uid: widget.firebaseId);
    _reloadCount = 0;
    _reloadData();
  }
  
  void setCurrentClient(ClientModel clientModel){
    Home.currentClient = clientModel;
  }

  /// Refetch the client
  void reloadClientModel(){
    setState(() {
      _reloadCount++;
      _clientModel = clientDAO.getByFirebaseId( uid: widget.firebaseId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final ecospotLoading = RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _reloadData,
      child: listToSend != null
          ? MapScreen(
        ecospots: listToSend,
        errMsg: errMsg,
        reload: () async {
          await _refreshIndicatorKey.currentState!.show();
          return _reloadData();
        }
      )
          : const Center(child: CircularProgressIndicator()),
    );

    return Scaffold(
      body: Center(
        child: _reloadCount > 3 ?
        const ErrorScreen(errorMessage: "Délai de chargement dépassé.")
            :
        FutureBuilder<APIResponse<ClientModel>>(
          future: _clientModel,
          builder: (context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.error){
                reloadClientModel();
                return const CircularProgressIndicator();
              } else {
                setCurrentClient(snapshot.data!.data!);
                return ecospotLoading;
               }
            }else if (snapshot.hasError) {
              return ErrorScreen(errorMessage: snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          },
        )
    )
    );
  }
}
