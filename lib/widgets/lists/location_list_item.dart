import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationListItem extends StatelessWidget {
  final String location;
  final VoidCallback press;

  const LocationListItem({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  0.65*MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, top: 0),
      child:  Column(
        children: [
          ListTile(
            onTap: press,
            horizontalTitleGap: 0,
            title: Text(
              location,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );

  }
}
