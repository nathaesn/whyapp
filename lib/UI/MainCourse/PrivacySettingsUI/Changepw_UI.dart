import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_UI.dart';
import 'package:whyapp/firebase/authController.dart';

class ChangePwUI extends StatefulWidget {
  const ChangePwUI({Key? key}) : super(key: key);

  @override
  State<ChangePwUI> createState() => _ChangePwUIState();
}

class _ChangePwUIState extends State<ChangePwUI> {
  //Form
  final _formKey = GlobalKey<FormState>();

  //Boolean
  bool issucces = false;

  TextEditingController pwold = TextEditingController();
  TextEditingController pwNew = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Privasi",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sandi lama"),
              SizedBox(
                height: 5,
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
                  controller: pwold,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      val!.isEmpty ? 'Mohon Masukkan Sandi Lama Anda!' : null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Massukan Sandi Lama",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.transparent),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Sandi baru"),
              SizedBox(
                height: 5,
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
                  controller: pwNew,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      val!.isEmpty ? 'Mohon Masukkan Sandi Baru Anda!' : null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Massukan Sandi Baru",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.transparent),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (
                            context,
                          ) {
                            return CupertinoAlertDialog(
                              title: Text("Lupa Password"),
                              content: Column(
                                children: [
                                  SizedBox(
                                      height: 120,
                                      child: Lottie.asset(
                                        'Assets/Animation/verify-animation.json',
                                        repeat: false,
                                      )),
                                  Text(
                                    "Kirim verifikasi reset password ke email anda",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
                                      Navigator.pop(context);
                                      AuthenticationHelper()
                                          .forgotPassword(context);

                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          content: Column(
                                            children: [
                                              SizedBox(
                                                  height: 120,
                                                  child: Lottie.asset(
                                                      repeat: false,
                                                      'Assets/Animation/success-animation.json')),
                                              Text(
                                                "Verifikasi ganti password telah berhasil dikirim, silahkan cek email anda",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Oke"))
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text("Ya"))
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Forgot Password?"))
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 203,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    content: Column(
                                      children: [
                                        SizedBox(
                                            height: 120,
                                            child: Lottie.asset(
                                                'Assets/Animation/password-animation.json')),
                                        Text(
                                          "Yakin ingin mengganti sandi anda?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
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
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CupertinoActivityIndicator(),
                                            );
                                            AuthenticationHelper()
                                                .changePassword(pwold.text,
                                                    pwNew.text, context)
                                                .then((value) {
                                              if (value == true) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreenUI(),
                                                    ),
                                                    (route) => false);
                                              } else {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                final snackBar = SnackBar(
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title:
                                                        'Gagal Merubah Password',
                                                    message:
                                                        "Sandi lama yang anda masukkan tidak sesuai",
                                                    contentType:
                                                        ContentType.failure,
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(snackBar);
                                              }
                                            });
                                          },
                                          child: Text("Ya"))
                                    ],
                                  );
                                },
                              );
                            } else {}
                          },
                          child: Text(
                            "Simpan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
