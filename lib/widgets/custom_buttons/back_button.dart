import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget{

  /// Function called when back button is pressed
  final void Function()? onPressed;

  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    const color = Color.fromRGBO(81, 129, 253, 1);

    return ElevatedButton.icon(
      onPressed: () {
        if(onPressed == null){
          Navigator.pop(context);
        } else {
          onPressed!;
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      icon: const Icon(Icons.arrow_back_ios_rounded, color: color, size: 20),
      label: const Text("Retour", style: TextStyle(color: color, fontSize: 16),),
    );
  }

}
