import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_upload/DAOs/client_DAO.dart';
import '../models/firebaseuser.dart';
import '../screens/authenticate/DTOs/loginuser_dto.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final clientDAO = ClientDAO();

  Future signInEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _login.email.toString(),
          password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }

  Future registerEmailPassword(LoginUser _login, String full_name, String pseudo) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _login.email.toString(),
          password: _login.password.toString());
      User? user = userCredential.user;

      // Envoie les données à l'API après la création réussie de l'utilisateur
      if (user != null) {
        await clientDAO.createClient(
          full_name: full_name,
          pseudo: pseudo,
          email: _login.email.toString(),
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

  Future resetPassword({required String email}) async {
    try{
      return await _auth
          .sendPasswordResetEmail(email: email);
    }
    catch(e){
      return null;
    }
  }

  //TODO: Sign in with Google

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
