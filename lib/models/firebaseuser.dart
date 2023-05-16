///A model representing an user based on his Firebase identifier
class FirebaseUser {

  /// Firebase uid of the user
  final String? uid ;
  /// Firebase exception code
  final String? code;
  final String? email;
  FirebaseUser({this.uid,this.code, this.email});
}
