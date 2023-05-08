import 'package:flutter/material.dart';

/// Class representing the screen displayed in case of a fatal error
/// blocking the process of the app
class ErrorScreen extends StatelessWidget {

  /// The error message printed
  final String errorMessage;

  const ErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60,),
          const Text("Une erreur est survenue", style: TextStyle(fontSize: 22),),
          Text(errorMessage, style: const TextStyle(fontSize: 18),),
          const SizedBox(height: 10),
          const Text("Veuillez redémarrer l'application. Si l'erreur persiste, contactez le support.",textAlign: TextAlign.center,),
        ],
      )
    );
  }

}