// To parse this JSON data, do
//
//     final typeModel = typeModelFromJson(jsonString);

import 'dart:convert';

TypeModel typeModelFromJson(String str) => TypeModel.fromJson(json.decode(str));

String typeModelToJson(TypeModel data) => json.encode(data.toJson());

List<TypeModel> typeListFromJson(String str) => List<TypeModel>.from(json.decode(str).map((x) => TypeModel.fromJson(x)));

String typeListToJson(List<TypeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeModel {
  TypeModel({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
    required this.logoUrl,
    required this.associatedSpots,
  });

  String id;
  String name;
  String color;
  String description;
  String logoUrl;
  List<String> associatedSpots;

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
    id: json["_id"],
    name: json["name"],
    color: json["color"],
    description: json["description"],
    logoUrl: json["logo_url"],
    associatedSpots: List<String>.from(json["associated_spots"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "color": color,
    "description": description,
    "logo_url": logoUrl,
    "associated_spots": List<dynamic>.from(associatedSpots.map((x) => x)),
  };
}
