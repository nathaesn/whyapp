import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:whyapp/Fromated/timeFormated.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/Chat/ImageEditor.dart';

class ChatUI extends StatefulWidget {
  ChatUI({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  //Variable
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var uidseconduser;
  var username;
  var status;
  bool isload = true;

  String? chatId;

  //GetUser
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Scroll to end
  ScrollController _controllerscroll = ScrollController();

  void scrollDown() {
    _controllerscroll.animateTo(
      _controllerscroll.position.minScrollExtent,
      duration: Duration(seconds: 5),
      curve: Curves.fastOutSlowIn,
    );
  }

  //GetSecondUser
  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(widget.email)
        .snapshots()
        .listen((event) {
      setState(() {
        uidseconduser = event.get("uid");
        username = event.get("username");

        if (auth.currentUser!.uid.toString().compareTo(uidseconduser) > 0) {
          chatId = auth.currentUser!.uid.toString() + uidseconduser;
        } else {
          chatId = uidseconduser + auth.currentUser!.uid.toString();
        }

        isload = false;
      });
    });
  }

  //PickImage

  File? imageFile;

  final picker = ImagePicker();

  void imageAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageActionUI(
            imageFile: imageFile,
            chatId: chatId,
            idUser: auth.currentUser!.uid,
            uidseconduser: uidseconduser,
          ),
        ));
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

  //Message Send
  void onSendMessage() {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId.toString())
        .collection(chatId.toString())
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final sendmessage = await transaction.set(
        documentReference,
        {
          'idFirstUser': auth.currentUser!.uid,
          'idSecondUser': uidseconduser,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'date': DateTime.now().toString(),
          'content': message.text,
          'image': "",
        },
      );

      if (sendmessage != null) {
        message.clear();
        scrollDown();
      }
    });
  }

  //ScrollAction
  bool hidedate = false;
  void _scrollListener() {
    if (_controllerscroll.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (hidedate != false)
        setState(() {
          hidedate = false;
        });
    }
    if (_controllerscroll.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (hidedate == false)
        setState(() {
          hidedate = true;
        });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
    _controllerscroll = ScrollController()..addListener(_scrollListener);
  }

  // dispose() {
  //   _controllerscroll.removeListener(_scrollListener);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F3F3),
      floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Color(0xffFFEAEA),
              borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: message,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  isDense: true,
                  hintText: "Pesan...",
                  prefixIcon: InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Icon(
                      Icons.image,
                      size: 20,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (message.text != "") {
                          onSendMessage();
                        }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        titleSpacing: -15,
        title: ListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d2cd2085-496f-407f-b79b-7b436edd816a/df8u4a7-1a6eafb7-4bc4-4a4e-a7f8-f65a3f38a20f.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2QyY2QyMDg1LTQ5NmYtNDA3Zi1iNzliLTdiNDM2ZWRkODE2YVwvZGY4dTRhNy0xYTZlYWZiNy00YmM0LTRhNGUtYTdmOC1mNjVhM2YzOGEyMGYuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.fpKCkMz_jDn4GGV0F0KmS2fsEufaPLV8YJQjQ_xTEsc",
                height: 40,
                width: 40,
              ),
            ),
          ),
          title: Text(
            username.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            widget.email.toString(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(chatId.toString())
            .collection(chatId.toString())
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.09),
              child: GroupedListView<dynamic, String>(
                controller: _controllerscroll,
                shrinkWrap: true,
                floatingHeader: true,
                reverse: true,
                elements: snapshot.data!.docs,
                order: GroupedListOrder.DESC,
                groupBy: (element) => formatTglIndo(date: element['date']),
                useStickyGroupSeparators: hidedate,
                groupSeparatorBuilder: (String value) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 247, 109, 107)),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.3,
                      vertical: 10),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                itemBuilder: (context, elemnt) {
                  return WidgetChatList(snapsot: elemnt);
                },
              ),
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  WidgetChatList({required dynamic snapsot}) {
    return snapsot.get('idSecondUser') != uidseconduser
        ? Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d2cd2085-496f-407f-b79b-7b436edd816a/df8u4a7-1a6eafb7-4bc4-4a4e-a7f8-f65a3f38a20f.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2QyY2QyMDg1LTQ5NmYtNDA3Zi1iNzliLTdiNDM2ZWRkODE2YVwvZGY4dTRhNy0xYTZlYWZiNy00YmM0LTRhNGUtYTdmOC1mNjVhM2YzOGEyMGYuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.fpKCkMz_jDn4GGV0F0KmS2fsEufaPLV8YJQjQ_xTEsc",
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Color(0xffFFFFFF),
                    ),
                    padding: EdgeInsets.all(13),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65),
                    child: Visibility(
                      visible: snapsot.get('image') != "",
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // snapsot['content'],
                            snapsot.get('content'),
                          ),
                          Text(
                            timeFormated(date: snapsot.get('date')),
                            style: TextStyle(color: greycolor, fontSize: 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapsot.get('image'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Visibility(
                              visible: snapsot.get('content') != "",
                              child: Text(
                                snapsot.get('content'),
                              )),
                          Text(
                            timeFormated(date: snapsot.get('date')),
                            style: TextStyle(color: greycolor, fontSize: 10),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Color(0xffFFFFFF),
                    ),
                    padding: EdgeInsets.all(13),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65),
                    child: Visibility(
                      visible: snapsot.get('image') != "",
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapsot.get('content'),
                          ),
                          Text(
                            timeFormated(date: snapsot.get('date')),
                            style: TextStyle(color: greycolor, fontSize: 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapsot.get('image'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Visibility(
                              visible: snapsot.get('content') != "",
                              child: Text(
                                snapsot.get('content'),
                              )),
                          Text(
                            timeFormated(date: snapsot.get('date')),
                            style: TextStyle(color: greycolor, fontSize: 10),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d2cd2085-496f-407f-b79b-7b436edd816a/df8u4a7-1a6eafb7-4bc4-4a4e-a7f8-f65a3f38a20f.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2QyY2QyMDg1LTQ5NmYtNDA3Zi1iNzliLTdiNDM2ZWRkODE2YVwvZGY4dTRhNy0xYTZlYWZiNy00YmM0LTRhNGUtYTdmOC1mNjVhM2YzOGEyMGYuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.fpKCkMz_jDn4GGV0F0KmS2fsEufaPLV8YJQjQ_xTEsc",
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

String formatTglIndo({required String date}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

  var m = DateFormat('MM').format(dateTime);
  var d = DateFormat('dd').format(dateTime).toString();
  var Y = DateFormat('yyyy').format(dateTime).toString();
  var month = "";
  switch (m) {
    case '01':
      {
        month = "Januari";
      }
      break;
    case '02':
      {
        month = "Februari";
      }
      break;
    case '03':
      {
        month = "Maret";
      }
      break;
    case '04':
      {
        month = "April";
      }
      break;
    case '05':
      {
        month = "Mei";
      }
      break;
    case '06':
      {
        month = "Juni";
      }
      break;
    case '07':
      {
        month = "Juli";
      }
      break;
    case '08':
      {
        month = "Agustus";
      }
      break;
    case '09':
      {
        month = "September";
      }
      break;
    case '10':
      {
        month = "Oktober";
      }
      break;
    case '11':
      {
        month = "November";
      }
      break;
    case '12':
      {
        month = "Desember";
      }
      break;
  }
  return "$d $month $Y";
}
