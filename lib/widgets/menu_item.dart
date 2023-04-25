import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget{

  final String label;
  final Icon icon;
  final Color iconColor;

  const MenuItem({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon.icon, color: iconColor, size: 36),
        const SizedBox(width: 10),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Color.fromRGBO(208, 208, 208, 1))
            )
          ),
          width: 260,
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
          width: 3,
        )
      ],
    );
  }

}