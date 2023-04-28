import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/extensions.dart';

class EcospotListItem extends StatelessWidget{
  final String spotName;
  final String spotType;
  final String imageUrlType;
  final Color spotColor;

  const EcospotListItem({super.key, required this.spotName, required this.spotType, required this.imageUrlType, required this.spotColor});


  @override
  Widget build(BuildContext context){
    print(spotColor);
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: spotColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
          ),
      width: 0.85*MediaQuery.of(context).size.width,
      height: 50,
      alignment: Alignment.center,
      child:
      Container(
        padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: const Color.fromRGBO(208, 208, 208, 1).withOpacity(0.8))
              )
          ),
          width: 0.75*MediaQuery.of(context).size.width,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(spotName.toTitleCase(), style: TextStyle(color: const Color.fromRGBO(45, 45, 45, 1).withOpacity(0.7), fontSize: 20, fontWeight: FontWeight.bold)),
              Image.network(imageUrlType, height: 30),
            ],
          )
      ),
    );
  }
}
