import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_UI.dart';
import 'package:whyapp/UI/MainCourse/Status/StatusController.dart';

class AddStatusUI extends StatefulWidget {
  const AddStatusUI({super.key});

  @override
  State<AddStatusUI> createState() => _AddStatusUIState();
}

class _AddStatusUIState extends State<AddStatusUI> {
  TextEditingController status = TextEditingController();
  final _firebaseStorage = FirebaseStorage.instance;

  File? imageFile;

  final picker = ImagePicker();

  void imageAction() async {
    Navigator.pop(context);
  }

  void uploadStatus() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoActivityIndicator(),
            Text("Sedang melakukan upload status...")
          ],
        ),
      ),
    );

    StatusController().postStatus(
        content: status.text,
        imgURL: "",
        timestampt: DateTime.now().millisecondsSinceEpoch.toString());

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreenUI(),
        ),
        (route) => false);
  }

  void uploadStatusWithImg() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoActivityIndicator(),
            Text("Sedang melakukan upload status...")
          ],
        ),
      ),
    );
    var imagesPath = File(imageFile!.path);

    var snapshot = await _firebaseStorage
        .ref()
        .child(
            'images/status/' + DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imagesPath);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    StatusController().postStatus(
        content: status.text,
        imgURL: downloadUrl,
        timestampt: DateTime.now().millisecondsSinceEpoch.toString());

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreenUI(),
        ),
        (route) => false);
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Tambah Status"),
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    pickImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: greycolor,
                        borderRadius: BorderRadius.circular(20)),
                    height: 210,
                    width: MediaQuery.of(context).size.width >= 700
                        ? 450
                        : MediaQuery.of(context).size.width,
                    child: imageFile == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SvgPicture.asset(
                              "Assets/Svg/Assetpostimg.svg",
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              imageFile ?? File(""),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Text("*Opsional, bisa menambahkan atau tidak"),
                SizedBox(
                  height: 10,
                ),
                Text("Status anda"),
                Container(
                  width: MediaQuery.of(context).size.width >= 700
                      ? 450
                      : MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(77, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(-5, 5),
                        ),
                      ],
                      color: inputtxtbg,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: status,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.transparent),
                  ),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              height: 50,
              width: 203,
              child: ElevatedButton(
                  onPressed: () {
                    if (imageFile == null) {
                      uploadStatus();
                    } else {
                      uploadStatusWithImg();
                    }
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
            Spacer()
          ],
        ),
      ),
    );
  }
}
