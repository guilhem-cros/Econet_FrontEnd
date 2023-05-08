import 'package:flutter/material.dart';
import 'package:image_upload/models/Ecospot.dart';
import 'package:image_upload/screens/menu/menu.dart';

class MapBar extends StatefulWidget{

  final List<EcospotModel> currentEcospotsList;
  final void Function() updateList;

  const MapBar({super.key, required this.currentEcospotsList, required this.updateList});

  @override
  State<MapBar> createState() => _MapBarState();

}

class _MapBarState extends State<MapBar>{

  final TextEditingController _searchController = TextEditingController();
  List<String> selectedEcospotTypes = [];

  @override
  Widget build(BuildContext context) {

    void _filterList(String query) {
      final List<EcospotModel> filteredList = widget.currentEcospotsList.where((ecospot) {
        bool matchesType = selectedEcospotTypes.isEmpty || selectedEcospotTypes.contains(ecospot.mainType.name);

        return matchesType;
      }).toList();

      widget.updateList();
    }

    final searchBar = SizedBox(
      width: 0.75*MediaQuery.of(context).size.width,
      height: 42,
      child: TextField(
        controller: _searchController,
        onChanged: _filterList,
        decoration: InputDecoration(
          labelText: 'Rechercher une adresse',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color.fromARGB(255, 238, 238, 238),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(0),
        ),
      )
    );

    final menuButton = ElevatedButton.icon(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder:
            (context) => Menu()
        ));
      },
      label: const Text("Mon Compte", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      icon: const Icon(Icons.account_circle_outlined, size: 28,),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(180, 48),
        backgroundColor: const Color.fromRGBO(238, 238 , 238, 1),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.only(top: 5, bottom: 2),
      width: MediaQuery.of(context).size.width,
      child:
        Column(
        children: [
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238 , 238, 1)))),
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                searchBar,
                IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.filter_alt_outlined),
                    iconSize: 28,
                )
              ],
            ),
          ),
          const SizedBox(height: 5,),
          menuButton,
        ],
      )
    );
  }



}