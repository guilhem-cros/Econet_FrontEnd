import 'package:image_upload/DAOs/client_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/screens/error/error_screen.dart';
import 'package:image_upload/screens/menu/menu.dart';
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
  late int _reloadCount;
  final ClientDAO clientDAO = ClientDAO();

  @override
  void initState() {
    super.initState();
    _clientModel = clientDAO.getByFirebaseId( uid: widget.firebaseId);
    _reloadCount = 0;
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
                return Menu();
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
