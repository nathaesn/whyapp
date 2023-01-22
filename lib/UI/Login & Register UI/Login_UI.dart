import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
  bool isload = true;

  //Start
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
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
            Spacer(),
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
            Spacer(
              flex: 3,
            ),
            Container(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenUI()));
                    if (_formKey.currentState!.validate()) {
                      showCupertinoDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.black.withOpacity(0.8),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10.0, sigmaY: 10.0),
                                          child: Container(
                                              padding: EdgeInsets.all(20),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      223, 255, 255, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 140,
                                                    child: Lottie.asset(
                                                        'Assets/Animation/login-anim.json'),
                                                  ),
                                                  Text(
                                                    "Sedang mendapatkan info login...",
                                                    style: GoogleFonts.poppins(
                                                        color: greycolor,
                                                        fontSize: 12,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  )
                                                ],
                                              ),
                                              width: double.infinity,
                                              height: 215),
                                        ),
                                        padding: EdgeInsets.only(bottom: 16)),
                                  ]));
                        },
                      );
                      _formKey.currentState!.save();

                      AuthenticationHelper()
                          .signIn(
                              email: email_controller.text,
                              password: password_controller.text)
                          .then((ok) {
                        if (ok == null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreenUI()));
                        } else {
                          Navigator.pop(context);
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("Login Gagal"),
                                content: Text(
                                    "Mohon maaf sedang terjadi kesalahan sistem, mohon coba kembali"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OKE"))
                                ],
                              );
                            },
                          );
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
                  Text(
                    " Masuk Dengan ",
                    style: TextStyle(color: greycolor),
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
                    )),
              ],
            ),
          ],
        ),
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
              ),
            ),
          ],
        ));
  }
}
