import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/utils/extensions.dart';
import 'package:image_upload/widgets/type_list_item.dart';

import '../../models/type.dart';

class TypeList extends StatefulWidget {

  final List<TypeModel> typeList;

  const TypeList({super.key, required this.typeList});

  @override
  State<StatefulWidget> createState() {
    return TypeListState();
  }

}

class TypeListState extends State<TypeList> {

  late List<TypeModel> _copyList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _copyList = widget.typeList;
    super.initState();
  }

  void _filterList(String query){
    final List<TypeModel> filteredList = widget.typeList.where((type){
      return type.name.toUpperCase().contains(query.toUpperCase()) || type.description.toUpperCase().contains(query.toUpperCase());
    }).toList();

    setState(() {
      _copyList = filteredList;
    });
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
                  );
                },
            )
          ),
        ])
      )
    );
  }

}