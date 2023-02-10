import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/Login%20&%20Register%20UI/Login_UI.dart';
import 'package:whyapp/firebase/authController.dart';

class VerifyEmailUI extends StatefulWidget {
  VerifyEmailUI({Key? key}) : super(key: key);

  @override
  State<VerifyEmailUI> createState() => _VerifyEmailUIState();
}

class _VerifyEmailUIState extends State<VerifyEmailUI> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Text(
                                  "Perhatian, Apa kamu yakin untuk melakukan logout?",
                                  style: TextStyle(fontSize: 14),
                                ),
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        AuthenticationHelper().signOut();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginUI(),
                                            ),
                                            (route) => false);
                                      },
                                      child: Text(
                                        "Ya",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Tidak",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)))
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.logout_rounded)),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                height: 180,
                child: Lottie.asset('Assets/Animation/login-anim.json'),
              ),
              Container(
                width: 250,
                child: Text(
                  "Mohon verifikasi email anda terlebih dahulu",
                  style: TextStyle(color: greycolor, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              SizedBox(
                height: 54,
                width: 315,
                child: ElevatedButton(
                    onPressed: () {
                      AuthenticationHelper().sendverify();
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            content: Text("Email verifikasi telah dikirim ke " +
                                auth.currentUser!.email.toString() +
                                " silahkan verifikasi email anda digmail anda, lalu klik lanjutkan"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    AuthenticationHelper().sendverify();
                                  },
                                  child: Text("Kirim ulang")),
                              TextButton(
                                  onPressed: () {}, child: Text("Lanjutkan")),
                            ],
                          );
                        },
                      );
                    },
                    // ignore: sort_child_properties_last
                    child: Text(
                      "Verifikasi Email",
                      style: TextStyle(
                          color: primarycolor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      primary: secondarycolor,
                    )),
              ),
              Spacer()
            ],
          ),
        ],
      )),
    );
  }
}
