import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Class handling file storage on firebase
class Storage{
  final FirebaseStorage storage = FirebaseStorage.instance;

  /// Upload a file on the firebase cloud using the filepath and filename of the file.
  /// The folder to use to store the file must also be specified
  ///
  /// Parameters:
  /// - filePath: string -> the path to the file to upload
  /// - fileName: string -> the name of the stored file
  /// - folder: string -> the name of the Firestore folder in which the file will be store
  Future<String> uploadFile(String filePath, String fileName, String folder) async {
    File file = File(filePath);

    try{
      Reference storageRef = storage.ref('$folder/$fileName');
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } on FirebaseException catch (error) {
      print(error);
      return '';
    }
  }
}
