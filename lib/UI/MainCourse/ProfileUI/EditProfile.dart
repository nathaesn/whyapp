import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
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

  String? imgUrl;

  //Controller
  TextEditingController name = TextEditingController();
  TextEditingController status = TextEditingController();
  final _firebaseStorage = FirebaseStorage.instance;

  //GetSecondUser
  Future<void> getUser() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(auth.currentUser!.email)
        .snapshots()
        .listen((event) {
      setState(() {
        name.text = event.get("username");
        status.text = event.get("status");
        imgUrl = event.get("image");
      });
    });
  }

  void putData() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoActivityIndicator(),
            Text("Update profile sedang diproses...")
          ],
        ),
      ),
    );
    if (imageFile != null) {
      var imagesPath = File(imageFile!.path);
      var snapshot = await _firebaseStorage
          .ref()
          .child('images/profile/' + auth.currentUser!.email.toString())
          .putFile(imagesPath);
      imgUrl = await snapshot.ref.getDownloadURL();
    }

    AuthenticationHelper().updateUser(
        name: name.text, status: status.text, imgUrl: imgUrl.toString());
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreenUI(),
        ),
        (route) => false);
  }

//PickImg

  File? imageFile;

  final picker = ImagePicker();

  void imageAction() async {
    Navigator.pop(context);
  }

  Future pickImage() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () async {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      imageFile = File(pickedFile.path);
                    });
                    imageAction();
                  }
                },
                child: Text(
                  "Gallery",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                )),
            CupertinoActionSheetAction(
                onPressed: () async {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      imageFile = File(pickedFile.path);
                    });
                    imageAction();
                  }
                },
                child: Text("Camera",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getUser();
    print(imgUrl);
    print(imageFile);
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
                  child: Hero(
                    tag: "profile-to-edit",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Stack(
                        children: [
                          Visibility(
                            visible: imageFile != null,
                            replacement: Visibility(
                              visible: imgUrl != null,
                              replacement: SvgPicture.asset(
                                "Assets/Svg/DefaultImg.svg",
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              child: Image.network(
                                imgUrl.toString(),
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Image.file(
                              imageFile ?? File(""),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color.fromARGB(92, 0, 0, 0)),
                            child: Center(
                              child: InkWell(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 50,
                                  )),
                            ),
                          ),
                        ],
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
              child: Column(
                children: [
                  TextFormField(
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
                  TextFormField(
                    controller: status,
                    decoration: InputDecoration(
                      labelText: "Status",
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
                ],
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            height: 50,
            width: 203,
            child: ElevatedButton(
                onPressed: () {
                  putData();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: secondarycolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "Simpan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )),
          ),
          SizedBox(
            height: 70,
          )
        ],
      ),
    );
  }
}
