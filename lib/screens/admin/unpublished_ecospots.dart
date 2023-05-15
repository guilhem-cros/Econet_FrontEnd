import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/DAOs/ecospot_DAO.dart';
import 'package:image_upload/models/ecospot.dart';

import '../../models/api_response.dart';
import '../ecospots/ecospots_list.dart';
import '../error/error_screen.dart';

/// Screen containing the list of all unpublished ecospots
class UnpublishedEcospotListScreen extends StatefulWidget{

  /// List of unpublished ecospots
  late List<EcospotModel> listUnpublishedEcospot ;

  UnpublishedEcospotListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return UnpublishedEcospotListState();
  }
}

class UnpublishedEcospotListState extends State<UnpublishedEcospotListScreen>{
  late Future<APIResponse<List<EcospotModel>>> _result;
  final ecospotDAO = EcospotDAO();

  @override
  void initState() {
    super.initState();
    _result = ecospotDAO.getUnpublishedEcoSpots();
  }

  void setUnpublishedEcospotList(List<EcospotModel> unpublishedEcospotList){
    widget.listUnpublishedEcospot = unpublishedEcospotList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            children: [
              FutureBuilder<APIResponse<List<EcospotModel>>>(
                  future: _result,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.error) {
                        return ErrorScreen(errorMessage: snapshot.data!.errorMessage!);
                      } else {
                        setUnpublishedEcospotList(snapshot.data!.data!);
                        return Expanded( child: EcospotsListScreen(
                            title: "Publications en attente",
                            isButtonVisible: false,
                            ecospotsList: widget.listUnpublishedEcospot,
                            isPublicationList: true,
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return ErrorScreen(errorMessage: snapshot.error.toString());
                    }
                    return Padding(
                        padding: EdgeInsets.only(
                            top: 0.5 * MediaQuery.of(context).size.height),
                        child: const CircularProgressIndicator());
                  }),
            ]),
      ),
    );
  }

}