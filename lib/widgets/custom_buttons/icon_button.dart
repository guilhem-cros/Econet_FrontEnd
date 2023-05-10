import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {

  final void Function()? onPressed;
  final Icon icon;
  final Color backgroundColor;
  final Color iconColor;
  final double radius;
  final double? size;
  final bool stroke;

  const CustomIconButton({super.key, required this.onPressed, required this.icon,
    this.backgroundColor = const Color.fromRGBO(238, 238 , 238, 1), this.iconColor = const Color.fromRGBO(81, 129, 253, 1), this.radius=20, this.size, this.stroke=false});


  @override
  Widget build(BuildContext context) {
    final basicCircle = CircleAvatar(
        backgroundColor: backgroundColor,
        radius: radius,
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          icon: Icon(icon.icon, color: iconColor, size: size ?? 24,),
        )
    );

    return stroke ?
    CircleAvatar(
      radius: radius + 1,
      backgroundColor: iconColor,
      child: basicCircle,
    )
        :
    basicCircle;
  }

}