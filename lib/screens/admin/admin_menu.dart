import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/screens/admin/all_ecospots.dart';
import 'package:image_upload/screens/types/type_list.dart';
import 'package:image_upload/screens/admin/unpublished_ecospots.dart';
import 'package:image_upload/widgets/menu_item.dart';
import 'dart:math' as math;

import '../../widgets/custom_buttons/back_button.dart';
import '../../widgets/wave.dart';

/// Screen corresponding to the admin menu page
class AdminMenu extends StatelessWidget{

  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      leading: const CustomBackButton(),
      leadingWidth: 110,
    );
    
    const iconColor = Color.fromRGBO(96, 96, 96, 1);

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 25),
                  child:const Text("Panel Admin",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                )],
              ),
              const SizedBox(height: 125,),
              MenuItem(label: "Données Analytiques", icon: const Icon(Icons.data_thresholding_outlined), iconColor: iconColor,
                  onTap: () { print("Analytics todo");}
                /*
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => EcospotsListScreen(title: 'Mes Ecospots', isButtonVisible: true, ecospotsList: Home.currentClient!.createdEcospots)
                    ));
                  } */
                ),
              const SizedBox(height: 28,),
              MenuItem(label: "Tous les EcoSpots", icon: const Icon(Icons.map_outlined), iconColor: iconColor,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => AllEcospotsListScreen()
                    ));
                  }
              ),
              const SizedBox(height: 28),
              MenuItem(label: "Publications en attente", icon: const Icon(Icons.check_circle_outline), iconColor: iconColor, 
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => UnpublishedEcospotListScreen()
                    ));
                  }
              ),
              const SizedBox(height: 28,),
              MenuItem(label: "Types de spot", icon: const Icon(Icons.eco_outlined), iconColor: iconColor,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                    (context) => TypeListScreen()
                    ));
                  }
              )
            ],
          ),
          Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(math.pi),
              child: Stack(
                  children: [Wave(0.4, 0.7, 0.6, height: 120 ,positionTop: 0, positionLeft: 0, positionRight: 0, label: "",)])
          )
        ],
      ),
    );
  }

}
