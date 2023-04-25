import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EcospotListItem extends StatelessWidget{
  final String spotName;
  final String spotType;
  final Icon iconType;
  final Color spotColor;

  const EcospotListItem({super.key, required this.spotName, required this.spotType, required this.iconType, required this.spotColor});

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          color: spotColor
          ),
      width: 250,
      child:
      Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color.fromRGBO(208, 208, 208, 1))
              )
          ),
          width: 250,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$spotName - ', style: const TextStyle(color: Color.fromRGBO(45, 45, 45, 1), fontSize: 22, fontWeight: FontWeight.bold)),
              Text(spotType, style: const TextStyle(color: Color.fromRGBO(45, 45, 45, 1), fontSize: 22, fontWeight: FontWeight.bold)),
              Icon(iconType.icon , size: 18),
            ],
          )
      ),
    );
  }
}
