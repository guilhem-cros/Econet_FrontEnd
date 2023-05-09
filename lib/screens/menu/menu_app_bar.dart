import 'package:flutter/material.dart';
import 'package:image_upload/screens/account/update_client_form.dart';
import 'package:image_upload/widgets/custom_buttons/back_button.dart';
import 'package:image_upload/widgets/custom_buttons/icon_button.dart';

import '../../services/auth.dart';

class MenuAppBar extends StatelessWidget with PreferredSizeWidget{

  final void Function() onSubmit;

  @override
  final Size preferredSize = const Size.fromHeight(50.0);

  final AuthService _auth = AuthService();

  MenuAppBar({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leadingWidth: 110,
      elevation: 0,
      leading: const CustomBackButton(),
      actions: [
        CustomIconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateClientForm(onSubmit: onSubmit,)));
          },
          icon: const Icon(Icons.edit),),
        const SizedBox(width: 10,),
        CustomIconButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.power_settings_new),
        ),
        const SizedBox(width: 3,),
      ],

    );
  }

}