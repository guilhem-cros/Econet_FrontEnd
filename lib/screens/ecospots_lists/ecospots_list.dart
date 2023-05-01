import 'package:flutter/material.dart';
import 'package:image_upload/DAOs/type_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/screens/ecospots/ecospot_form.dart';
import 'package:image_upload/widgets/custom_buttons/back_button.dart';
import 'package:image_upload/widgets/lists/ecospots_list.dart';

import '../../models/ecospot.dart';
import '../../models/type.dart';
import '../error/error_screen.dart';

class EcospotsListScreen extends StatefulWidget{

  final String title;
  final bool isButtonVisible;
  final List<EcospotModel> ecospotsList;
  late List<TypeModel> listType ;


  EcospotsListScreen({super.key, required this.title, required this.isButtonVisible, required this.ecospotsList});

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
                        IconButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder:
                              (context) => const EcospotFormScreen()
                          ));
                        }, icon: const Icon(
                          Icons.add, color: Color.fromRGBO(81, 129, 253, 1),))
                    ],
                  ),
                  Expanded(child: EcospotsList(
                    ecospotsList: widget.ecospotsList,
                    typeList: widget.listType,))
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
