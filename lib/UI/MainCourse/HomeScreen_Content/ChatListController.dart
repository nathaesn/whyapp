import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/ChatListModel.dart';

class ChatListController extends GetxController {
  var isLoading = false;
  var chaList = <chatListModel>[];
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> getData() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('user')
          .doc(auth.currentUser!.email)
          .collection('chatList')
          .orderBy('lastChatTime', descending: true)
          .get();
      chaList.clear();
      for (var chat in query.docs) {
        chaList.add(chatListModel(
            "Username",
            chat['email'],
            "https://rugby.vlaanderen/wp-content/uploads/2018/03/Anonymous-Profile-pic.jpg",
            chat['lastContent'],
            chat["lastChatTime"]));
      }
      isLoading = false;
    } catch (e) {
      // Get.snackbar('Error', '${e.toString()}');
    }
  }
}
