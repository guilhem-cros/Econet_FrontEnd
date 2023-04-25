import 'package:image_upload/screens/authenticate/DTOs/loginuser_dto.dart';
import 'package:image_upload/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/widgets/wave.dart';
import '../../DAOs/client_DAO.dart';

class Register extends StatefulWidget{

  final Function? toggleView;
  Register({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register>{
  final AuthService _auth = AuthService();
  final clientDAO = ClientDAO();

  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _full_name = TextEditingController();
  final _pseudo = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final full_nameField = TextFormField(
        controller: _full_name,
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
            if (value.contains('@') && value.endsWith('.com')) {
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
          if (value == null || value.trim().isEmpty) {
            return 'Ce champ est requis';
          }
          if (value.trim().length < 8) {
            return 'Password must be at least 8 characters in length';
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
            labelText: "Mot de passe",
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
      obscureText: _obscureTextConfirm,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est requis';
        }
        if (value.trim() != _password.text.trim()) {
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
          labelText: "Confirmer le mot de passe",
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
          widget.toggleView!();
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
            final checkResult = await clientDAO.checkEmailPseudoUnique(
              email: _email.text,
              pseudo: _pseudo.text,
            );

            if (!checkResult['isUnique']) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(checkResult['errorMessage']),
                  );
                },
              );
            } else {
              dynamic result = await _auth.registerEmailPassword(
                LoginUser(email: _email.text, password: _password.text),
                _full_name.text,
                _pseudo.text,
              );

              if (result.uid == null) { //null means unsuccessfull authentication
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(result.toString()),
                      );
                    });
              }
            }
          }
        },
        child: const Text(
          "Inscription",
          style: TextStyle(
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
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          full_nameField,
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
                          txtbutton,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Wave(0.25, 0.6, 0.75, positionTop: 0, positionLeft: 0, positionRight: 0,
              positionTopText: 40, positionRightText: 30, height: 150),
        ],
      ),
    );
  }

}

