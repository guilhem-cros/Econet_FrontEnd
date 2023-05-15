import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_upload/DAOs/client_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/models/type.dart';
import 'package:image_upload/screens/home/home.dart';
import 'package:image_upload/services/storage_service.dart';
import 'package:image_upload/utils/extensions.dart';


import '../../../DAOs/type_DAO.dart';
import '../../../widgets/image_picker.dart';

class TypeForm extends StatefulWidget {
  final TypeModel? toUpdateType;

  const TypeForm({super.key, this.toUpdateType});

  @override
  State<StatefulWidget> createState() {
    return _TypeFormState();
  }
}

class _TypeFormState extends State<TypeForm>{

  TextEditingController _typeName = TextEditingController();
  TextEditingController _typeDescription = TextEditingController();
  PlatformFile? selectedImage;
  Color? selectedColor;

  late bool _isUploading;
  late bool isCreation;

  final Storage storage = Storage();
  TypeDAO typeDAO = TypeDAO();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showPopUp(BuildContext context, String message){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  @override
  void initState() {
    isCreation = widget.toUpdateType == null;
    super.initState();
    _isUploading = false;
    if(!isCreation){
      _typeName = TextEditingController(text: widget.toUpdateType!.name);
      _typeDescription = TextEditingController(text: widget.toUpdateType!.description);
      selectedColor = widget.toUpdateType!.color.toColor();
    }
  }

  void setUpload(bool isUploading){
    setState(() {
      _isUploading = isUploading;
    });
  }

  void changeColor(Color newColor){
    setState(() {
      selectedColor = newColor.withOpacity(1);
    });
  }

  void hasBeenSumitted(TypeModel type) async {
    if(!isCreation){
      ClientDAO clientDAO = ClientDAO();
      APIResponse<ClientModel> reloadedClient = await clientDAO.getById(id: Home.currentClient!.id);
      if(!reloadedClient.error){
        Home.currentClient = reloadedClient.data;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isCreation ? "Type publié avec succès" : "Type mis à jour avec succès"))
    );
    setUpload(false);
    Navigator.pop(context, type);
  }

  void setSelectedImage(PlatformFile newFile){
    selectedImage = newFile;
  }

  Future<String> uploadImage() async {
    String url = await storage.uploadFile(selectedImage!.path!, selectedImage!.name, "types_logo");
    return url;
  }

  /// Handling type creation
  void create() async {
    if(selectedImage != null) {
      if(selectedColor !=null) {

        try {

          final isUniqueResult = await typeDAO.isTypeUnique(
              name: _typeName.text,
              color: selectedColor!.toHexString());
          if(isUniqueResult.error){
            setUpload(false);
            showPopUp(context, isUniqueResult.errorMessage!);
          } else {
            if(!isUniqueResult.data!){
              setUpload(false);
              showPopUp(context, "Le nom ou la couleur saisie est déjà associé à un type.");
            } else {
              final urlPic = await uploadImage();
              APIResponse<TypeModel> result = await typeDAO.create(
                  name: _typeName.text,
                  color: selectedColor!.toHexString(),
                  description: _typeDescription.text,
                  logoUrl: urlPic
              );
              if(result.error){
                setUpload(false);
                showPopUp(context, result.errorMessage!);
              } else {
                hasBeenSumitted(result.data!);
              }
            }
          }

        } catch (err) {
          setUpload(false);
          showPopUp(context, err.toString());
        }

      } else {
        setUpload(false);
        showPopUp(context, "Veuillez sélectionner une couleur");
      }
    } else {
      setUpload(false);
      showPopUp(context, "Veuillez sélectionner une image");
    }
  }

