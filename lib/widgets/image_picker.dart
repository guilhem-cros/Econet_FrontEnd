import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


/// Type corresponding to a callback function taking a PlatformFile object as param
typedef CallBackFunction = void Function(PlatformFile);


/// Custom widget containing a FilePicker handling image selection
class ImagePicker extends StatefulWidget {

  /// The label displayed in the picker button
  final String label;
  /// The function called after file selection
  final CallBackFunction setSelectedImage;
  double previewHeight;
  double previewWidth;

  final String? currentImageURL;

  ImagePicker({
    super.key,
    required this.label,
    required this.setSelectedImage,
    this.currentImageURL,
    this.previewHeight = 140,
    this.previewWidth = 140
  });

  @override
  State<ImagePicker> createState() => _ImagePickerState();

}


class _ImagePickerState extends State<ImagePicker>{

  /// The currently displayed file
  File? _imageFile;

   /// Set the current file to a new specified file
   /// and handling the change in the UI (using state)
  void setCurrentFile(PlatformFile newFile){
    setState(() {
      _imageFile = File(newFile.path!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.custom,
                allowedExtensions: ['png', 'jpg', 'jpeg']
            );
            if(result != null){
              setCurrentFile(result.files.single);
              widget.setSelectedImage(result.files.single);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(81, 129, 253, 1),
            minimumSize: Size(0.75*MediaQuery.of(context).size.width, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold)
          ),
          label: Text(widget.label),
          icon: const Icon(Icons.photo)
        ),
        const SizedBox(height: 5,),
        if (_imageFile != null || widget.currentImageURL != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: const Color.fromRGBO(81, 129, 253, 1), width: 2)
            ),
            child: _imageFile!=null ?
            Image.file(
              _imageFile!,
              width: widget.previewWidth,
              height: widget.previewHeight,
              fit: BoxFit.fitWidth
            )
                :
            Image.network(
              widget.currentImageURL!,
              width: widget.previewWidth,
              height: widget.previewHeight,
              fit: BoxFit.fitWidth
            )
          )
      ]
    );
  }

}