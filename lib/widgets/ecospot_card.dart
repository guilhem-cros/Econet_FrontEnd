import 'package:flutter/material.dart';

import '../models/Ecospot.dart';

///Custom widget corresponding to a card containing info about an Ecospot
class EcospotCard extends StatefulWidget {

  //final Ecospot displayedEcospot;

  const EcospotCard({
    super.key,
    //required this.displayedEcospot
  });

  @override
  State<EcospotCard> createState() => _EcospotCardState();

}

class _EcospotCardState extends State<EcospotCard> {

  bool _isFav = false;

  void setFav(){
    setState(() {
      _isFav = !_isFav;
    });
  }


   /// Widget containing written details about the displayed ecospot
  final ecospotDetails = Material(
    color: Colors.transparent,
    child: Column(
      children: [
        Column(
          children: const [
            Text(
              'Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                'Tip',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
            ]
          )
        ].map((widget) => Padding(
            padding: const EdgeInsets.all(16),
            child: widget,
          )).toList(),
        )
      ]
    )
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 380,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 15.0,
            ),
          ],
        ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2)
        ),
        color: Colors.blue,
        child: Stack(
          children: [
            Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network('https://googleflutter.com/sample_image.jpg',width: 280, height: 150, fit: BoxFit.fitWidth),
                    ecospotDetails
                  ]
                ),
            Positioned(
                left: 230,
                top: 140,
                child: IconButton(
                    onPressed: setFav,
                    icon: _isFav? const Icon(Icons.star, color: Color.fromRGBO(255, 230, 0, 1)) : const Icon(Icons.star_border),
              )
            ),
          ]
        )
      )
    );
  }

}