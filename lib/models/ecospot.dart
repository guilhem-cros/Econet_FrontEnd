import 'package:image_upload/models/spot.dart';

/// Class corresponding to an Ecospot object
class Ecospot extends Spot{

  String details;
  String tips;
  String pictureUrl;
  bool isPublished;
  Type mainType;
  List<String> otherTypes;

  Ecospot({
    required super.id,
    required super.address,
    required super.name,
    required this.details,
    required this.tips,
    required this.pictureUrl,
    required this.isPublished,
    required this.mainType,
    required this.otherTypes
  });




}