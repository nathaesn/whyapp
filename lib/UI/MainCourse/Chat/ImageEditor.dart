import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatController.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ImageActionUI extends StatefulWidget {
  ImageActionUI(
      {Key? key,
      required this.imageFile,
      required this.chatId,
      required this.idUser,
      required this.tokenDevice,
      required this.emailSecondUser,
      required this.uidseconduser})
      : super(key: key);
  File? imageFile;
  String? chatId;
  String? uidseconduser;
  String? idUser;
  String? tokenDevice;
  String? emailSecondUser;

  @override
  State<ImageActionUI> createState() => _ImageActionUIState();
}

class _ImageActionUIState extends State<ImageActionUI> {
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _firebaseStorage = FirebaseStorage.instance;

  void sendMessage() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CupertinoActivityIndicator(),
            Text("Sedang melakukan upload foto...")
          ],
        ),
      ),
    );
    var imagesPath = File(widget.imageFile!.path);
    var snapshot = await _firebaseStorage
        .ref()
        .child('images/chat/' +
            widget.chatId.toString() +
            "/" +
            DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imagesPath);
    var downloadUrl = await snapshot.ref.getDownloadURL();

    final sendmessage = MessageHelper().onConnection(
        chatID: widget.chatId.toString(),
        image: downloadUrl,
        message: message.text,
        tokenDevice: widget.tokenDevice.toString(),
        uidSecondUsers: widget.uidseconduser.toString(),
        emailSecondUsers: widget.emailSecondUser.toString());

    message.clear();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: InkWell(
                onTap: () {
                  widget.imageFile = null;
                  // if (imageFile != null) {
                  //   print("ssdh : " + imageFile.toString());
                  // }
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ))),
        floatingActionButton: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 72, 72, 72),
                borderRadius: BorderRadius.circular(30)),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: message,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    isDense: true,
                    hintText: "Caption...",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          sendMessage();
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xffFFA8A7)),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          )),
                    )),
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Zoom(
                initTotalZoomOut: true,
                canvasColor: Colors.black,
                enableScroll: false,
                maxZoomWidth: MediaQuery.of(context).size.width,
                maxZoomHeight: MediaQuery.of(context).size.width,
                child: Image.file(widget.imageFile ?? File(''))),
          ),
        ));
  }
}
