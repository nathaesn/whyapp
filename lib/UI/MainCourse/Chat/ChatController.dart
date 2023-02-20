import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whyapp/NotificationController.dart';

class MessageHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;
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

  void onConnection(
      {required String chatID,
      required String message,
      required String uidSecondUsers,
      required String emailSecondUsers}) async {
    var a = await FirebaseFirestore.instance
        .collection('user')
        .doc(auth.currentUser!.email)
        .collection('chatList')
        .doc(chatID)
        .get();
    if (a.exists) {
      var documentReferenceConnection = FirebaseFirestore.instance
          .collection('user')
          .doc(auth.currentUser!.email)
          .collection('chatList')
          .doc(chatID);
      var documentReferenceConnectionSecondUsers = FirebaseFirestore.instance
          .collection('user')
          .doc(emailSecondUsers)
          .collection('chatList')
          .doc(chatID);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.update(
          documentReferenceConnection,
          {
            'idSecondUser': uidSecondUsers,
            'email': emailSecondUsers,
            'lastChatTime': DateTime.now().toString(),
            'lastContent': message,
            'image': "",
          },
        );
        FirebaseFirestore.instance.runTransaction((transaction) async {
          await transaction.update(
            documentReferenceConnectionSecondUsers,
            {
              'idSecondUser': auth.currentUser!.uid,
              'email': auth.currentUser!.email,
              'lastChatTime': DateTime.now().toString(),
              'lastContent': message,
              'image': "",
            },
          );
        });

        onSendMessage(
            chatID: chatID,
            message: message,
            uidSecondUsers: uidSecondUsers,
            emailSecondUsers: emailSecondUsers);

        // if (sendmessage != null) {
        //   message.clear();
        //   scrollDown();
        // }
      });
    }
    if (!a.exists) {
      var documentReferenceConnection = FirebaseFirestore.instance
          .collection('user')
          .doc(auth.currentUser!.email)
          .collection('chatList')
          .doc(chatID);
      var documentReferenceConnectionSecondUsers = FirebaseFirestore.instance
          .collection('user')
          .doc(emailSecondUsers)
          .collection('chatList')
          .doc(chatID);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReferenceConnection,
          {
            'idSecondUser': uidSecondUsers,
            'email': emailSecondUsers,
            'lastChatTime': DateTime.now().toString(),
            'lastContent': message,
            'image': "",
          },
        );
      });
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReferenceConnectionSecondUsers,
          {
            'idSecondUser': auth.currentUser!.uid,
            'email': auth.currentUser!.email,
            'lastChatTime': DateTime.now().toString(),
            'lastContent': message,
            'image': "",
          },
        );
      });

      onSendMessage(
          chatID: chatID,
          message: message,
          uidSecondUsers: uidSecondUsers,
          emailSecondUsers: emailSecondUsers);

      // if (sendmessage != null) {
      //   message.clear();
      //   scrollDown();
      // }
    }
  }

  void onSendMessage(
      {required String chatID,
      required String message,
      required String uidSecondUsers,
      required String emailSecondUsers}) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatID.toString())
        .collection(chatID.toString())
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final sendMessage = await transaction.set(
        documentReference,
        {
          'idFirstUser': auth.currentUser!.uid,
          'idSecondUser': uidSecondUsers,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'date': DateTime.now().toString(),
          'content': message,
          'image': "",
        },
      );

      if (sendMessage != null) {
        pushNotificationMessage(
            deviceTo: "deviceTo",
            content: message,
            title: "Message From " + auth.currentUser!.displayName.toString());
      }
    });
  }
}

class replyController extends GetxController {
  var getMessageReply = "yay";

  void replyMessage({required String Message}) {
    // getMessageReply.value = Message;
  }
}
