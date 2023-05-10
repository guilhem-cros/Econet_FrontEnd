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

  const SearchLocation({Key? key, required this.top, required this.decoration, required this.onSelectedLocation, this.validator}) : super(key: key);

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<AutocompletePrediction> placePredictions = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    placeAutocomplete(_searchController.text);
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.top && placePredictions.isNotEmpty)
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationList(
                  location: placePredictions[index].description!,
                  press: () async {
                    String selectedAddress = placePredictions[index].description!;
                    LatLng? latLng = await getLatLng(selectedAddress);
                    widget.onSelectedLocation(latLng);
                    _searchController.text = selectedAddress; // update the text field with the selected address
                    print('Selected place: $selectedAddress, Coordinates: $latLng');
                  }
              ),
            ),
          ),
        ),
      Form(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            validator: widget.validator,
            focusNode: _focusNode,
            controller: _searchController,
            onChanged: (value) {
              placeAutocomplete(value);
            },
            textInputAction: TextInputAction.search,
            decoration: widget.decoration,
          ),
        ),
      ),
      if (!widget.top && placePredictions.isNotEmpty)
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationList(
                  location: placePredictions[index].description!,
                  press: () async {
                    String selectedAddress = placePredictions[index].description!;
                    LatLng? latLng = await getLatLng(selectedAddress);
                    widget.onSelectedLocation(latLng);
                    _searchController.text = selectedAddress; // update the text field with the selected address
                    print('Selected place: $selectedAddress, Coordinates: $latLng');
                  }
              ),
            ),
          ),
        ),
    ]);
  }
}
