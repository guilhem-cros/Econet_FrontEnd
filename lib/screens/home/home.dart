import 'package:image_upload/DAOs/client_DAO.dart';
import 'package:image_upload/models/client.dart';
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

  late Future<ClientModel> _clientModel;

  @override
  void initState() {
    super.initState();
    ClientDAO clientDAO = ClientDAO();
    _clientModel = clientDAO.getByFirebaseId( uid: widget.firebaseId);
  }
  
  void setCurrentClient(ClientModel clientModel){
    Home.currentClient = clientModel;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: FutureBuilder<ClientModel>(
          future: _clientModel,
          builder: (context,snapshot){
            if(snapshot.hasData){
              setCurrentClient(snapshot.data!);
              return const Menu();
            }else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )
    )
    );
  }
}
