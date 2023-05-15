import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_upload/DAOs/client_DAO.dart';
import 'package:image_upload/models/api_response.dart';
import 'package:image_upload/models/client.dart';
import 'package:image_upload/services/DTOs/loginuser_dto.dart';
import '../models/firebaseuser.dart';

/// Class handling authentication via firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


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

  Future<FirebaseUser?> signInWithGoogle() async {
    try{
      final clientDAO = ClientDAO();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Envoie les données à l'API après la création réussie de l'utilisateur
      if (user != null) {
        APIResponse<ClientModel> createdCli = await clientDAO.createClient(
          fullName: user.displayName!,
          pseudo: user.email!.split('@')[0],//TODO enlever apres le @
          email: user.email!,
          firebaseId: user.uid,
        );

        if(createdCli.error){
          return FirebaseUser(code: "Server error", uid: null);
        } else {
          return _firebaseUser(user);
        }
      }
    }
    on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }

  }



  /// Register an user into firebase and then use its firbase id to store the client
  /// into the database
  Future registerEmailPassword(LoginUser login, String fullName, String pseudo) async {
    try {
      final clientDAO = ClientDAO();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: login.email.toString(),
          password: login.password.toString());
      User? user = userCredential.user;

      // Envoie les données à l'API après la création réussie de l'utilisateur
      if (user != null) {
        APIResponse<ClientModel> createdCli = await clientDAO.createClient(
          fullName: fullName,
          pseudo: pseudo,
          email: login.email.toString(),
          firebaseId: user.uid,
        );

        if(createdCli.error){
          return FirebaseUser(code: "Server error", uid: null);
        } else {
          return _firebaseUser(user);
        }
      }

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

  Future<String?> getUserToken() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String? token = await user.getIdToken();
      return token;
    } else {
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
