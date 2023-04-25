import 'package:image_upload/DAOs/client_DAO.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  final String firebaseId;
  Home({super.key, required this.firebaseId});

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home>{
  final AuthService _auth = new AuthService();
  late Future<ClientModel> _clientModel;
  static ClientModel? currentClient;

  @override
  void initState() {
    super.initState();
    ClientDAO clientDAO = ClientDAO();
    _clientModel = clientDAO.getByFirebaseId( uid: widget.firebaseId);
  }
  
  void setCurrentClient(ClientModel clientModel){
    currentClient = clientModel;
    print(currentClient!.email);
  }

  @override
  Widget build(BuildContext context) {


    final SignOut = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          await _auth.signOut();
        },
        child: Text(
          "Log out",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Demo App - HomePage'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: FutureBuilder<ClientModel>(
          future: _clientModel,
          builder: (context,snapshot){
            if(snapshot.hasData){
              setCurrentClient(snapshot.data!);
              return SignOut;
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
