import 'package:flutter/material.dart';
import 'package:image_upload/screens/ecospots/ecospot_form.dart';
import 'package:image_upload/utils/extensions.dart';
import '../../models/ecospot.dart';
import '../../models/type.dart';
import '../../screens/home/home.dart';
import '../ecospot_list_item.dart';


class EcospotsList extends StatefulWidget {
  final List<EcospotModel> ecospotsList;
  final List<TypeModel> typeList;
  final bool isPublicationList;

  const EcospotsList({Key? key, required this.ecospotsList, required this.typeList, this.isPublicationList = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EcospotsList();
  }
}

class _EcospotsList extends State<EcospotsList> {
  List<EcospotModel>? _copyList;
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedEcospotTypes = [];

  @override
  void initState() {
    super.initState();
    _copyList = widget.ecospotsList;
  }

  void _filterList(String query) {
    final List<EcospotModel> filteredList = widget.ecospotsList.where((ecospot) {
      bool matchesSearch = ecospot.name.toUpperCase().contains(query.toUpperCase()) || ecospot.address.toUpperCase().contains(query.toUpperCase());
      bool matchesType = selectedEcospotTypes.isEmpty || selectedEcospotTypes.contains(ecospot.mainType.name);

      return matchesSearch && matchesType;
    }).toList();

    setState(() {
      _copyList = filteredList;
    });
  }

  void updateEcospotInList(EcospotModel updatedEcospot, List<EcospotModel> toUpdate){
    int index = toUpdate.indexWhere((ecospot) => ecospot.id == updatedEcospot.id);
    if (index != -1) {
      toUpdate[index] = updatedEcospot;
    }
    toUpdate.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
  }


  void tapItem(EcospotModel ecospot) async {
    if(widget.isPublicationList){
      final toRemoveItem = await Navigator.push(context, MaterialPageRoute(builder:
      (context) => EcospotFormScreen(toUpdateEcospot: ecospot, isPublicationForm: true)
      ));
      if(toRemoveItem == null ){
        int index = widget.ecospotsList.indexWhere((spot) => spot.id == ecospot.id);
        widget.ecospotsList.removeAt(index);
      } else {
        int index = widget.ecospotsList.indexWhere((spot) => spot.id == toRemoveItem.id);
        widget.ecospotsList.removeAt(index);
      }
      setState(() {});
    }

    else { //TODO redirect to popup card
      final updatedItem = await Navigator.push(context, MaterialPageRoute(builder:
      (context) => EcospotFormScreen(toUpdateEcospot: ecospot)
      ));
      if(updatedItem!=null){
        updateEcospotInList(updatedItem, widget.ecospotsList);
        setState(() {});
        updateEcospotInList(updatedItem, Home.currentClient!.createdEcospots);
        updateEcospotInList(updatedItem, Home.currentClient!.favEcospots);
      }
    }
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
        for(TypeModel type in widget.typeList){
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
        child: Column(
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
              child: _copyList!.isEmpty ?
              Container(width: 0.9*MediaQuery.of(context).size.width, margin: const EdgeInsets.only(top: 50),
                  child: const Text("Aucun EcoSpot correspondant à la recherche.", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)) :
              ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _copyList!.length,
                itemBuilder: (context, index) {
                  return EcospotListItem( spotName: _copyList![index].name,
                      spotType: _copyList![index].mainType.name,
                      imageUrlType: _copyList![index].mainType.logoUrl,
                      spotColor: _copyList![index].mainType.color.toColor(),
                      onTap: () { tapItem(_copyList![index]); },);
                  },
              ),
            ),
          ],
        )
      ),
    );
  }
}
