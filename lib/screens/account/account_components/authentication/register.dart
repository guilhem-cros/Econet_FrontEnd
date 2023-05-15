import 'package:flutter/material.dart';
import 'package:image_upload/widgets/wave.dart';

import '../generalized_client_form.dart';

/// Widget handling the registration of a client
class Register extends StatefulWidget{

  /// Function called when the login link is clicked
  final Function? toggleView;

  const Register({super.key, this.toggleView});

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
          GeneralizedClientForm(
            onToggleView: widget.toggleView,
          ),
          Wave(0.25, 0.6, 0.75, positionTop: 0, positionLeft: 0, positionRight: 0,
              positionTopText: 40, positionRightText: 30, height: 150, label: "Bienvenue !",),
        ],
      ),
    );
  }

}

