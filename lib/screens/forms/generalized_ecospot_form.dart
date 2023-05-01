import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/models/ecospot.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/utils/extensions.dart';
import 'package:image_upload/widgets/image_picker.dart';
import '../../DAOs/ecospot_DAO.dart';
import '../../screens/home/home.dart';
import '../../services/storage_service.dart';
import 'package:collection/collection.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';


import '../../DAOs/type_DAO.dart';
import '../../models/type.dart';
import '../error/error_screen.dart';

class EcospotForm extends StatefulWidget{
  late List<TypeModel>? typeList;
  final bool isAdmin;
  final EcospotModel? toUpdateEcospot;
  final void Function(EcospotModel) onSubmit;

  EcospotForm({super.key, required this.isAdmin, required this.onSubmit, this.toUpdateEcospot});

  @override
  State<StatefulWidget> createState() {
    return _EcospotForm();
  }
}

class _EcospotForm  extends State<EcospotForm>{

  late Future<APIResponse<List<TypeModel>>> _typeList;

  TextEditingController _spotName = TextEditingController();
  TextEditingController _spotType = TextEditingController();
  TextEditingController _spotAdress = TextEditingController();
  TextEditingController _spotDetails = TextEditingController();
  TextEditingController _spotTips = TextEditingController();
  String? selectedTypeId;
  List<String> selectedSecondaryTypeIds = [];

  late bool _isUploading;
  late bool isCreation;

  PlatformFile? selectedImage;
  final Storage storage = Storage();

