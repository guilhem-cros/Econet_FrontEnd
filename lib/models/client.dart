import 'Ecospot.dart';

class Client {

  final String id;
  String fullName;
  String pseudo;
  String email;
  String firebaseId;
  bool isAdmin;
  String profilePicUrl;
  //List<Article> favArticles;
  //List<Publication> createdPublications;
  List<Ecospot> favEcospots;
  List<Ecospot> createdEcospots;

  Client({
    required this.id,
    required this.fullName,
    required this.pseudo,
    required this.email,
    required this.firebaseId,
    required this.isAdmin,
    required this.profilePicUrl,
    required this.favEcospots,
    required this.createdEcospots
  });

  /// Check if a specified ecospot is one of the favorite ones for this client
  bool isFavorite(Ecospot ecospot){
    int i = 0;
    bool found = false;
    while(i<favEcospots.length && !found){
      if(ecospot.id == favEcospots[i].id){
        found = true;
      }
      i++;
    }
    return found;
  }

}