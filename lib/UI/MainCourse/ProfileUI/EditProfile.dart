import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_UI.dart';
import 'package:whyapp/firebase/authController.dart';

class EditProfileUI extends StatefulWidget {
  EditProfileUI({Key? key}) : super(key: key);

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Controller
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    name.text = auth.currentUser!.displayName.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit profile",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: secondarycolor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 45),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Nama",
                  labelStyle: TextStyle(color: surfacecolor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: surfacecolor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: surfacecolor),
                  ),
                ),
                style: TextStyle(color: surfacecolor),
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            height: 50,
            width: 203,
            child: ElevatedButton(
                onPressed: () {
                  AuthenticationHelper()
                      .editusername(name: name.text)
                      .toString();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreenUI(),
                      ),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: secondarycolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text("Simpan")),
          ),
          SizedBox(
            height: 70,
          )
        ],
      ),
    );
  }
}
