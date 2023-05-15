import 'package:flutter/material.dart';
import 'dart:math' as math;


import '../../widgets/custom_buttons/back_button.dart';
import '../../widgets/wave.dart';
import 'account_components/generalized_client_form.dart';
import '../home/home.dart';

/// Screen handling the update of the currently connected client
class UpdateClientScreen extends StatelessWidget {

  /// Function to call after updating the client
  final void Function() onSubmit;

  const UpdateClientScreen({super.key, required this.onSubmit});

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
      body: Stack( children: [
        Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(left: 10, bottom: 25),
                child:const Text("Modifier mon compte",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              )],
            ),
            Expanded(child: GeneralizedClientForm(
              toUpdateClient: Home.currentClient!,
              onSubmit: onSubmit,
            )),
          ],
        ),
        Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(math.pi),
            child: Stack(
                children: [Wave(0.5, 0.75, 0.30, height: 75 ,positionTop: 0, positionLeft: 0, positionRight: 0, label: "",)])
        )
      ]
      )
    );
  }

}