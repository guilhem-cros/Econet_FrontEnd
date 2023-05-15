import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/utils/extensions.dart';

/// Widget corresponding to an ecospot displayed in a list of ecospot
class EcospotListItem extends StatelessWidget{

  /// Name of the spot, main label of the list item
  final String spotName;
  /// Name of the spot main type, secondary label of the list item
  final String spotType;
  /// Url to the main type logo of the spot, displayed on the right of the list item
  final String imageUrlType;
  /// Color of the main type of the spot, used with reduced opacity as background color of the item
  final Color spotColor;
  /// Function called when the item is tapped
  final void Function()? onTap;

  const EcospotListItem({super.key, required this.spotName, required this.spotType, required this.imageUrlType, required this.spotColor, this.onTap});


  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        if (onTap != null){
          onTap!();
        }
      },
      child: Container(
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
              Image.network(imageUrlType, height: 30, width: 30,),
            ],
          )
      ),
    ));
  }
}
