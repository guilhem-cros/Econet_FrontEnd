import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {

  final void Function()? onPressed;
  final Icon icon;

  const CustomIconButton({super.key, required this.onPressed, required this.icon});


  @override
  Widget build(BuildContext context) {

    return CircleAvatar(
        backgroundColor: const Color.fromRGBO(238, 238 , 238, 1),
        radius: 20,
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          icon: Icon(icon.icon, color: const Color.fromRGBO(81, 129, 253, 1),),
      )
    );
  }

}