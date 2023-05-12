
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_upload/utils/network_utility.dart';
import 'package:image_upload/widgets/lists/location_list_item.dart';






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
  bool outFocus = false;

  final _keyboardVisibilityController = KeyboardVisibilityController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          outFocus = true;
        });
        FocusScope.of(context).unfocus();
      }
      if(_focusNode.hasFocus){
        outFocus = false;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardVisibilityController.onChange.listen((bool visible) {
        if(mounted){
          setState(() {
            if (!visible) {
              outFocus = true;
            } else {
              outFocus = false;
            }
          });
        }
      });
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
    if(!outFocus) {
      placeAutocomplete(widget.controller.text);
    }
  }

  void validate() {
    setState(() {
      _autovalidateMode = true;
      outFocus = true;
    });
  }

  Future<LatLng> getLatLng(String address) async {
    try {
      return await NetworkUtility.getLatLng(address);
    } catch (err){
      rethrow; //TODO handle err
    }
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

    final locationList = Container(
      constraints: const BoxConstraints(maxHeight: 180),
      child: ListView.builder(
        padding: widget.top ? const EdgeInsets.only(top: 2) : null,
        shrinkWrap: true,
        itemCount: placePredictions.length,
        itemBuilder: (context, index) => LocationListItem(
            location: placePredictions[index].description!,
            press: () async {
              setState(() {
                outFocus = true;
              });
              FocusScope.of(context).unfocus();
              String selectedAddress = placePredictions[index].description!;
              LatLng? latLng = await getLatLng(selectedAddress);
              widget.onSelectedLocation(latLng);
              widget.controller.text = selectedAddress; // update the text field with the selected address
              print('Selected place: $selectedAddress, Coordinates: $latLng');
            }
        ),
      ),
    );


    return Column(children: [
      if (widget.top && !outFocus)
        locationList,
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
      if (!widget.top && !outFocus)
        locationList
    ]);
  }
}
