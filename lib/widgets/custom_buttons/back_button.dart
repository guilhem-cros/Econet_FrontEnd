import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget{

  final void Function()? onPressed;

  const CustomBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const color = Color.fromRGBO(81, 129, 253, 1);

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      icon: const Icon(Icons.arrow_back_ios_rounded, color: color, size: 20),
      label: const Text("Retour", style: TextStyle(color: color, fontSize: 14),),
    );
  }

}