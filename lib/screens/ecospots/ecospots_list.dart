import 'package:flutter/material.dart';
import 'package:image_upload/DAOs/type_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/screens/ecospots/ecospot_form.dart';
import 'package:image_upload/widgets/custom_buttons/back_button.dart';

import '../../models/ecospot.dart';
import '../../models/type.dart';
import '../error/error_screen.dart';
import '../home/home.dart';
import 'ecospots_components/ecospot_list_builder/ecospots_list_builder.dart';

/// Generalized screen concerning list of ecospots
class EcospotsListScreen extends StatefulWidget{

  /// Title of the screen
  final String title;
  /// True if add button should be displayed
  final bool isButtonVisible;
  /// True if it's a list of unpublished ecospot
  final bool isPublicationList;
  /// The list used to build the screen
  final List<EcospotModel> ecospotsList;
  /// List of every types from the DB, used to filter the list
  late List<TypeModel> listType ;


  EcospotsListScreen({super.key, required this.title, required this.isButtonVisible, required this.ecospotsList, this.isPublicationList = false});

  @override
  State<StatefulWidget> createState() {
    return EcospotsListScreenState();
  }

}

class EcospotsListScreenState extends State<EcospotsListScreen>{

  late Future<APIResponse<List<TypeModel>>> _result;
  final typeDAO = TypeDAO();

  @override
  void initState() {
    super.initState();
    _result = typeDAO.getAll();
  }

  void setTypeList(List<TypeModel> typeList){
    widget.listType = typeList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: Center(
        child: FutureBuilder<APIResponse<List<TypeModel>>>(
        future: _result,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.error){
              return ErrorScreen(errorMessage: snapshot.data!.errorMessage!);
            } else {
              setTypeList(snapshot.data!.data!);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(widget.title, style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                      ),
                      if(widget.isButtonVisible)
                        IconButton(onPressed: () async {
                          final addedItem = await Navigator.push<EcospotModel>(context, MaterialPageRoute(builder:
                              (context) => EcospotFormScreen(isPublicationForm: widget.isPublicationList,)
                          ));
                          if(addedItem!=null) {
                            int index = widget.ecospotsList.indexWhere((spot) => spot.name.toUpperCase().compareTo(addedItem.name.toUpperCase()) > 0);
                            index == -1 ? widget.ecospotsList.add(addedItem) : widget.ecospotsList.insert(index, addedItem);
                            setState(() {});
                            if(widget.title != 'Mes EcoSpots'){
                              int index2 = Home.currentClient!.createdEcospots.indexWhere((spot) => spot.name.toUpperCase().compareTo(addedItem.name.toUpperCase()) > 0);
                              index2 == -1 ? Home.currentClient!.createdEcospots.add(addedItem) : Home.currentClient!.createdEcospots.insert(index2, addedItem);
                            }
                          }
                        }, icon: const Icon(
                          Icons.add, color: Color.fromRGBO(81, 129, 253, 1),))
                    ],
                  ),
                  Expanded(child: EcospotsListBuilder(
                    ecospotsList: widget.ecospotsList,
                    typeList: widget.listType,
                    isPublicationList: widget.isPublicationList,
                  ))
                ],
              );
            }
          }
          else if (snapshot.hasError) {
            return ErrorScreen(errorMessage: snapshot.error.toString());
          }
          return const CircularProgressIndicator();
          }
        )
      )
    );
  }
}

/// AppBar of the screen
class _AppBar extends StatelessWidget with PreferredSizeWidget{
  @override
  final Size preferredSize = const Size.fromHeight(50.0);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      leading: const CustomBackButton(),
      leadingWidth: 110,
    );
  }


}
