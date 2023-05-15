// To parse this JSON data, do
//
//     final ecospotModel = ecospotModelFromJson(jsonString);

import 'dart:convert';

EcospotModel ecospotModelFromJson(String str) => EcospotModel.fromJson(json.decode(str));

String ecospotModelToJson(EcospotModel data) => json.encode(data.toJson());

List<EcospotModel> ecospotListFromJson(String str) => List<EcospotModel>.from(json.decode(str).map((x) => EcospotModel.fromJson(x)));

String ecospotListToJson(List<EcospotModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// A model representing an ecospot based on the representation in the DB.
class EcospotModel {

  EcospotModel({
    required this.id,
    required this.name,
    required this.address,
    required this.details,
    required this.tips,
    required this.pictureUrl,
    required this.mainType,
    required this.otherTypes,
    required this.isPublished,
  });

  ///The id of the ecospot in the DB
  String id;
  ///The name of the ecospot
  String name;
  ///The address of the ecospot ("Lattitude;Longitude")
  String address;
  ///The details concerning the ecospot
  String details;
  ///The tips concerning the ecospot
  String tips;
  ///The url of the picture associated to the ecospot
  String pictureUrl;
  ///The id of the Type object linked to the ecospot
  MainType mainType;
  ///A list containing the ids of the the others Type objects linked to the ecospot
  List<String> otherTypes;
  ///A boolean which indicates if the ecospot is directly visible by all the clients
  bool isPublished;

  factory EcospotModel.fromJson(Map<String, dynamic> json) => EcospotModel(
    id: json["_id"],
    name: json["name"],
    address: json["address"],
    details: json["details"],
    tips: json["tips"],
    pictureUrl: json["picture_url"],
    mainType: MainType.fromJson(json["main_type"]),
    otherTypes: List<String>.from(json["other_types"].map((x) => x)),
    isPublished: json["isPublished"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "address": address,
    "details": details,
    "tips": tips,
    "picture_url": pictureUrl,
    "main_type": mainType.toJson(),
    "other_types": List<dynamic>.from(otherTypes.map((x) => x)),
    "isPublished": isPublished,
  };
}

class MainType {
  MainType({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
    required this.logoUrl,
  });

  String id;
  String name;
  String color;
  String description;
  String logoUrl;

  factory MainType.fromJson(Map<String, dynamic> json) => MainType(
    id: json["_id"],
    name: json["name"],
    color: json["color"],
    description: json["description"],
    logoUrl: json["logo_url"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "color": color,
    "description": description,
    "logo_url": logoUrl,
  };
}
