import 'package:image_upload/screens/authenticate/DTOs/loginuser_dto.dart';
import 'package:image_upload/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:image_upload/screens/authenticate/password_reset.dart';
import 'package:image_upload/widgets/wave.dart';


class Login extends StatefulWidget {
  final Function? toggleView;
  Login({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  bool _obscureText = true;
  bool _isLoading = false;

  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  setLoading(bool loading){
    _isLoading = loading;
  }


  @override
  Widget build(BuildContext context) {

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
          if (value == null || value.trim().isEmpty) {
            return 'Ce champ est requis';
          }
          if (value.trim().length < 8) {
            return 'Longueur min: 8 caractères';
          }
          // Return null if the entered password is valid
          return null;
        },
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
            suffixIcon: IconButton(
              icon:
              Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none)));

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        style: TextButton.styleFrom(foregroundColor: Colors.black,textStyle: const TextStyle(decoration: TextDecoration.underline)),
        child: const Text('Inscrivez vous ici !',style: TextStyle(fontSize: 15)));


    final loginEmailPasswordButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff009718),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setLoading(true);
            dynamic result = await _auth.signInEmailPassword(LoginUser(email: _email.text,password: _password.text));
            setLoading(false);
            if (result.uid == null) { //null means unsuccessfull authentication
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code),
                    );
                  });
            }
          }
        },
        child: _isLoading ? const SizedBox(height: 20, width: 20,child: CircularProgressIndicator(),) :
        const Text(
          "Connexion",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );


    final loginWithGoogleButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        onPressed: () async {
          dynamic result = await _auth.signInWithGoogle();
            if (result?.uid == null) { //null means unsuccessfull authentication
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code),
                    );
                  });
            }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit), // Icône Google
            SizedBox(width: 10), // Espace entre l'icône et le texte
            Text(
              "Connexion avec Google",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    final separator = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Colors.grey.shade300,
              height: 36,
            ),
          ),
        ),
        Text(
          'Ou connectez-vous avec',
          style: TextStyle(color: Colors.grey),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.grey.shade300,
              height: 36,
            ),
          ),
        ),
      ],
    );


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 5.0),
                          emailField,
                          const SizedBox(height: 35.0),
                          passwordField,
                          const SizedBox(height: 35.0),
                          loginEmailPasswordButon,
                          const SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () => PasswordReset.resetPassword(context, _auth),
                            child: const Text(
                              'Mot de passe oublié?',
                              style: TextStyle(
                                  fontSize: 15, decoration: TextDecoration.underline),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Pas encore de compte?',style: TextStyle(fontSize: 15)),
                              txtbutton,
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          separator,
                          const SizedBox(height: 10.0),
                          loginWithGoogleButton,
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Wave(0.75, 0.4, 0.5, positionTop: 0, positionLeft: 0, positionRight: 0,
              positionTopText: 70, positionLeftText: 30, height: 200, label: "Bienvenue !",),
        ],
      ),
    );
  }
}
