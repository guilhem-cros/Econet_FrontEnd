import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget{

  /// Label of the item
  final String label;
  /// Icon of the item
  final Icon icon;
  /// Icon color of the item
  final Color iconColor;
  /// Function called when the item is tapped
  final void Function()? onTap;

  const MenuItem({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(icon.icon, color: iconColor, size: 36),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Color.fromRGBO(208, 208, 208, 1)),
              ),
            ),
            width: 0.75*MediaQuery.of(context).size.width,
            child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(color: Color.fromRGBO(45, 45, 45, 1), fontSize: 22, fontWeight: FontWeight.bold)),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Color.fromRGBO(45, 45, 45, 1), size: 18),
                  ],
              )
          ),
          const SizedBox(
            width: 5,
          )
        ],
      )
    );
  }

}