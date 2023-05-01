import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/screens/ecospots_lists/ecospots_list.dart';
import 'package:image_upload/widgets/lists/ecospots_list.dart';

import '../../DAOs/ecospot_DAO.dart';
import '../../models/ecospot.dart';
import '../../models/api_response.dart';
import '../error/error_screen.dart';

class AllEcospotsListScreen extends StatefulWidget{

  late List<EcospotModel> listEcospots ;

  AllEcospotsListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AllEcospotsListState();
  }
}

class AllEcospotsListState extends State<AllEcospotsListScreen>{
  late Future<APIResponse<List<EcospotModel>>> _result;
  final ecospotDAO = EcospotDAO();

  @override
  void initState() {
    super.initState();
    _result = ecospotDAO.getAllEcoSpots();
  }

  void setAllEcospotsList(List<EcospotModel> ecospotsList){
    widget.listEcospots = ecospotsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Expanded(
          child: FutureBuilder<APIResponse<List<EcospotModel>>>(
              future: _result,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.error) {
                    return ErrorScreen(errorMessage: snapshot.data!.errorMessage!);
                  } else {
                    setAllEcospotsList(snapshot.data!.data!);
                    return EcospotsListScreen(
                        title: "Tous les EcoSpots",
                        isButtonVisible: true,
                        ecospotsList: widget.listEcospots);
                  }
                } else if (snapshot.hasError) {
                  return ErrorScreen(errorMessage: snapshot.error.toString());
                }
                return Padding(
                    padding: EdgeInsets.only(
                        top: 0.25 * MediaQuery.of(context).size.height),
                    child: const CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
