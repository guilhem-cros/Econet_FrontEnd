import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/screens/menu/menu_app_bar.dart';

import '../../widgets/menu_item.dart';
import '../../widgets/profile_pic_display.dart';

/// Class building the main menu screen
class Menu extends StatelessWidget{

  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MenuAppBar(),
      body: Column(
          children: const [
            ProfilePicDisplay(
              profilePicUrl: 'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8&w=1000&q=80',
            ),
            MenuItem(label: "Favoris", icon: Icon(Icons.star), iconColor: Color.fromRGBO(255, 230, 0, 1),)
          ]
      )
    );
  }

}