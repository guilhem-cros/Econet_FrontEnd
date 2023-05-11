import 'package:image_upload/DAOs/client_DAO.dart';
import 'package:image_upload/DAOs/ecospot_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/models/ecospot.dart';
import 'package:image_upload/screens/error/error_screen.dart';
import 'package:image_upload/screens/map/map_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  final String firebaseId;
  static ClientModel? currentClient;

  const Home({super.key, required this.firebaseId});

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home>{

  late Future<APIResponse<ClientModel>> _clientModel;
  late Future<APIResponse<List<EcospotModel>>> ecospots;
  late int _reloadCount;
  final ClientDAO clientDAO = ClientDAO();
  final EcospotDAO ecospotDAO = EcospotDAO();

  @override
  void initState() {
    super.initState();
    _clientModel = clientDAO.getByFirebaseId( uid: widget.firebaseId);
    _reloadCount = 0;
    ecospots = ecospotDAO.getPublishedEcoSpots();
  }
  
  void setCurrentClient(ClientModel clientModel){
    Home.currentClient = clientModel;
  }

  void reloadClientModel(){
    setState(() {
      _reloadCount++;
      _clientModel = clientDAO.getByFirebaseId( uid: widget.firebaseId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final ecospotLoading = FutureBuilder<APIResponse<List<EcospotModel>>>(
        future: ecospots,
        builder: (context,snapshot){
          List<EcospotModel>? listToSend;
          String errMsg = "";
          if(snapshot.hasData){
            if(!snapshot.data!.error){
              listToSend = snapshot.data!.data!;
            } else {
              errMsg = snapshot.data!.errorMessage!;
            }
          } else if (snapshot.hasError){
            errMsg = snapshot.error!.toString();
          }
          if(errMsg.isNotEmpty || listToSend != null){
             return MapScreen(
              ecospots: listToSend,
              errMsg: errMsg
             );
          }
          return const CircularProgressIndicator();
        },
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
