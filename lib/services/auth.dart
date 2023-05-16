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
  ///
  /// Parameters:
  /// - login: LoginUser -> object containing the information necessary to login a user
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

  /// Login to an existing firebase account using a Google account
  /// Return the logged client
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
          pseudo: user.email!.split('@')[0],
          email: user.email!,
          firebaseId: user.uid,
        );

        if(createdCli.error){
          return FirebaseUser(code: "Server error", uid: null);
        } else {
          await signOut();

          // Once signed in, return the UserCredential
          UserCredential awaitedUserCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          User? awaitedUser = awaitedUserCredential.user;
          return _firebaseUser(awaitedUser);
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
  ///
  /// Parameters:
  /// - login: LoginUser -> object which contains a part of the necessary information to register a user (email, password)
  /// - fullName: string -> the full name of the user
  /// - pseudo: string -> the pseudo of the user
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
          await signOut();
          return await signInEmailPassword(login);
        }
      }

    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  /// Handle the password reset
  ///
  /// Parameters:
  /// - email: string -> the email of the user to which the new password will be send
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
  ///
  /// Parameters:
  /// - login: LoginUser -> object containing the necessary user credentials
  /// - newEmail: string -> the new email of the user
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
  ///
  /// Parameters:
  /// - login: LoginUser -> object containing the necessary user credentials
  /// - newPassword: string -> the new password of the user
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


  /// Disconnect the curretly connected user from the firebase instance
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  /// Get the token of the currently connected user
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
    return user != null ? FirebaseUser(uid: user.uid, email: user.email) : null;
  }

  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }
}
