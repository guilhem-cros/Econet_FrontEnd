import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {

  final void Function()? onPressed;
  final Icon icon;
  final Color backgroundColor;
  final Color iconColor;

  const CustomIconButton({super.key, required this.onPressed, required this.icon,
    this.backgroundColor = const Color.fromRGBO(238, 238 , 238, 1), this.iconColor = const Color.fromRGBO(81, 129, 253, 1)});


  @override
  Widget build(BuildContext context) {

    return CircleAvatar(
        backgroundColor: backgroundColor,
        radius: 20,
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          icon: Icon(icon.icon, color: iconColor,),
      )
    );
  }

}