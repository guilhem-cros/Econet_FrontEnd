import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_upload/service/storage_service.dart';
import 'package:image_upload/widget/EcospotCard.dart';
import 'package:image_upload/widget/ImagePicker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
        body: EcospotCard()
    );
  }

}

/* POUR IMAGE UPLOAD

class _HomeScreenState extends State<HomeScreen>{

  PlatformFile? selectedImage;
  final Storage storage = Storage();

  void setSelectedImage(PlatformFile newFile){
    selectedImage = newFile;
    print(selectedImage!.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image")
      ),
      body: Column(
        children: [
          Center(
            child: ImagePicker(
              label: 'Sélectionner une image',
              setSelectedImage: setSelectedImage,
           ),
          ),
              Center(
                child: ElevatedButton(
                onPressed: () {
                  storage.uploadFile(selectedImage!.path!, selectedImage!.name, 'profile_pics');
                },
                child: Text('Enregistrer')
                )
              )
        ],
      )
    );
  }
  
}
*/

