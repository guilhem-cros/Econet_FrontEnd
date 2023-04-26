import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/screens/home/home.dart';
import 'package:image_upload/screens/menu/menu_app_bar.dart';

import '../../DAOs/client_DAO.dart';
import '../../services/storage_service.dart';
import '../../widgets/menu_item.dart';
import '../../widgets/profile_pic_display.dart';

/// Class building the main menu screen
class Menu extends StatefulWidget {

  final Storage storage = Storage();
  final ClientDAO clientDAO = ClientDAO();

  Menu({super.key});

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu>{

  PlatformFile? selectedFile;
  String currentUrl = Home.currentClient!.profilePicUrl;
  bool isLoading = false;
  bool gotError = false;
  bool uploaded = false;

  void setSelectedFile(PlatformFile newFile){
    setState(() {
      selectedFile = newFile;
    });
  }

  Future<APIResponse<ClientModel>> setUserProfilePic() async{
    setState(() {
      isLoading = true;
    });
    try {
      var futureUrl = await widget.storage.uploadFile(
          selectedFile!.path!, Home.currentClient!.pseudo, 'profile_pics');
      setState(() {
          currentUrl = futureUrl;
          Home.currentClient!.profilePicUrl = currentUrl;
      });
    }catch(err){
      gotError=true;
    }
    var result = await widget.clientDAO.updateClient(updateClient: Home.currentClient!);
    setState(() {
      isLoading = false;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed:  () {
        setState(() {
          gotError= false;
        });
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Mettre à jour"),
      onPressed:  () async {
        setState(() {
          gotError= false;
        });
        Navigator.of(context).pop();
        var response = await setUserProfilePic();
        if(response.error){
          gotError= true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Votre photo de profil a bien été mise à jour"),
            ),
          );
        }
      },
    );
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed:  () {
        setState(() {
          gotError= false;
        });
        Navigator.of(context).pop();
      },
    );

    void showPopUp(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Mise à jour"),
              content: const Text("Mettre à jour la photo de profil ?"),
              actions: [
                cancelButton,
                continueButton
              ],
            );
          }
      );
    }

    void showError(BuildContext context){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text("Erreur"),
          icon: const Icon(Icons.error_outline),
          content: const Text("Une erreur est servenue durant le téléchargement de l'image."),
          actions: [okButton],
        );
      });
    }


      return Scaffold(
          appBar: MenuAppBar(),
          body:
          Column(
              children: [
                isLoading ?
                Center(child:Container(height: 50, width: 50, margin: const EdgeInsets.all(50.0) ,child: const CircularProgressIndicator()))
                    :
                ProfilePicDisplay(
                  profilePicUrl: currentUrl,
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg', 'jpeg']
                    );
                    if(gotError){
                      showError(context);
                    }
                    if(result != null){
                      setSelectedFile(result.files.single);
                      showPopUp(context);
                    }
                  },
                ),
                const SizedBox(height: 10,),
                Text(Home.currentClient!.pseudo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                const SizedBox(height: 50,),
                const MenuItem(label: "Ecospots favoris", icon: Icon(Icons.star), iconColor: Color.fromRGBO(255, 230, 0, 1),),
                const SizedBox(height: 25,),
                const MenuItem(label: "Mes Ecospots", icon: Icon(Icons.pin_drop_outlined), iconColor: Color.fromRGBO(96, 96, 96, 1)),
                const SizedBox(height: 25,),
                if(Home.currentClient!.isAdmin)
                  const MenuItem(label: 'Panel Admin', icon: Icon(Icons.admin_panel_settings_sharp), iconColor: Color.fromRGBO(96, 96, 96, 1))
              ]
          )
      );
    }
  }