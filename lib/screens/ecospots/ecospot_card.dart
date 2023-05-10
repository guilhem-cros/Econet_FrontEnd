import 'package:flutter/material.dart';
import 'package:image_upload/DAOs/type_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/utils/extensions.dart';
import 'package:image_upload/widgets/custom_buttons/icon_button.dart';

import '../../models/ecospot.dart';
import '../../models/type.dart';
import 'ecospot_form.dart';

///Custom widget corresponding to a card containing info about an Ecospot
class EcospotCard extends StatefulWidget {

  final EcospotModel displayedEcospot;
  final List<EcospotModel> favEcospots;
  final bool isAdmin;
  final void Function() onUpdate;
  final void Function() onDelete;
  final void Function(bool) onFav;

  const EcospotCard({
    super.key,
    required this.displayedEcospot,
    required this.favEcospots,
    required this.isAdmin,
    required this.onUpdate,
    required this.onDelete,
    required this.onFav
  });

  @override
  State<EcospotCard> createState() => _EcospotCardState();

}

class _EcospotCardState extends State<EcospotCard> {

  late EcospotModel ecospot;
  late bool _isFav;
  late bool loadingErr;

  List<TypeModel> otherTypes = [];

  bool updated = false;
  bool loadingOtherTypes=false;

  @override
  void initState() {
    loadingErr = false;
    ecospot = widget.displayedEcospot;
    _isFav = widget.favEcospots.where((obj)=>obj.id == ecospot.id).isNotEmpty;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      fetchOtherTypes(ecospot.otherTypes);
    });
  }

  void setFav(){
    setState(() {
      _isFav = !_isFav;
      updated = true;
    });
    widget.onFav(_isFav);
    }

  void fetchOtherTypes(List<String> typesIds) async {
    setState(() {
      loadingOtherTypes = true;
    });
    final typeDAO = TypeDAO();
    List<TypeModel> aux = [];
    for(String id in typesIds){
      APIResponse result = await typeDAO.getById(id: id);
      if(result.error){
        setState(() {
          loadingErr = true;
          loadingOtherTypes = false;
        });
        break;
      } else {
        aux.add(result.data);
      }
    }
    setState(() {
      otherTypes = aux;
      loadingOtherTypes = false;
    });
  }

  String printOtherTypes(){
    if(otherTypes.isEmpty){
      return "...";
    }
    String chain = "";
    for(TypeModel type in otherTypes){
      chain+= "${type.name}, ";
    }
    return chain.substring(0, chain.length-2);
  }

  Widget detailContainer(String title, String content){
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color.fromRGBO(
            220, 220, 220, 1.0), width: 0.5))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: const Text("Valider"),
      onPressed:  () {
        Navigator.of(context).pop();
        widget.onDelete();
        Navigator.pop(context);
      },
    );

    void confirmDelete(){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: const Text("Supprimer l'Ecospot ?"),
              content: const Text("Celui-ci sera définitivement supprimé."),
              actions: [
                cancelButton,
                continueButton
              ],
            );
          }
      );
    }

    final otherTypesList = Container(
        padding: const EdgeInsets.only(bottom: 5, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Autres types : ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            loadingOtherTypes ?
              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2,),)
            :
              Text(
                loadingErr ? "Impossible de charger les types" : printOtherTypes(),
                style: const TextStyle(fontSize: 14,)
              )
          ],
        )
    );

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
              onPressed: () async {
                final updatedItem = await Navigator.push(context, MaterialPageRoute(builder:
                    (context) => EcospotFormScreen(toUpdateEcospot: ecospot)
                ));
                if(updatedItem!=null){
                  setState(() {
                    ecospot = updatedItem;
                  });
                  fetchOtherTypes(ecospot.otherTypes);
                  widget.onUpdate();
                  }
              },
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              iconColor: Colors.white,
              backgroundColor: const Color.fromRGBO(81, 129, 253, 1),
            ),
            const SizedBox(width: 25,),
            CustomIconButton(
              onPressed: confirmDelete,
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                    ),
                  ]
              ),
              Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailContainer("Détails", ecospot.details),
                        detailContainer("Tips", ecospot.tips),
                        detailContainer("Description", "${ecospot.mainType.name}: ${ecospot.mainType.description}"),
                        otherTypesList
                      ]
                  )
                ].map((widget) => Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
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