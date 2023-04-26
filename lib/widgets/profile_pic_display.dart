import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePicDisplay extends StatelessWidget {

  final String profilePicUrl;
  final VoidCallback onPressed;

  const ProfilePicDisplay({
    super.key,
    required this.profilePicUrl,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    const color = Color.fromRGBO(64, 105, 225, 1);

    return Center(
        child: Stack(children: [
          buildImage(color),
          Positioned(
            right: 4,
            top: 10,
            child: buildEditIcon(color),
          )
        ]));
    }

    // Builds Profile Image
    Widget buildImage(Color color) {
      final image = profilePicUrl.contains('https://')
          ? NetworkImage(profilePicUrl)
          : FileImage(File(profilePicUrl));

      return CircleAvatar(
        radius: 75,
        backgroundColor: color,
        child: CircleAvatar(
          backgroundImage: image as ImageProvider,
          backgroundColor: Colors.white,
          radius: 73,
        ),
      );
    }

    // Builds Edit Icon on Profile Picture
    Widget buildEditIcon(Color color) => buildCircle(
        child: IconButton(
          icon: const Icon(Icons.photo_camera),
          iconSize: 20,
          color: color,
          onPressed: onPressed,
        ));

    // Builds/Makes Circle for Edit Icon on Profile Picture
    Widget buildCircle({
      required Widget child,
    }) =>
        ClipOval(
            child: Container(
              color: const Color.fromRGBO(238, 238 , 238, 1),
              width: 38,
              height: 38,
              child: child,
            ));
}