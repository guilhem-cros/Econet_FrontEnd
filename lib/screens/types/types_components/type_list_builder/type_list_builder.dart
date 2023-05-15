import 'package:flutter/material.dart';
import 'package:image_upload/models/type.dart';
import 'package:image_upload/screens/types/type_form.dart';
import 'package:image_upload/screens/types/types_components/type_list_builder/type_list_item.dart';
import 'package:image_upload/utils/extensions.dart';

/// Widget building a list of types
class TypeListBuilder extends StatefulWidget {

  /// The types displayed in the list
  final List<TypeModel> typeList;

  const TypeListBuilder({super.key, required this.typeList});

  @override
  State<StatefulWidget> createState() {
    return TypeListBuilderState();
  }

}

class TypeListBuilderState extends State<TypeListBuilder> {

  late List<TypeModel> _copyList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _copyList = widget.typeList;
    super.initState();
  }

  /// Update the list with specified updated type
  void updateList(TypeModel updatedType){
    int index = widget.typeList.indexWhere((type) => type.id == updatedType.id);
    if(index != -1){
      widget.typeList[index] = updatedType;
    }
    widget.typeList.sort((a,b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    setState(() {});
  }

  /// Filters the list by name of type
  void _filterList(String query){
    final List<TypeModel> filteredList = widget.typeList.where((type){
      return type.name.toUpperCase().contains(query.toUpperCase()) || type.description.toUpperCase().contains(query.toUpperCase());
    }).toList();

    setState(() {
      _copyList = filteredList;
    });
  }

  /// Called when an item of the list if tapped.
  /// Opens the update form of the tapped item
  void tapItem(TypeModel type) async {
    final updatedItem = await Navigator.push(context, MaterialPageRoute(builder:
    (context) => TypeFormScreen(toUpdateType: type,)
    ));
    if(updatedItem!=null){
      updateList(updatedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              width: 0.95*MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(bottom: 8),
              child:
                TextField(
                  controller: _searchController,
                  onChanged: _filterList,
                  decoration: InputDecoration(
                    labelText: 'Rechercher',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 238, 238, 238),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(2),
                  ),
                ),
            ),
            Expanded(
            child: _copyList.isEmpty ?
            Container(width: 0.9*MediaQuery.of(context).size.width, margin: const EdgeInsets.only(top: 50),
                child: const Text("Aucun Type correspondant à la recherche.", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,))
            :
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _copyList.length,
                itemBuilder: (context, index){
                  return TypeListItem(
                      typeName: _copyList[index].name,
                      typeColor: _copyList[index].color.toColor(),
                      typeLogoUrl: _copyList[index].logoUrl,
                      onTap: (){tapItem(_copyList[index]);},
                  );
                },
            )
          ),
        ])
      )
    );
  }

}