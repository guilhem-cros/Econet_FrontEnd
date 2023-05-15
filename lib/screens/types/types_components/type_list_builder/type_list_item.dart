import 'package:flutter/cupertino.dart';
import 'package:image_upload/utils/extensions.dart';

class TypeListItem extends StatelessWidget {

  /// The type name, main label of the item
  final String typeName;
  /// The type color, background color of the item (used with reduced opacity)
  final Color typeColor;
  /// Url to the type logo
  final String typeLogoUrl;
  /// Function called when the item is tapped
  final void Function()? onTap;

  const TypeListItem({super.key, required this.typeName, required this.typeColor, required this.typeLogoUrl, this.onTap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(onTap != null){
          onTap!();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: typeColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 0.85*MediaQuery.of(context).size.width,
        height: 50,
        alignment: Alignment.center,
        child:
        Container(
            padding: const EdgeInsets.only(bottom: 2),
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
                Text(typeName.toTitleCase(), style: TextStyle(color: const Color.fromRGBO(45, 45, 45, 1).withOpacity(0.7), fontSize: 20, fontWeight: FontWeight.bold)),
                Image.network(typeLogoUrl, height: 30, width: 30,),
              ],
            )
        ),
      )
    );
  }

}