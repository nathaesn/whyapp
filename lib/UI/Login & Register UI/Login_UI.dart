import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/Login%20&%20Register%20UI/Register_UI.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_UI.dart';

import '../../firebase/authController.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  //GLOBAL KEY
  final _formKey = GlobalKey<FormState>();

  //CONTROLLER
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  //BOOLEAN
  bool ishide = true;

  //Start
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      body: SafeArea(
          child: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat Datang!",
                  style: TextStyle(
                      color: accentcolor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "Masukkan akun anda untuk masuk",
                    style: TextStyle(
                        color: greycolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                input(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Lupa Password?",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ))
                  ],
                ),
                SizedBox(
                  height: 140,
                ),
                Container(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          AuthenticationHelper()
                              .signIn(email: email_controller.text, password: password_controller.text)
                              .then((ok) {
                            if (ok == null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreenUI()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  ok,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ));
                            }
                          });
                        }
                      },
                      // ignore: sort_child_properties_last
                      child: Text(
                        "Masuk",
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Container(
                          width: 80,
                          color: greycolor,
                          height: 1,
                        ),
                        Text(
                          " Masuk Dengan ",
                          style: TextStyle(color: greycolor),
                        ),
                        Container(
                          width: 80,
                          color: greycolor,
                          height: 1,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    
                      onPressed: () {},
                      // ignore: sort_child_properties_last
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "Assets/Svg/icons-google.svg",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Text(
                            "Google",
                            style: TextStyle(
                                color: surfacecolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                        primary: primarycolor,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterUI(),
                              ));
                        },
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget input() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(77, 0, 0, 0),
                  blurRadius: 10,
                  offset: Offset(-5, 5),
                ),
              ], color: inputtxtbg, borderRadius: BorderRadius.circular(50)),
              child: TextFormField(
                controller: email_controller,
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val!.isEmpty ? 'Mohon Masukkan Email Anda!' : null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.transparent),
                style: TextStyle(color: surfacecolor),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(77, 0, 0, 0),
                  blurRadius: 10,
                  offset: Offset(-5, 5),
                ),
              ], color: inputtxtbg, borderRadius: BorderRadius.circular(50)),
              child: TextFormField(
                controller: password_controller,
                obscureText: ishide ? true : false,
                validator: (val) =>
                    val!.isEmpty ? 'Mohon Masukkan Password Anda!' : null,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ishide = !ishide;
                          });
                        },
                        icon: Icon(
                          ishide
                              ? Icons.visibility
                              : Icons.visibility_off_rounded,
                          color: surfacecolor,
                        )),
                    border: InputBorder.none,
                    filled: true,
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.transparent),
                style: TextStyle(color: surfacecolor),
              ),
            ),
          ],
        ));
  }
}
