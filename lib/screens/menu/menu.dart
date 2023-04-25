import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/screens/home/home.dart';
import 'package:image_upload/screens/menu/menu_app_bar.dart';

import '../../widgets/menu_item.dart';
import '../../widgets/profile_pic_display.dart';

/// Class building the main menu screen
class Menu extends StatelessWidget{

  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(),
      body: Column(
          children: [
            ProfilePicDisplay(
              profilePicUrl: Home.currentClient!.profilePicUrl,
            ),
            Text(Home.currentClient!.pseudo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(height: 50,),
            const MenuItem(label: "Ecospots favoris", icon: Icon(Icons.star), iconColor: Color.fromRGBO(255, 230, 0, 1),),
            const SizedBox(height: 25,),
            const MenuItem(label: "Mes Ecospots", icon: Icon(Icons.pin_drop_outlined), iconColor: Color.fromRGBO(96, 96, 96, 1)),
            const SizedBox(height: 25,),
            if(Home.currentClient!.isAdmin)
              const MenuItem(label: 'Panel Admin', icon: Icon(Icons.admin_panel_settings_sharp), iconColor: Color.fromRGBO(96, 96, 96, 1))
          ]
      )
    );
  }

}