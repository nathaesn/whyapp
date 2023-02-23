import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  void postStatus({
    required String content,
    required String imgURL,
    required String timestampt,
  }) async {
    var documentReference =
        await FirebaseFirestore.instance.collection('status').doc(timestampt);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'email': auth.currentUser!.email,
          'datetime': DateTime.now().toString(),
          'timestampt': timestampt,
          'image': "",
          'content': "",
        },
      );
    });
  }

  void deleteStatus() {}
  // void updateStatus() {}

  void postcomment() {}
  void deleteComment() {}
}
