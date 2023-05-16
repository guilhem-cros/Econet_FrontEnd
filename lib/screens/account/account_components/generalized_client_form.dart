import 'package:flutter/material.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/models/firebaseuser.dart';
import 'package:image_upload/services/DTOs/loginuser_dto.dart';
import 'package:image_upload/services/auth.dart';
import '../../../DAOs/client_DAO.dart';
import '../../home/home.dart';

/// Generalized form handling creation and updated of a Client
class GeneralizedClientForm extends StatefulWidget {

  /// Client object to update, used to prefill the form
  /// null if the form concerns a creation
  final ClientModel? toUpdateClient;
  /// Function called when the login link is clicked
  final Function? onToggleView;
  /// function to call after the form has been submitted
  final Function? onSubmit;

  const GeneralizedClientForm({super.key, this.onToggleView, this.toUpdateClient, this.onSubmit});

  @override
  _GeneralizedClientFormState createState() => _GeneralizedClientFormState();
}

class _GeneralizedClientFormState extends State<GeneralizedClientForm> {
  final AuthService _auth = AuthService();
  final clientDAO = ClientDAO();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  TextEditingController _email = TextEditingController();
  final _password = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _pseudo = TextEditingController();
  final TextEditingController _currentPW = TextEditingController();

  /// true if the form concerns a creation, false if not
  bool creation = false;
  /// true if the form is currently submitting data, false if not
  bool isUpdating = false;

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

  /// Close the form and show a notification about the success of the submit
  void submitted(bool updated){
    if(mounted) {
      setState(() {
        isUpdating = false;
      });
    }
    if(updated){
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                creation
                    ? "Compte créé avec succès !"
                    : "Les modifications ont bien été enregistrées ."),
          ),
        );
      }
      if(widget.onSubmit != null){
        widget.onSubmit!();
      }
      if(!creation){
        Navigator.pop(context);
      }
    }
  }

  /// Open an informative popup
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

    /// TextField concerning the name of the Client
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

    /// TextField concerning the pseudo of the client
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

    /// TextField concerning the email of the Client
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

    /// TextField concerning the password
    /// Concerns new password in case of update
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


    /// TextField concerning the password confirmation
    /// Concerns the old password in case of update
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

    /// Submit button handling the creation and update
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff009718),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        onPressed: () async {

          setState(() {
            isUpdating = true; // has submitted -> showing the CircularProgressIndicator
          });

          if (_formKey.currentState!.validate()) { // if every necessary field has been filled

            // checking email and pseudo are unique
            final checkResult = creation ?
            await clientDAO.checkPseudoUnique(
              pseudo: _pseudo.text,
            )
                :
            await clientDAO.checkPseudoUniqueForUpdate(
                pseudo: _pseudo.text,
                id: widget.toUpdateClient!.id
            );

            if (!checkResult.error) {
              if (!checkResult.data!['isUnique']) { //pseudo not unique
                showPopUp(context, checkResult.data!['errorMessage']); // showing an info msg
                submitted(false); // hiding the progress indicator
              }
              else { // email and pseudo unique

                if (creation) { //creation form
                  try {
                    final FirebaseUser user = await _auth.registerEmailPassword(
                      LoginUser(email: _email.text, password: _password.text),
                      _fullName.text,
                      _pseudo.text,
                    ); // registering th user into firebase and then into the database
                    if(user.uid == null){
                      showPopUp(context, "L'email saisi est déjà associé à un compte");
                      submitted(false);
                      return;
                    }else {
                      submitted(true);
                    }
                  } catch (err) {
                    showPopUp(context, err.toString());
                    submitted(false);
                  }
                }

                else { // update form
                  dynamic testPW = await _auth.signInEmailPassword(LoginUser(
                      email: widget.toUpdateClient!.email,
                      password: _currentPW.text
                  ));
                  if (testPW.uid == null) { // old password and email doesn't match
                    showPopUp(context, testPW.code);
                    submitted(false);
                  } else { // old password and email match
                    if (_email.text != widget.toUpdateClient!.email) { //if updating mail
                      try {
                        await _auth.updateEmail(LoginUser(
                            email: widget.toUpdateClient!.email,
                            password: _currentPW.text), _email.text);
                        Home.currentClient!.email = _email.text;
                      } catch (err) {
                        showPopUp(context, err.toString());
                        submitted(false);
                      }
                    }
                    if (_password.text.isNotEmpty &&
                        _password.text != _currentPW.text) { // if updating password
                      try {
                        await _auth.updatePassword(LoginUser(
                            email: widget.toUpdateClient!.email,
                            password: _currentPW.text), _password.text);
                      } catch (err) {
                        showPopUp(context, err.toString());
                        submitted(false);
                      }
                    }
                    Home.currentClient!.pseudo = _pseudo.text;
                    Home.currentClient!.fullName = _fullName.text;
                    APIResponse<ClientModel> result = await clientDAO
                        .updateClient(
                        updateClient: Home.currentClient!,
                        email: _email.text
                    ); //updating client into DB
                    if (result.error) {
                      showPopUp(context, result.errorMessage!);
                      submitted(false);
                    }
                    else {
                      submitted(true);
                    }
                  }
                }
              }
              }

            else {
              showPopUp(context, checkResult.errorMessage!);
              submitted(false);
            }
          } else {
            submitted(false);
          }
        },
        child: isUpdating ? // showing a progress indicator if currently submitting data
        const SizedBox(height: 20, width: 20 ,child: CircularProgressIndicator()) :
        Text( creation ?
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
              padding: creation? const EdgeInsets.only(top: 150) : const EdgeInsets.only(top: 0),
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
