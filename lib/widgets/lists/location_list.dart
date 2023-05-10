import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationList extends StatelessWidget {
  final String location;
  final VoidCallback press;

  const LocationList({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
        ListTile(
        onTap: press,
        horizontalTitleGap: 0,
        title: Text(
          location,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
          leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
        ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade300,
          ),
        ],
    );
  }
}
