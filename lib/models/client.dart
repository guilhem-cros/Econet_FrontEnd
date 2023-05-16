// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

import 'package:image_upload/models/ecospot.dart';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

/// A model representing a client based on the representation in the DB.
class ClientModel {

  ClientModel({
    required this.id,
    required this.fullName,
    required this.pseudo,
    this.email,
    required this.firebaseId,
    required this.isAdmin,
    required this.profilePicUrl,
    required this.favArticles,
    required this.createdPublications,
    required this.favEcospots,
    required this.createdEcospots,
  });

  ///The id of the client in the DB
  String id;
  ///The full name of the client
  String fullName;
  ///The pseudo of the client
  String pseudo;
  ///The email of the client
  String? email;
  ///The firebase identifier of the client
  String firebaseId;
  ///Indicates if the client is an admin or not
  bool isAdmin;
  ///The url of the profile picture of the client
  String profilePicUrl;
  ///A list containing the ids of the favorites Articles of the client
  List<String> favArticles;
  ///A list containing the ids of the different Publications created by the client
  List<String> createdPublications;
  ///A list containing the ids of the favorites Ecospots of the client
  List<EcospotModel> favEcospots;
  ///A list containing the ids of the different Ecospots created by the client
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
    "firebaseId": firebaseId,
    "isAdmin": isAdmin,
    "profile_pic_url": profilePicUrl,
    "fav_articles": List<String>.from(favArticles.map((x) => x)),
    "created_publications": List<String>.from(createdPublications.map((x) => x)),
    "fav_ecospots": List<dynamic>.from(favEcospots.map((x) => x)),
    "created_ecospots": List<dynamic>.from(createdEcospots.map((x) => x)),
  };
}
