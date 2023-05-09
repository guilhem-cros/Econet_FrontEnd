import 'package:flutter/material.dart';
import 'package:image_upload/utils/extensions.dart';
import 'package:image_upload/widgets/custom_buttons/icon_button.dart';

import '../models/ecospot.dart';

///Custom widget corresponding to a card containing info about an Ecospot
class EcospotCard extends StatefulWidget {

  final EcospotModel displayedEcospot;
  final List<EcospotModel> favEcospots;
  final bool isAdmin;

  const EcospotCard({
    super.key,
    required this.displayedEcospot,
    required this.favEcospots,
    required this.isAdmin
  });

  @override
  State<EcospotCard> createState() => _EcospotCardState();

}

class _EcospotCardState extends State<EcospotCard> {

  late EcospotModel ecospot;
  late bool _isFav;

  bool updated = false;

  @override
  void initState() {
    ecospot = widget.displayedEcospot;
    _isFav = widget.favEcospots.where((obj)=>obj.id == ecospot.id).isNotEmpty;
    super.initState();
  }

  void setFav(){
    setState(() {
      _isFav = !_isFav;
      updated = true;
    });
  }


  @override
  Widget build(BuildContext context) {


    final buttonsBox = Column(
      children: [
        const SizedBox(height: 15),
        CustomIconButton(
          onPressed: (){Navigator.pop(context);},
          icon: const Icon(Icons.close),
          iconColor: const Color.fromRGBO(94, 100, 114, 1),
        ),
        const SizedBox(height: 15,),
        if(widget.isAdmin)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconButton(
              onPressed: (){}, //TODO update et récup updated pour mettre à jour
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              iconColor: Colors.white,
              backgroundColor: const Color.fromRGBO(81, 129, 253, 1),
            ),
            const SizedBox(width: 25,),
            CustomIconButton(
              onPressed: (){}, //TODO delete et delete dans liste
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              iconColor: Colors.white,
              backgroundColor: Colors.red,
            )
          ],
        )
      ]
    );

    /// Widget containing written details about the displayed ecospot
    final ecospotDetails = Expanded(child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
            child: Column(
            children: [
              Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 45,),
                        Text(
                          ecospot.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: setFav,
                          icon: _isFav? const Icon(Icons.star,color: Color.fromRGBO(255, 230, 0, 1)) : const Icon(Icons.star_border),
                        )
                      ]
                    ),
                    Text(
                      ecospot.mainType.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ]
              ),
              Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Détails',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Description',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Tips',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ]
                  )
                ].map((widget) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: widget,
                )).toList(),
              )
            ]
        )
        )
    ));


    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            Container(
            height: 0.7*MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 15.0,

                ),
              ],
              borderRadius: BorderRadius.circular(3),
              color: HSLColor.fromColor(ecospot.mainType.color.toColor()).withSaturation(0.65).withLightness(0.5).toColor(),
            ),
          child:
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(ecospot.pictureUrl,width: MediaQuery.of(context).size.width, height: 180, fit: BoxFit.fitWidth),
                ecospotDetails
              ]
            ),
          ),
          buttonsBox
        ]
      )
    );
  }

}