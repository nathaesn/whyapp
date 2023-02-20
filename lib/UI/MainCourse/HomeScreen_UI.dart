import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whyapp/NotificationController.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatUi.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/ChatList_UI.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/Profile-UI.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/StatusList-UI.dart';

class HomeScreenUI extends StatefulWidget {
  HomeScreenUI({Key? key}) : super(key: key);

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI>
    with TickerProviderStateMixin {
  //CONTROLLER
  late TabController _tabController;

  void getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

//START
  @override
  void initState() {
    getDeviceTokenToSendNotification();
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          print("WOII ANJRRR " + message.data['email']);
          if (message.data['email'] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatUI(
                  email: message.data['email'],
                ),
              ),
            );
          }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          print(message.data["email"]);
          NotificationController.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {
          // print("yo : " + message.data["_id"]);
          // print(message.notification!.title);
          // print(message.notification!.body);
          // print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  String? deviceTokenToSendPushNotification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text(
            "WhyApp",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  pushNotificationMessage(
                      deviceTo: "deviceTo", content: "content", title: "title");
                },
                icon: Icon(Icons.search))
          ],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: TabBar(
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: secondarycolorhigh,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 13),
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Container(
                      height: 30.0,
                      child: Tab(text: 'Chat'),
                    ),
                    Container(
                      height: 30.0,
                      child: Tab(text: 'Status'),
                    ),
                    Container(
                      height: 30.0,
                      child: Tab(text: 'Profile'),
                    ),
                  ],
                ),
              ),
            ),
          )),
      body: TabBarView(
        controller: _tabController,
        children: [ChatList(), StatusUI(), ProfileUI()],
      ),
    );
  }
}
