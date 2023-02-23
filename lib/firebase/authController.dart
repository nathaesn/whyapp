import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  //Register
  Future updateUser(
      {required String name,
      required String status,
      required String imgUrl}) async {
    user.updateProfile(displayName: name, photoURL: imgUrl).then((value) {
      updateUserInfo(status: status);
    }).catchError((e) {
      print("There was an error updating profile");
    });
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
      if (_auth.currentUser!.emailVerified == true) {
        setTokenDevice();
      }

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
    CollectionReference users = await firestore.collection('user');
    await users.doc(auth.currentUser!.email).update({
      "tokenDevice": "",
    });
    await FirebaseAuth.instance.signOut();
  }

  //VerifyEmail
  Future sendverify() async {
    await user?.sendEmailVerification();
  }

  Future inputDataUser() async {
    final token = await _fcm.getToken();

    // users.add({});
    CollectionReference users = await firestore.collection('user');
    await users.doc(auth.currentUser!.email).set({
      "username": auth.currentUser!.displayName,
      "uid": auth.currentUser!.uid,
      "email": auth.currentUser!.email,
      "image": auth.currentUser!.photoURL,
      "status": "halo, salam kenal😊",
      "tokenDevice": token,
    });
  }

  Future updateUserInfo({required String status}) async {
    // users.add({});
    CollectionReference users = await firestore.collection('user');
    await users.doc(auth.currentUser!.email).update({
      "username": auth.currentUser!.displayName,
      "image": auth.currentUser!.photoURL,
      "status": status,
    });
  }

  Future setProfile() async {
    // users.add({});
    CollectionReference users = await firestore.collection('user');
    await users.doc(auth.currentUser!.email).update({
      "username": auth.currentUser!.displayName,
      "image": auth.currentUser!.photoURL,
    });
  }

  void setTokenDevice() async {
    final token = await _fcm.getToken();

    CollectionReference users = await firestore.collection('user');
    await users.doc(auth.currentUser!.email).update({
      "tokenDevice": token,
    });
  }
}
///https://firebase.flutter.dev/docs/firestore/usage/