  final ecospotDAO = EcospotDAO();

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
    isCreation = widget.toUpdateEcospot == null;
    super.initState();
    _typeList = typeDAO.getAll();
    _isUploading = false;
    if(!isCreation){
      _spotName = TextEditingController(text: widget.toUpdateEcospot!.name);
      _spotAdress = TextEditingController(text: widget.toUpdateEcospot!.address);
      _spotDetails = TextEditingController(text: widget.toUpdateEcospot!.details);
      _spotTips = TextEditingController(text: widget.toUpdateEcospot!.tips);
      _spotType = TextEditingController(text: widget.toUpdateEcospot!.mainType.name);
      selectedTypeId = widget.toUpdateEcospot!.mainType.id;
      selectedSecondaryTypeIds = widget.toUpdateEcospot!.otherTypes;
    }
  }

  void setTypeList(List<TypeModel> typeList){
    widget.typeList = typeList;
  }

  void setUpload(bool isUploading){
    setState(() {
      _isUploading = isUploading;
    });
  }

  void hasBeenSubmitted(EcospotModel ecospotModel){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: widget.isAdmin? const Text(
        "EcoSpot publié avec succès !"
      ): const Text("Votre demande de publication d'EcoSpot a été prise en compte !"))
    );
    setUpload(false);
    Navigator.pop(context);
    widget.onSubmit(ecospotModel);
  }

  void setSelectedImage(PlatformFile newFile){
    selectedImage = newFile;
  }

  Future<String> uploadImage() async {
    String url = await storage.uploadFile(
        selectedImage!.path!, selectedImage!.name, 'ecospots');
    return url;
  }

  void create() async {
    if (selectedImage != null) {
      try {
        final urlPic = await uploadImage();
        final checkResult = await ecospotDAO.checkAddressUnique(
          address: _spotAdress.text,
        );
        if (!checkResult.error) {
          if (!checkResult.data!['isUnique']) {
            setUpload(false);
            showPopUp(context, checkResult.data!['errorMessage']);
          } else {
            APIResponse<EcospotModel> result = await ecospotDAO.createEcospot(
                name: _spotName.text,
                address: _spotAdress.text,
                details: _spotDetails.text,
                tips: _spotTips.text,
                mainTypeId: selectedTypeId!,
                otherTypes: selectedSecondaryTypeIds,
                pictureUrl: urlPic,
                clientId: Home.currentClient!.id);
            if (result.error) {
              setUpload(false);
              showPopUp(context, result.errorMessage!);
            }
            else {
              hasBeenSubmitted(result.data!);
            }
          }
        } else {
          setUpload(false);
          showPopUp(context, checkResult.errorMessage!);
        }
      }
      catch (e) {
        setUpload(false);
        showPopUp(context, e.toString());
      }
    }
    else {
      setUpload(false);
      showPopUp(context, "Veuillez sélectionner une image");
    }
  }

  void update() async {
    try{
      bool uploadable = true;
      if(selectedImage!=null){
        widget.toUpdateEcospot!.pictureUrl = await uploadImage();
      }
      if(_spotAdress.text != widget.toUpdateEcospot!.address){
        final checkResult = await ecospotDAO.checkAddressUnique(
          address: _spotAdress.text,
        );
        if (!checkResult.error) {
          if (!checkResult.data!['isUnique']) {
            uploadable = false;
            setUpload(false);
            showPopUp(context, checkResult.data!['errorMessage']);
          }
        }
        else{
          uploadable = false;
          setUpload(false);
          showPopUp(context, checkResult.errorMessage!);
        }
      }

      if(uploadable){
        APIResponse<EcospotModel> result = await ecospotDAO.updateEcospot(
            id: widget.toUpdateEcospot!.id,
            name: _spotName.text,
            address: _spotAdress.text,
            details: _spotDetails.text,
            tips: _spotTips.text,
            mainTypeId: selectedTypeId!,
            otherTypes: selectedSecondaryTypeIds,
            pictureUrl: widget.toUpdateEcospot!.pictureUrl
        );
        if(result.error){
          setUpload(false);
          showPopUp(context, result.errorMessage!);
        } else{
          hasBeenSubmitted(result.data!);
        }
      }

    } catch(err){
      setUpload(false);
      showPopUp(context, err.toString());
    }
  }


  Widget spotTypeDropdown() {
    TypeModel? getTypeById(String? id) {

      if (id == null) {
        return null;
      }
      return widget.typeList!.firstWhereOrNull((type) => type.id == id);
    }

    return DropdownButtonFormField<TypeModel>(
      value: getTypeById(selectedTypeId),
      items: widget.typeList!.map((TypeModel type) {
        return DropdownMenuItem<TypeModel>(
          value: type,
          child: Text(type.name.toTitleCase()),
        );
      }).toList(),
      onChanged: (TypeModel? newValue) {
        setState(() {
          _spotType.text = newValue!.name;
          selectedTypeId = newValue.id;
        });
      },
      validator: (value) {
        if (value == null || (value).name.trim().isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          prefixIcon: const Icon(
            Icons.eco,
          ),
          labelText: "Type du spot",
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          filled: true,
          fillColor: const Color(0x3303d024),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none)),
    );
  }

  Widget secondaryTypesDropdown() {
    List<TypeModel> secondaryTypes = widget.typeList!
        .where((type) => type.id != selectedTypeId)
        .toList();

    return MultiSelectBottomSheetField(
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      title: const Text("Types secondaires"),
      buttonIcon: const Icon(Icons.more_horiz),
      buttonText: const Text("Types secondaires"),
      cancelText: const Text("Annuler", style:TextStyle(fontWeight: FontWeight.bold)),
      confirmText: const Text("Valider", style:TextStyle(fontWeight: FontWeight.bold)),
      initialValue: selectedSecondaryTypeIds,
      items: secondaryTypes.map((type) => MultiSelectItem<String>(type.id, type.name.toTitleCase())).toList(),
        onConfirm: (values) {
          setState(() {
            selectedSecondaryTypeIds = values.map<String>((item) => item.toString()).toList();
          });
        },
      chipDisplay: MultiSelectChipDisplay(
        chipColor:  const Color(0x9903d024),
        textStyle: const TextStyle(color: Colors.black),
        onTap: (value) {
          setState(() {
            selectedSecondaryTypeIds.remove(value);
          });
        },
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        color: const Color(0x3303d024),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final spotNameField = TextFormField(
        controller: _spotName,
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
              Icons.label,
            ),
            labelText: "Nom du spot",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));


    final adressField = TextFormField(
        controller: _spotAdress,
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
              Icons.pin_drop,
            ),
            labelText: "Adresse/Position actuelle",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));


    final detailsField = TextFormField(
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        controller: _spotDetails,
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
            labelText: "Détails",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));


    final tipsField = TextFormField(
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        controller: _spotTips,
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
              Icons.tips_and_updates,
            ),
            labelText: "Tips",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));


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
        child: !_isUploading? (!widget.isAdmin ? const Text(
      "Soumettre",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ): const Text(
          "Publier", //Ou publier si update
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        )): const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
      ),
    );

    return Scaffold(
        body: Center(
          child: FutureBuilder<APIResponse<List<TypeModel>>>(
              future: _typeList,
              builder: (context,snapshot){
                if (snapshot.hasData){
                  if(snapshot.data!.error){
                    return ErrorScreen(errorMessage: snapshot.data!.errorMessage!);
                  } else {
                    setTypeList(snapshot.data!.data!);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            autovalidateMode: AutovalidateMode.disabled,
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(height: 5),
                                    spotNameField,
                                    const SizedBox(height: 20.0),
                                    spotTypeDropdown(),
                                    const SizedBox(height: 10.0),
                                    secondaryTypesDropdown(),
                                    const SizedBox(height: 20.0),
                                    adressField,
                                    const SizedBox(height: 20.0),
                                    detailsField,
                                    const SizedBox(height: 20.0),
                                    tipsField,
                                    const SizedBox(height: 20.0),
                                    ImagePicker(label: "Ajouter une image",
                                        setSelectedImage: setSelectedImage, currentImageURL: isCreation ? null : widget.toUpdateEcospot!.pictureUrl,),
                                    const SizedBox(height: 20.0),
                                    submitButton,
                                    const SizedBox(height: 20.0),
                                  ]
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return ErrorScreen(errorMessage: snapshot.error.toString());
                }
                return const CircularProgressIndicator();
              }
          ),
        )
    );
  }
}