import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:whyapp/UI/MainCourse/Status/StatusModel.dart';

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
          'image': imgURL != "" ? imgURL : "",
          'content': content != "" ? content : "",
        },
      );
    });
  }

  void deleteStatus(chatId, context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoActivityIndicator(),
            Text("Update profile sedang diproses...")
          ],
        ),
      ),
    );

    var documentReference =
        FirebaseFirestore.instance.collection('status').doc(chatId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.delete(documentReference);
    }).then((value) {
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      print(e);
    });
  }
  // void updateStatus() {}

  void postcomment({
    required String comment,
    required String timestampt,
    required String contentID,
  }) async {
    var documentReference = await FirebaseFirestore.instance
        .collection('status')
        .doc(contentID)
        .collection("comment")
        .doc(timestampt);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'email': auth.currentUser!.email,
          'datetime': DateTime.now().toString(),
          'timestampt': timestampt,
          'comment': comment
        },
      );
    });
  }

  void deleteComment() {}
}

class StatusGet extends GetxController {
  var isLoading = false;
  var statusList = <StatusModels>[];

  Future<void> getStatus() async {
    try {
      QuerySnapshot statuses = await FirebaseFirestore.instance
          .collection('status')
          .orderBy('timestampt')
          .get();
      statusList.clear();
      for (var status in statuses.docs) {
        statusList.add(StatusModels(status['email'], status['content'],
            status['image'], status['datetime'], status.id));
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      Get.snackbar('Error', '${e.toString()}');
    }
  }
}
