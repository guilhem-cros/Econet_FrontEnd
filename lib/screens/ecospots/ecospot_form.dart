import 'package:flutter/material.dart';
import 'package:image_upload/DAOs/ecospot_DAO.dart';
import 'package:image_upload/models/ecospot.dart';

import '../../widgets/custom_buttons/back_button.dart';
import 'ecospots_components/generalized_ecospot_form.dart';
import '../home/home.dart';

class EcospotFormScreen extends StatelessWidget{

  final EcospotModel? toUpdateEcospot;
  final bool isPublicationForm;

  const EcospotFormScreen({super.key, this.toUpdateEcospot, this.isPublicationForm = false});


  @override
  Widget build(BuildContext context) {

    final dao = EcospotDAO();

    void deleteEcospot(){
      dao.delete(id: toUpdateEcospot!.id);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
              "Demande de publication refusé. L'ecospot a été supprimé."
          )
      ));
      Navigator.pop(context, toUpdateEcospot);
    }

    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Valider"),
      onPressed:  () {
          Navigator.of(context).pop();
          deleteEcospot();
        },
    );

    void confirmDelete(){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: const Text("Refuser la publication ?"),
              content: const Text("Le refus de la publication entraine la suppression définitive de l'ecospot"),
              actions: [
                cancelButton,
                continueButton
              ],
            );
          }
      );
    }

    return Scaffold(
      appBar: _AppBar(),
      body: Column(
        children: [
          Container(
          padding: const EdgeInsets.only(left: 10,bottom: 15),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(!isPublicationForm ? (toUpdateEcospot==null ? "Ajouter un EcoSpot" : "Modifier un EcoSpot") : "Demande de publication",style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                if(isPublicationForm)
                  IconButton(
                      onPressed: confirmDelete,
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red,)
                  )
              ],
            )
          ),
          Expanded(child: EcospotForm(
            isAdmin: Home.currentClient!.isAdmin,
            toUpdateEcospot: toUpdateEcospot,
          ))
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
      leading: const CustomBackButton(),
      leadingWidth: 110,
    );
  }


}
