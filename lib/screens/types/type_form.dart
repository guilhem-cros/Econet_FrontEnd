import 'package:flutter/material.dart';
import 'package:image_upload/models/type.dart';
import 'package:image_upload/screens/forms/generalized_type_form.dart';

import '../../widgets/custom_buttons/back_button.dart';

class TypeFormScreen extends StatelessWidget{

  final TypeModel? toUpdateType;

  const TypeFormScreen({super.key, this.toUpdateType});

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      leading: const CustomBackButton(),
      leadingWidth: 110,
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10,bottom: 15),
                child:Text(toUpdateType==null ? "Ajouter un Type" : "Modifier un Type",style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              )
            ],
          ),
          Expanded(child: TypeForm(
            toUpdateType: toUpdateType,
          ))
        ],
      ),
    );
  }
}