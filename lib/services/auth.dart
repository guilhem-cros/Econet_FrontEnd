import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_upload/DAOs/client_DAO.dart';
import '../models/firebaseuser.dart';
import '../screens/authenticate/DTOs/loginuser_dto.dart';

/// Class handling authentication via firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final clientDAO = ClientDAO();

  /// Login to an existing firebase account using an email and a password
  /// Return the logged client
  Future signInEmailPassword(LoginUser login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: login.email.toString(),
          password: login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }

  /// Register an user into firebase and then use its firbase id to store the client
  /// into the database
  Future registerEmailPassword(LoginUser login, String fullName, String pseudo) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: login.email.toString(),
          password: login.password.toString());
      User? user = userCredential.user;

      // Envoie les données à l'API après la création réussie de l'utilisateur
      if (user != null) {
        await clientDAO.createClient(
          fullName: fullName,
          pseudo: pseudo,
          email: login.email.toString(),
          firebaseId: user.uid,
        );
      }

      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  /// Handle the password reset
  Future resetPassword({required String email}) async {
    try{
      return await _auth
          .sendPasswordResetEmail(email: email);
    }
    catch(e){
      return null;
    }
  }

  /// Connects an user using mail and password and update its email into firebase
  /// Throws an exception if an error occurs during process
  Future updateEmail(LoginUser login, String newEmail) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: login.email.toString(),
          password: login.password.toString());
      await userCredential.user!.updateEmail(newEmail);
    } on FirebaseAuthException {
      throw Exception("Mot de passe invalide");
    }
  }

  /// Connects an user using mail and password and update its password into firebase
  /// Throws an exception if an error occurs during process
  Future updatePassword(LoginUser login, String newPassword) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: login.email.toString(),
          password: login.password.toString());
      await userCredential.user!.updatePassword(newPassword);
    } on FirebaseAuthException {
      throw Exception("Mot de passe invalide");
    }
  }

  //TODO: Sign in with Google

  /// Disconnect the curretly connected user from the firebase instance
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }
}
