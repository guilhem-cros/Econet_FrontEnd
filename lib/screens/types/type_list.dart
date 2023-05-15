import 'package:flutter/material.dart';
import 'package:image_upload/screens/types/type_form.dart';
import 'package:image_upload/screens/types/types_components/type_list_builder/type_list_builder.dart';

import '../../DAOs/type_DAO.dart';
import '../../models/api_response.dart';
import '../../models/type.dart';
import '../../widgets/custom_buttons/back_button.dart';
import '../error/error_screen.dart';

class TypeListScreen extends StatefulWidget{

  late List<TypeModel> listType ;

  TypeListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TypeListState();
  }

}

class TypeListState extends State<TypeListScreen>{

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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text("Types de spots", style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                  ),
                  IconButton(onPressed: () async {
                    final addedType = await Navigator.push<TypeModel>(context, MaterialPageRoute(builder:
                        (context) => const TypeFormScreen()
                    ));
                    if(addedType!=null){
                      int index = widget.listType.indexWhere((type) => type.name.toUpperCase().compareTo(addedType.name.toUpperCase()) > 0);
                      index == -1 ? widget.listType.add(addedType) : widget.listType.insert(index, addedType);
                      setState(() {});
                    }
                  }, icon: const Icon(
                    Icons.add, color: Color.fromRGBO(81, 129, 253, 1),))
                ],
              ),
              FutureBuilder<APIResponse<List<TypeModel>>>(
                future: _result,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.error) {
                      return ErrorScreen(errorMessage: snapshot.data!.errorMessage!);
                    } else {
                      setTypeList(snapshot.data!.data!);
                      return Expanded(child: TypeListBuilder(typeList: widget.listType));
                    }
                  } else if (snapshot.hasError){
                    return ErrorScreen(errorMessage: snapshot.error.toString());
                  }
                  return Padding(padding: EdgeInsets.only(top: 0.25*MediaQuery.of(context).size.height), child:const CircularProgressIndicator());
                }
              )
            ]
          )
        )
      );
  }

}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
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