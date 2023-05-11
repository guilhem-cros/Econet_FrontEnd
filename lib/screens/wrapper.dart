import 'package:provider/provider.dart';
import '../models/firebaseuser.dart';
import '../screens/home/home.dart';
import 'package:flutter/material.dart';

import 'authenticate/handler.dart';

class Wrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    final user =  Provider.of<FirebaseUser?>(context);

    if(user == null)
    {
      return Handler();
    }
    else if (user.uid == null)
    {
      return Handler();
    }
    else {
            return Home(firebaseId: user.uid!);
    }

  }
}
