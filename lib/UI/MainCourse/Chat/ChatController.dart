import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MessageHelper {
  void deleteMessage({required String chatId, required String dateId}) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .doc(dateId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.delete(documentReference);
    }).then((value) {
      return "ya kh dek";
    }).catchError((e) {
      print(e);
    });
  }
}

class replyController extends GetxController {
  var getMessageReply = "yay";

  void replyMessage({required String Message}) {
    // getMessageReply.value = Message;
  }
}
