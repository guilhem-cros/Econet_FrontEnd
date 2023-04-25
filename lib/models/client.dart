// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

import 'package:image_upload/models/ecospot.dart';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  ClientModel({
    required this.id,
    required this.fullName,
    required this.pseudo,
    required this.email,
    required this.firebaseId,
    required this.isAdmin,
    required this.profilePicUrl,
    required this.favArticles,
    required this.createdPublications,
    required this.favEcospots,
    required this.createdEcospots,
  });

  String id;
  String fullName;
  String pseudo;
  String email;
  String firebaseId;
  bool isAdmin;
  String profilePicUrl;
  List<String> favArticles;
  List<String> createdPublications;
  List<EcospotModel> favEcospots;
  List<EcospotModel> createdEcospots;

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json["_id"],
    fullName: json["full_name"],
    pseudo: json["pseudo"],
    email: json["email"],
    firebaseId: json["firebaseId"],
    isAdmin: json["isAdmin"],
    profilePicUrl: json["profile_pic_url"],
    favArticles: List<String>.from(json["fav_articles"].map((x) => x)),
    createdPublications: List<String>.from(json["created_publications"].map((x) => x)),
    favEcospots: List<EcospotModel>.from(json["fav_ecospots"].map((x) => EcospotModel.fromJson(x))),
    createdEcospots: List<EcospotModel>.from(json["created_ecospots"].map((x) => EcospotModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "pseudo": pseudo,
    "email": email,
    "firebaseId": firebaseId,
    "isAdmin": isAdmin,
    "profile_pic_url": profilePicUrl,
    "fav_articles": List<String>.from(favArticles.map((x) => x)),
    "created_publications": List<String>.from(createdPublications.map((x) => x)),
    "fav_ecospots": List<dynamic>.from(favEcospots.map((x) => x)),
    "created_ecospots": List<dynamic>.from(createdEcospots.map((x) => x)),
  };
}
