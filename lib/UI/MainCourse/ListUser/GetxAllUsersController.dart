import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:whyapp/UI/MainCourse/ListUser/UsersListModels.dart';

class UserAllController extends GetxController {
  var isLoading = true;
  var userList = <allUserModels>[];

  Future<void> getData() async {
    try {
      QuerySnapshot users = await FirebaseFirestore.instance
          .collection('user')
          .orderBy('username')
          .get();
      userList.clear();
      for (var user in users.docs) {
        userList.add(allUserModels(
            user['username'], user['email'], user['image'], user['status']));
      }
      isLoading = false;
    } catch (e) {
      // Get.snackbar('Error', '${e.toString()}');
    }
  }
}
