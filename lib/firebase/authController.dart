import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Register
  Future editusername({required String name}) async {
    await user!.updateDisplayName(name);
  }

  //Register
  Future<String?> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final Userdata = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Userdata.user!.updateDisplayName(name);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

//Google Sign In
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Logout
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //VerifyEmail
  Future sendverify() async {
    await user?.sendEmailVerification();
  }

  Future inputDataUser() async {
    // users.add({});
    CollectionReference users = await firestore.collection('user');
    await users.doc(auth.currentUser!.email).set({
      "username": auth.currentUser!.displayName,
      "uid": auth.currentUser!.uid,
      "email": auth.currentUser!.email,
      "image": auth.currentUser!.photoURL,
      "status": "",
    });
  }
}


///https://firebase.flutter.dev/docs/firestore/usage/
