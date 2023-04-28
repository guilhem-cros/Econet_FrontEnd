import 'package:flutter/material.dart';
import 'package:image_upload/models/ecospot.dart';
import 'package:image_upload/screens/ecospots_lists/ecospots_list.dart';

import '../../widgets/custom_buttons/back_button.dart';
import '../forms/generalize_ecospot_form.dart';
import '../home/home.dart';

class EcospotFormScreen extends StatelessWidget{




  @override
  Widget build(BuildContext context) {

    void addEcospotToClient(EcospotModel ecospotModel){
      Home.currentClient!.createdEcospots.add(ecospotModel);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context )=> EcospotsListScreen(title: "Mes EcoSpots", isButtonVisible: true, ecospotsList: Home.currentClient!.createdEcospots)));
    }

    return Scaffold(
      appBar: _AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10,bottom: 15),
                child:Text("Ajouter un EcoSpot",style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ],
          ),
          Expanded(child: EcospotForm(isAdmin: Home.currentClient!.isAdmin, onSubmit: addEcospotToClient))
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
