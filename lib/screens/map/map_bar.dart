import 'package:flutter/material.dart';
import 'package:image_upload/DAOs/type_DAO.dart';
import 'package:image_upload/models/ecospot.dart';
import 'package:image_upload/models/type.dart';
import 'package:image_upload/screens/menu/menu.dart';

class MapBar extends StatefulWidget{

  final List<EcospotModel> currentEcospotsList;
  final void Function(List<EcospotModel>) updateList;

  const MapBar({super.key, required this.currentEcospotsList, required this.updateList});

  @override
  State<MapBar> createState() => _MapBarState();

}

class _MapBarState extends State<MapBar>{

  final TextEditingController _searchController = TextEditingController();
  List<String> selectedEcospotTypes = [];
  List<TypeModel> typeList= [];

  bool loadingTypes = false;


  @override
  Widget build(BuildContext context) {

    void showPopUp(String message){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
          );
        },
      );
    }

    void _filterList() {
      final List<EcospotModel> filteredList = widget.currentEcospotsList.where((ecospot) {
        bool matchesType = selectedEcospotTypes.isEmpty || selectedEcospotTypes.contains(ecospot.mainType.id);

        bool matchesSecondaryType = false;
        int i =0;
        while(!matchesSecondaryType && i<ecospot.otherTypes.length){
          matchesSecondaryType = selectedEcospotTypes.contains(ecospot.otherTypes[i]);
          i++;
        }

        return matchesType || matchesSecondaryType;
      }).toList();
      widget.updateList(filteredList);
    }

    void _fetchFilter() async {
      setState(() {
        loadingTypes = true;
      });
      final typeDAO = TypeDAO();
      var result = await typeDAO.getAll();
      if(result.error){
        showPopUp(result.errorMessage!);
      } else {
        typeList = result.data!;
      }
      setState(() {
        loadingTypes = false;
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
            _filterList();
          });
        },
        itemBuilder: (BuildContext context) {
          List<TypeModel> ecospotTypes = [];
          if(typeList.isEmpty){
            _fetchFilter();
          }
          for (TypeModel type in typeList) {
            ecospotTypes.add(type);
          }

          return ecospotTypes.map((TypeModel type) {
            return PopupMenuItem<String>(
              value: type.id,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(type.name),
                  Icon(selectedEcospotTypes.contains(type.id)
                      ? Icons.check
                      : Icons.add),
                ],
              ),
            );
          }).toList();
        },
        position: PopupMenuPosition.over,
        icon: loadingTypes ?
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
            :
          const Icon(Icons.filter_alt_outlined, size: 26,)
      );
    }

    final searchBar = SizedBox(
      width: 0.75*MediaQuery.of(context).size.width,
      height: 42,
      child: TextField(
        controller: _searchController,
        onChanged: (String query){},
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
                buildFilterMenu(),
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