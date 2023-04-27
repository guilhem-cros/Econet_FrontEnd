import 'package:flutter/material.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/screens/authenticate/DTOs/loginuser_dto.dart';
import 'package:image_upload/services/auth.dart';
import '../../DAOs/client_DAO.dart';
import '../../screens/home/home.dart';

class RegisterForm extends StatefulWidget {
  final Function? onRegistered;
  final ClientModel? toUpdateClient;
  final Function? onToggleView;

  const RegisterForm({super.key, this.onRegistered, this.onToggleView, this.toUpdateClient});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final AuthService _auth = AuthService();
  final clientDAO = ClientDAO();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  bool _updated = false;
  TextEditingController _email = TextEditingController();
  final _password = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _pseudo = TextEditingController();
  final TextEditingController _currentPW = TextEditingController();

  bool creation = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    creation = widget.toUpdateClient == null;
    super.initState();
    if(!creation){
      _email = TextEditingController(text: widget.toUpdateClient!.email);
      _pseudo = TextEditingController(text: widget.toUpdateClient!.pseudo);
      _fullName = TextEditingController(text: widget.toUpdateClient!.fullName);
    }
  }

  void updated(){
    _updated = true;
  }

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
  Widget build(BuildContext context) {

    final fullNameField = TextFormField(
        controller: _fullName,
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
              Icons.person,
            ),
            labelText: "Prénom Nom",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none )));

    final pseudoField = TextFormField(
        controller: _pseudo,
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
              Icons.person,
            ),
            labelText: "Pseudo",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));

    final emailField = TextFormField(
        controller: _email,
        autofocus: false,
        validator: (value) {
          if (value != null) {
            if (value.contains('@') && (value.endsWith('.com') || value.endsWith('.fr') || value.endsWith('.net'))) {
              return null;
            }
            return 'Entrez une adresse mail valide';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20.0),
            prefixIcon:
            const Icon(
              Icons.mail,
            ),
            labelText: "Email",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));

    final passwordField = TextFormField(
        obscureText: _obscureText,
        controller: _password,
        autofocus: false,
        validator: (value) {
          if (creation && (value == null || value.trim().isEmpty)) {
            return 'Ce champ est requis';
          }
          else if ((!creation && value !=null && value.trim().isNotEmpty && value.trim().length < 8) ||  (creation && value!.trim().length < 8)) {
            return 'Le mot de passe doit contenir au moins 8 caractères';
          }
          // Return null if the entered password is valid
          return null;
        } ,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20.0),
            prefixIcon:
            const Icon(
              Icons.lock,
            ),
            labelText: creation? "Mot de passe" : "Nouveau mot de passe",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: const Color(0x3303d024),
            suffixIcon: IconButton(icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: (){
                setState(() {
                  _obscureText = !_obscureText;
                });
              },),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));


    final confirmPasswordField = TextFormField(
      controller: creation? null : _currentPW,
      obscureText: _obscureTextConfirm,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est requis';
        }
        if (creation && value.trim() != _password.text.trim()) {
          return 'Les mots de passe ne correspondent pas';
        }
        // Return null if the entered password is valid
        return null;
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          prefixIcon: const Icon(
            Icons.lock,
          ),
          labelText: creation? "Confirmer le mot de passe" : "Mot de passe actuel",
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          filled: true,
          fillColor: const Color(0x3303d024),
          suffixIcon: IconButton(
            icon: Icon(
                _obscureTextConfirm ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscureTextConfirm = !_obscureTextConfirm;
              });
            },
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none)),
    );


    final txtbutton = TextButton(
        onPressed: () {
          widget.onToggleView!();
        },
        style: TextButton.styleFrom(foregroundColor: Colors.black,textStyle: const TextStyle(decoration: TextDecoration.underline)),
        child: const Text('Revenir à la connexion',style: TextStyle(fontSize: 15)));

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff009718),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        onPressed: () async {

          if (_formKey.currentState!.validate()) {
            final checkResult = creation ?
            await clientDAO.checkEmailPseudoUnique(
              email: _email.text,
              pseudo: _pseudo.text,
            )
                :
            await clientDAO.checkEmailPseudoUniqueForUpdate(
                email: _email.text,
                pseudo: _pseudo.text,
                id: widget.toUpdateClient!.id
            );

            if (!checkResult.error) {
              if (!checkResult.data!['isUnique']) {
                showPopUp(context, checkResult.data!['errorMessage']);
              }
              else {

                if (creation) {
                  try {
                    dynamic result = await _auth.registerEmailPassword(
                      LoginUser(email: _email.text, password: _password.text),
                      _fullName.text,
                      _pseudo.text,
                    );
                    updated();
                    widget.onRegistered!(result);
                  } catch (err) {
                    showPopUp(context, err.toString());
                    _updated = false;
                  }
                }

                else {
                  dynamic testPW = await _auth.signInEmailPassword(LoginUser(
                      email: widget.toUpdateClient!.email,
                      password: _currentPW.text
                  ));
                  if (testPW.uid == null) {
                    showPopUp(context, testPW.code);
                  } else {
                    if (_email.text != widget.toUpdateClient!.email) {
                      try {
                        await _auth.updateEmail(LoginUser(
                            email: widget.toUpdateClient!.email,
                            password: _currentPW.text), _email.text);
                        Home.currentClient!.email = _email.text;
                      } catch (err) {
                        _updated = false;
                        showPopUp(context, err.toString());
                      }
                    }
                    if (_password.text.isNotEmpty &&
                        _password.text != _currentPW.text) {
                      try {
                        await _auth.updatePassword(LoginUser(
                            email: widget.toUpdateClient!.email,
                            password: _currentPW.text), _password.text);
                      } catch (err) {
                        _updated = false;
                        showPopUp(context, err.toString());
                      }
                    }
                    Home.currentClient!.pseudo = _pseudo.text;
                    Home.currentClient!.fullName = _fullName.text;
                    APIResponse<ClientModel> result = await clientDAO
                        .updateClient(
                        updateClient: Home.currentClient!);
                    if (result.error) {
                      _updated = false;
                      showPopUp(context, result.errorMessage!);
                    }
                    else {
                      updated();
                    }
                  }
                }
              }
              }

            else {
              showPopUp(context, checkResult.errorMessage!);
            }
          }
          if(_updated){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    creation ? "Compte créé avec succès !" : "Les modifications ont bien été enregistrées ."),
              ),
            );
            _updated = false;
          }
        },
        child: Text( creation ?
          "Inscription" : "Enregistrer",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );



    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          fullNameField,
                          const SizedBox(height: 25.0),
                          pseudoField,
                          const SizedBox(height: 25.0),
                          emailField,
                          const SizedBox(height: 25.0),
                          passwordField,
                          const SizedBox(height: 25.0),
                          confirmPasswordField,
                          const SizedBox(height: 25.0),
                          registerButton,
                          const SizedBox(height: 10.0),
                          if(creation) txtbutton,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
