import 'package:flutter/material.dart';
import 'package:image_upload/widgets/custom_buttons/back_button.dart';
import 'package:image_upload/widgets/lists/ecospots_list.dart';

import '../../models/ecospot.dart';

class EcospotsListScreen extends StatelessWidget{
  final String title;
  final bool isButtonVisible;
  final List<EcospotModel> ecospotsList;

  const EcospotsListScreen({super.key, required this.title, required this.isButtonVisible, required this.ecospotsList});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                child:Text(title,style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
                if(isButtonVisible)
                  IconButton(onPressed: (){}, icon: const Icon(Icons.add,color: Color.fromRGBO(81, 129, 253, 1),))                
            ],
          ),
          Expanded(child: EcospotsList(ecospotsList: ecospotsList))
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget{
  @override
  final Size preferredSize = const Size.fromHeight(50.0);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      leading: CustomBackButton(
        onPressed: (){

        },
      ),
      leadingWidth: 110,
    );
  }


}
