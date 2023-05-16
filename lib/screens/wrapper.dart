import 'package:provider/provider.dart';
import '../models/firebaseuser.dart';
import '../screens/home/home.dart';
import 'package:flutter/material.dart';

import 'account/handler_auth_screen.dart';

/// Handler of screens for the App
class Wrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    /// Connected firebase user
    final user =  Provider.of<FirebaseUser?>(context);

    if(user == null)
    {
      return const Handler();
    }
    else if (user.uid == null)
    {
      return const Handler();
    }
    else { // if an user is connected
            return Home(firebaseId: user.uid!,email: user.email!);
    }

  }
}