  /// Handling type update
  void update() async {
    try{
      final isUniqueResult = await typeDAO.isTypeUnique(
          name: _typeName.text,
          color: selectedColor!.toHexString(),
          typeId: widget.toUpdateType!.id
      );
      if(isUniqueResult.error){
        setUpload(false);
        showPopUp(context, isUniqueResult.errorMessage!);
      } else {
        if (!isUniqueResult.data!) {
          setUpload(false);
          showPopUp(context,
              "Le nom ou la couleur saisie est déjà associé à un type.");
        } else {
          if(selectedImage!=null){
            widget.toUpdateType!.logoUrl = await uploadImage();
          }
          APIResponse<TypeModel> result = await typeDAO.update(
              id: widget.toUpdateType!.id,
              name: _typeName.text,
              logoUrl: widget.toUpdateType!.logoUrl,
              color: selectedColor!.toHexString(),
              description: _typeDescription.text,
              associatedSpots: widget.toUpdateType!.associatedSpots
          );
          if(result.error){
            setUpload(false);
            showPopUp(context, result.errorMessage!);
          } else {
            hasBeenSumitted(result.data!);
          }
        }
      }

    } catch (err) {
      setUpload(false);
      showPopUp(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    final typeNameField = TextFormField(
      controller: _typeName,
      autofocus: false,
      validator: (value) {
        if(value == null || value.trim().isEmpty){
          return 'Ce champs est requis';
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          prefixIcon:
          const Icon(
            Icons.label,
          ),
          labelText: "Nom du type",
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          filled: true,
          fillColor: const Color(0x3303d024),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none))
    );


    final descriptionField = TextFormField(
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      controller: _typeDescription,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      } ,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          prefixIcon:
          const Icon(
            Icons.list,
          ),
          labelText: "Description",
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          filled: true,
          fillColor: const Color(0x3303d024),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none))
    );

    final colorPicker = AlertDialog(
      title: Text("Choisissez une couleur"),
      content: SingleChildScrollView(
      child: ColorPicker(
        enableAlpha: false,
        pickerColor: const Color.fromRGBO(20, 193, 37, 0.9),
        onColorChanged: changeColor,
      ),
      ),
      actions: <Widget>[
       TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    final colorButton = ElevatedButton.icon(
        icon: Icon(Icons.format_color_fill_rounded, color: Colors.black.withOpacity(0.55),),
        label: Text("Choisir une couleur",
          style: TextStyle(fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.55),
            fontSize: 16
          ),
        ),
        onPressed: () {
          showDialog(context: context, builder: (context) {
            return colorPicker;
          });
        },
        style: ElevatedButton.styleFrom(
            minimumSize: Size(0.7*MediaQuery.of(context).size.width, 40),
            padding: const EdgeInsets.all(20.0),
            backgroundColor: const Color(0x3303d024),
            shadowColor: Colors.transparent,
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
            side: BorderSide(color: Colors.lightGreen.withOpacity(0.3))
            )
        )
    );

    final colorPreview = GestureDetector(
      onTap: () {
          showDialog(context: context, builder: (context) {
            return colorPicker;
          });
        },
      child: Container(height: 35, width: 35,
        decoration: BoxDecoration(
            color: selectedColor==null ? const Color(0xff009718) : selectedColor!,
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
      ),
    );

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff009718),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20.0),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setUpload(true);
              if (isCreation) {
                create();
              } else {
                update();
              }
            }
          },
          child: !_isUploading?
          const Text("Enregister",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          )
              :
          const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
      ),
    );


    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20, right: 20
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20,),
                      typeNameField,
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          colorButton,
                          const SizedBox(width: 10),
                          colorPreview
                        ],
                      ),
                      const SizedBox(height: 20,),
                      descriptionField,
                      const SizedBox(height: 20),
                      ImagePicker(
                        label: "Choisir un logo",
                        setSelectedImage: setSelectedImage,
                        currentImageURL: isCreation ? null : widget.toUpdateType!.logoUrl,
                      ),
                      const Text("*Préférez un png transparent",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 20,),
                      submitButton,
                      const SizedBox(height: 20,)
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

}