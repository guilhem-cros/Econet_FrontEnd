import 'package:flutter/material.dart';

/// Customizable rounded icon button
class CustomIconButton extends StatelessWidget {

  /// Function called when button is pressed
  final void Function()? onPressed;
  /// Icon of the button
  final Icon icon;
  /// Background color of the button
  final Color backgroundColor;
  /// Icon fill color
  final Color iconColor;
  /// Border radius of the button
  final double radius;
  /// Size on the button
  final double? size;
  /// Stroke around the button, true or false
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