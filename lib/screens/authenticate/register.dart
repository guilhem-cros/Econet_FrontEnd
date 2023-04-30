import 'package:flutter/material.dart';
import 'package:image_upload/widgets/wave.dart';

import '../forms/register_form.dart';

class Register extends StatefulWidget{

  final Function? toggleView;
  Register({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RegisterForm(
            onToggleView: widget.toggleView,
          ),
          Wave(0.25, 0.6, 0.75, positionTop: 0, positionLeft: 0, positionRight: 0,
              positionTopText: 40, positionRightText: 30, height: 150, label: "Bienvenue !",),
        ],
      ),
    );
  }

}

