import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatUi.dart';
import 'package:whyapp/UI/MainCourse/ListUser/GetxAllUsersController.dart';

class ListUserUI extends StatelessWidget {
  ListUserUI({Key? key}) : super(key: key);

  // CollectionReference _collectionRef =
  UserAllController userGet = Get.put(UserAllController());
  var username;

  bool isload = true;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: GetBuilder<UserAllController>(
          init: UserAllController(),
          initState: (state) {},
          builder: (controller) {
            controller.getData();
            return controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: controller.userList.length,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible:
                            controller.userList[index].username != username,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatUI(
                                    email: controller.userList[index].email,
                                  ),
                                ));
                          },
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Hero(
                              tag: 'photo-profile-chat',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: controller.userList[index].imgProfile ==
                                        null
                                    ? SvgPicture.asset(
                                        "Assets/Svg/DefaultImg.svg",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        controller.userList[index].imgProfile,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          subtitle: Text(controller.userList[index].status),
                          title: Text(
                            controller.userList[index].username,
                          ),
                        ),
                      );
                    },
                  );
          },
        ));
  }
}
