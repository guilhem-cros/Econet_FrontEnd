///A model representing an user based on his Firebase identifier
class FirebaseUser {
  final String? uid ;
  final String? code; //code firebaseauth excemption
  FirebaseUser({this.uid,this.code});
}
