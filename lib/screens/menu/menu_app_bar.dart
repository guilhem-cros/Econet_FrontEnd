import 'package:flutter/material.dart';
import 'package:image_upload/widgets/custom_buttons/back_button.dart';
import 'package:image_upload/widgets/custom_buttons/icon_button.dart';

import '../../services/auth.dart';

class MenuAppBar extends StatelessWidget with PreferredSizeWidget{

  @override
  final Size preferredSize = const Size.fromHeight(50.0);

  final AuthService _auth = AuthService();

  MenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leadingWidth: 110,
      elevation: 0,
      leading: const CustomBackButton(),
      actions: [
        CustomIconButton(onPressed: () {print("todo");}, icon: const Icon(Icons.edit),),
        const SizedBox(width: 10,),
        CustomIconButton(
          onPressed: () async {
            await _auth.signOut();
          },
          icon: const Icon(Icons.power_settings_new),
        ),
        const SizedBox(width: 3,),
      ],

    );
  }

}