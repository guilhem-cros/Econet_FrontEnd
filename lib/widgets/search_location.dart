import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_upload/utils/network_utility.dart';
import 'package:image_upload/widgets/lists/location_list.dart';
import 'package:http/http.dart' as http;


import '../models/place_autocomplete_response.dart';
import '../models/autocomplete_prediction.dart';

class SearchLocation extends StatefulWidget {
  final bool top;
  final InputDecoration decoration;
  final ValueChanged<LatLng?> onSelectedLocation;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormFieldState>? formFieldKey;
  final ValueChanged<List<String>>? onSuggestionsUpdate;
  final TextEditingController controller;
  final double padding;

  const SearchLocation({Key? key, required this.top, required this.decoration, required this.onSelectedLocation, this.validator, this.formFieldKey, this.onSuggestionsUpdate, required this.controller, required this.padding}) : super(key: key);

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<AutocompletePrediction> placePredictions = [];
  final FocusNode _focusNode = FocusNode();
  bool _autovalidateMode = false;


  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // If search bar is not in focus, clear the list
        setState(() {
          placePredictions = [];
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSearchChanged);
    widget.controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    placeAutocomplete(widget.controller.text);
  }

  void validate() {
    setState(() {
      _autovalidateMode = true;
    });
  }

  Future<LatLng> getLatLng(String address) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/geocode/json',
        {
          "address": address,
          "key": dotenv.env['API_KEY'],
        }
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson['status'] == 'OK') {
        final location = responseJson['results'][0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      }
    }
    throw Exception('Failed to get LatLng');
  }

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com", '/maps/api/place/autocomplete/json', {
      "input": query,
      "key": dotenv.env['API_KEY'],
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
        if (widget.onSuggestionsUpdate != null) {
          widget.onSuggestionsUpdate!(placePredictions.map((p) => p.description!).toList());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.top && placePredictions.isNotEmpty)
        Container(
          constraints: BoxConstraints(maxHeight: 180),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 2),
            shrinkWrap: true,
            itemCount: placePredictions.length,
            itemBuilder: (context, index) => LocationList(
                location: placePredictions[index].description!,
                press: () async {
                  String selectedAddress = placePredictions[index].description!;
                  LatLng? latLng = await getLatLng(selectedAddress);
                  widget.onSelectedLocation(latLng);
                  widget.controller.text = selectedAddress; // update the text field with the selected address
                  print('Selected place: $selectedAddress, Coordinates: $latLng');
                }
            ),
          ),
        ),
      Form(
        child: Padding(
          padding: EdgeInsets.all(widget.padding),
          child: TextFormField(
            key: widget.formFieldKey,
            autovalidateMode: _autovalidateMode ? AutovalidateMode.always : AutovalidateMode.disabled,
            validator: widget.validator,
            focusNode: _focusNode,
            controller: widget.controller,
            onChanged: (value) {
              placeAutocomplete(value);
            },
            textInputAction: TextInputAction.search,
            decoration: widget.decoration,
          ),
        ),
      ),
      if (!widget.top && placePredictions.isNotEmpty)
        Container(
          constraints: BoxConstraints(maxHeight: 180),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: placePredictions.length,
            itemBuilder: (context, index) => LocationList(
                location: placePredictions[index].description!,
                press: () async {
                  String selectedAddress = placePredictions[index].description!;
                  LatLng? latLng = await getLatLng(selectedAddress);
                  widget.onSelectedLocation(latLng);
                  widget.controller.text = selectedAddress; // update the text field with the selected address
                  print('Selected place: $selectedAddress, Coordinates: $latLng');
                }
            ),
          ),
        ),
    ]);
  }
}
