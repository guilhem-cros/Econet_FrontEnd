import 'package:flutter/material.dart';
import 'package:image_upload/models/ecospot.dart';

import '../../widgets/custom_buttons/back_button.dart';
import '../forms/generalized_ecospot_form.dart';
import '../home/home.dart';

class EcospotFormScreen extends StatelessWidget{

  final EcospotModel? toUpdateEcospot;

  const EcospotFormScreen({super.key, this.toUpdateEcospot});

  @override
  Widget build(BuildContext context) {

    //TODO Refresh lists

    void addEcospotToClient(EcospotModel ecospotModel){
      Home.currentClient!.createdEcospots.add(ecospotModel);
    }

    void updateEcospotInList(EcospotModel updatedEcospot, List<EcospotModel> toUpdate){
      int index = toUpdate.indexWhere((ecospot) => ecospot.id == updatedEcospot.id);
      if (index != -1) {
        toUpdate[index] = updatedEcospot;
      }
    }

    return Scaffold(
      appBar: _AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10,bottom: 15),
                child:Text(toUpdateEcospot==null ? "Ajouter un EcoSpot" : "Modifier un EcoSpot",style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ],
          ),
          Expanded(child: EcospotForm(
            isAdmin: Home.currentClient!.isAdmin,
            onSubmit: toUpdateEcospot==null ? addEcospotToClient : (EcospotModel spot) {
                updateEcospotInList(spot, Home.currentClient!.createdEcospots);
                updateEcospotInList(spot, Home.currentClient!.favEcospots);
              },
            toUpdateEcospot: toUpdateEcospot,
          ))
        ],
      ),
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
