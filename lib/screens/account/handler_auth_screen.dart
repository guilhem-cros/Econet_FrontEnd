import 'package:image_upload/screens/account/account_components/authentication/login.dart';
import 'package:image_upload/screens/account/account_components/authentication/register.dart';
import 'package:flutter/material.dart';

/// Screen handling the authentication into the app (register and login)
class Handler extends StatefulWidget {

  const Handler({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Handler();
  }
}

class _Handler extends State<Handler> {

  /// True if showing the login page, false if showing the register page
  bool showSignin = true;

  void toggleView(){
    setState(() {
      showSignin = !showSignin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignin)
    {
      return Login(toggleView : toggleView);
    }else
    {
      return Register(toggleView : toggleView);
    }
  }
}
