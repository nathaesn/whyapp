import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/Login%20&%20Register%20UI/Login_UI.dart';
import 'package:whyapp/UI/MainCourse/BantuanUI/Bantuan_UI.dart';
import 'package:whyapp/UI/MainCourse/PrivacySettingsUI/Changepw_UI.dart';
import 'package:whyapp/UI/MainCourse/ProfileUI/EditProfile.dart';
import 'package:whyapp/firebase/authController.dart';

class ProfileUI extends StatefulWidget {
  ProfileUI({Key? key}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: greycolor,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          "email@gmail.com",
                          style: TextStyle(
                              color: greycolor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: OutlinedButton(
                            onPressed: () async {
                              final reLoadPage = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileUI(),
                                  ));
                              if (!mounted) return;
                              setState(() {
                                //onfresh
                              });
                            },
                            child: Text(
                              "Edit profile",
                              style:
                                  TextStyle(color: accentcolor, fontSize: 10),
                            ),
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                primary:
                                    Theme.of(context).scaffoldBackgroundColor,
                                elevation: 0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 3,
            color: greycolor,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                ListTile(
                  onTap: () async {
                    final reLoadPage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePwUI(),
                        ));
                    if (!mounted) return;
                    setState(() {
                      //onfresh
                    });
                  },
                  leading: Container(
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        size: 18,
                        color: Color(0xffEBB376),
                      ),
                    ),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xffFFE2C2)),
                  ),
                  title: Text(
                    "Ganti Sandi",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final reLoadPage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BantuanUI(),
                        ));
                    if (!mounted) return;
                    setState(() {
                      //onfresh
                    });
                  },
                  leading: Container(
                    child: Center(
                      child: Icon(
                        Icons.question_mark_rounded,
                        size: 18,
                        color: Color(0xff69CC51),
                      ),
                    ),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xffCAFFC5)),
                  ),
                  title: Text(
                    "Bantuan",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 3,
            color: greycolor,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("Peringatan Logout"),
                      content: Column(
                        children: [
                          SizedBox(
                              height: 120,
                              child: Lottie.asset(
                                  'Assets/Animation/logout-anim.json')),
                          Text(
                            "Apakah kamu yakin untuk logout?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Tidak")),
                        TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginUI(),), (route) => false);
                            }, 
                            child: Text("Ya")),
                      ],
                    );
                  },
                );
              },
              leading: Container(
                child: Center(
                  child: Icon(
                    Icons.logout,
                    size: 18,
                    color: Color.fromARGB(255, 255, 0, 0),
                  ),
                ),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(60, 255, 0, 0)),
              ),
              title: Text("Keluar",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 0, 0),
                      fontWeight: FontWeight.w700)),
            ),
          )
        ],
      ),
    );
  }
}
