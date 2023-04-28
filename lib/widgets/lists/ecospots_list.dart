import 'package:flutter/material.dart';
import 'package:image_upload/DAOs/type_DAO.dart';
import 'package:image_upload/utils/extensions.dart';
import '../../models/ecospot.dart';
import '../../models/type.dart';
import '../ecospot_list_item.dart';


class EcospotsList extends StatefulWidget {
  final List<EcospotModel> ecospotsList;
  late List<TypeModel>? typeList;

  EcospotsList({Key? key, required this.ecospotsList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EcospotsList();
  }
}

class _EcospotsList extends State<EcospotsList> {
  List<EcospotModel>? _copyList;
  late Future<List<TypeModel>> _typeList;
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedEcospotTypes = [];

  @override
  void initState() {
    super.initState();
    _copyList = widget.ecospotsList;
    TypeDAO typeDAO = TypeDAO();
    _typeList = typeDAO.getAll();
  }

  void setTypeList(List<TypeModel> typeList){
    widget.typeList = typeList;
  }

  void _filterList(String query) {
    final List<EcospotModel> filteredList = widget.ecospotsList.where((ecospot) {
      bool matchesSearch = ecospot.name.contains(query) || ecospot.address.contains(query);
      bool matchesType = selectedEcospotTypes.isEmpty || selectedEcospotTypes.contains(ecospot.mainType.name);

      return matchesSearch && matchesType;
    }).toList();

    setState(() {
      _copyList = filteredList;
    });
  }

  Widget buildFilterMenu() {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          if (selectedEcospotTypes.contains(value)) {
            selectedEcospotTypes.remove(value);
          } else {
            selectedEcospotTypes.add(value);
          }
        });
        _filterList(_searchController.text);
      },
      itemBuilder: (BuildContext context) {
        List<String> ecospotTypes = [];
        for(TypeModel type in widget.typeList!){
          ecospotTypes.add(type.name);
        }

        return ecospotTypes.map((String type) {
          return PopupMenuItem<String>(
            value: type,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type),
                Icon(selectedEcospotTypes.contains(type) ? Icons.check : Icons.add),
              ],
            ),
          );
        }).toList();
      },
        icon: const Icon(Icons.filter_list)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<TypeModel>>(
          future: _typeList,
            builder: (context,snapshot){
            if (snapshot.hasData){
              setTypeList(snapshot.data!);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
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
                        const SizedBox(width: 8.0),
                        buildFilterMenu(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: widget.ecospotsList.isEmpty ?
                    Container(width: 0.9*MediaQuery.of(context).size.width, margin: const EdgeInsets.only(top: 50),
                        child: const Text("Aucun EcoSpot correspondant à la recherche.", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)) :
                    ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _copyList!.length,
                      itemBuilder: (context, index) {
                        print(_copyList![index].mainType.color);
                        return EcospotListItem( spotName: _copyList![index].name,
                            spotType: _copyList![index].mainType.name,
                            imageUrlType: _copyList![index].mainType.logoUrl,
                            spotColor: _copyList![index].mainType.color.toColor());
                        },
                    ),
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          }
        ),
      )
    );
  }
}
