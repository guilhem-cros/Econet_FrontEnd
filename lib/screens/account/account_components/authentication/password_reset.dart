import 'package:flutter/material.dart';
import 'package:image_upload/services/auth.dart';

/// Class handling the password reset of a client by opening a popup
class PasswordReset{
  static Future<void> resetPassword(BuildContext context, AuthService _auth) async {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Réinitialisation du mot de passe"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Veuillez entrer votre adresse e-mail :"),
              TextField(controller: emailController),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Valider"),
              onPressed: () async {
                await _auth.resetPassword(email: emailController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Un e-mail de réinitialisation du mot de passe a été envoyé à ${emailController.text}. Veuillez vérifier votre boîte de réception et suivre les instructions."),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

