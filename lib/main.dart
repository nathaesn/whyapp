import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whyapp/NotificationController.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/Login%20&%20Register%20UI/Emailverify.dart';
import 'package:whyapp/UI/Login%20&%20Register%20UI/Login_UI.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_UI.dart';
import 'package:whyapp/firebase/authController.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  NotificationController.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool islogin = false;
  bool isverify = false;

  void login() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          islogin = false;
        });
      } else {
        setState(() {
          islogin = true;
          if (user.emailVerified == true) {
            isverify = true;
          } else {
            isverify = false;
          }
        });
      }
    });
  }

  @override
  void initState() {
    login();
    AuthenticationHelper().setProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: themecolor,
      ),
      home: islogin
          ? isverify
              ? HomeScreenUI()
              : VerifyEmailUI()
          : LoginUI(),
    );
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}
