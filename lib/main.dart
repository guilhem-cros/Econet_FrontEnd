import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_upload/models/displayed_ecospot.dart';
import 'package:provider/provider.dart';

import 'models/firebaseuser.dart';
import 'services/auth.dart';
import 'screens/wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "lib/.env");
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [
        StreamProvider<FirebaseUser?>.value(
          value: AuthService().user,
          initialData: null,
        ),
        ChangeNotifierProvider<DisplayedEcospot>(
          create: (_) => DisplayedEcospot(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.black,
            textTheme: ButtonTextTheme.primary,
            colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
          ),
          fontFamily: 'Inter',
        ),
        home: Wrapper(),
      ),);

  }
}
