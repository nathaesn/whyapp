import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whyapp/Fromated/timeFormated.dart';
import 'package:whyapp/NotificationController.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/Chat/Call_UI.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatController.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatUi.dart';
import 'package:whyapp/UI/MainCourse/Chat/ImageEditor.dart';
import 'package:whyapp/UI/MainCourse/ListUser/ListUser_UI.dart';
import 'package:whyapp/UI/MainCourse/ProfileUI/ProfileSecondUser.dart';

class TabListChat extends StatefulWidget {
  const TabListChat({super.key});

  @override
  State<TabListChat> createState() => _TabListChatState();
}

class _TabListChatState extends State<TabListChat> {
  double widhtCont = 50;
  CollectionReference? collectionStream;
  CollectionReference? collectionStreamUsers;
  CollectionReference? collectionStreamChatList;

  String email = "";

  final FirebaseAuth auth = FirebaseAuth.instance;

  //HATI HATI
  //Variable
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //For First Users
  var usernameUsers;

  var uidseconduser;
  var username;
  var imgUser;
  var status;
  var Reply;
  var tokenDevice;
  bool isload = true;
  bool isloadUserList = true;

  String? chatId;

  //Scroll to end
  ScrollController _controllerscroll = ScrollController();

  void scrollDown() {
    _controllerscroll.animateTo(
      _controllerscroll.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void getUsers() async {
    collectionStreamUsers = FirebaseFirestore.instance.collection('user');

    setState(() {
      isloadUserList = true;
      isAddWidget = true;
      isloadUserList = true;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isloadUserList = false;
        });
      });
      // isloadUserList = false;
    });
  }

  void getChatList() async {
    collectionStreamChatList = FirebaseFirestore.instance
        .collection('user')
        .doc(auth.currentUser!.email)
        .collection('chatList');

    setState(() {
      isloadUserList = true;
      isAddWidget = false;
      isloadUserList = true;
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isloadUserList = false;
        });
      });
      // isloadUserList = false;
    });
  }

  //GetSecondUser
  Future<void> getDatachat() async {
    setState(() {
      isload = true;
    });

    if (email != "") {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(email)
          .snapshots()
          .listen((event) {
        setState(() {
          uidseconduser = event.get("uid");
          tokenDevice = event.get("tokenDevice");
          username = event.get("username");
          status = event.get("status");
          imgUser = event.get("image");

          if (auth.currentUser!.uid.toString().compareTo(uidseconduser) > 0) {
            chatId = auth.currentUser!.uid.toString() + uidseconduser;
          } else {
            chatId = uidseconduser + auth.currentUser!.uid.toString();
          }

          collectionStream = FirebaseFirestore.instance
              .collection('messages')
              .doc(chatId.toString())
              .collection(chatId.toString());
        });
      });
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isload = false;
      });
    });
  }

  //PickImage

  File? imageFile;

  final picker = ImagePicker();

  void imageAction() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageActionUI(
            tokenDevice: tokenDevice,
            emailSecondUser: email,
            imageFile: imageFile,
            chatId: chatId,
            idUser: auth.currentUser!.uid,
            uidseconduser: uidseconduser,
          ),
        ));
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
    usernameUsers = auth.currentUser!.displayName.toString();
    getChatList();
    getDatachat();
    super.initState();
  }

  bool isAddWidget = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: isAddWidget
                ? Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              getChatList();
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: secondarycolor,
                          )),
                    ),
                    body: isloadUserList
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: collectionStreamUsers!.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return Visibility(
                                      visible: snapshot.data!.docs[index]
                                              .get('username') !=
                                          usernameUsers,
                                      child: ListTile(
                                        onTap: () {
                                          setState(() {
                                            email = snapshot.data!.docs[index]
                                                .get('email');
                                            getDatachat();
                                          });
                                        },
                                        leading: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Hero(
                                            tag: 'photo-profile-chat',
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: snapshot.data!.docs[index]
                                                          .get('image') ==
                                                      null
                                                  ? SvgPicture.asset(
                                                      "Assets/Svg/DefaultImg.svg",
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      snapshot.data!.docs[index]
                                                          .get('image'),
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        subtitle: Text(snapshot
                                            .data!.docs[index]
                                            .get('status')),
                                        title: Text(
                                          snapshot.data!.docs[index]
                                              .get('username'),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else {
                                return const Center(
                                    child: const CircularProgressIndicator());
                              }
                            },
                          ),
                  )
                : Scaffold(
                    floatingActionButton: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      width: widhtCont,
                      child: Container(
                        width: widhtCont,
                        decoration: BoxDecoration(
                            color: secondarycolor,
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: widhtCont == 200
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (widhtCont == 50) {
                                    widhtCont = 170;
                                  } else {
                                    widhtCont = 50;
                                  }
                                });
                              },
                              icon: AnimatedSwitcher(
                                  duration: Duration(seconds: 1),
                                  transitionBuilder: (child, anim) =>
                                      RotationTransition(
                                        turns: child.key == ValueKey('icon1')
                                            ? Tween<double>(begin: 1, end: 0.75)
                                                .animate(anim)
                                            : Tween<double>(begin: 0.75, end: 1)
                                                .animate(anim),
                                        child: FadeTransition(
                                            opacity: anim, child: child),
                                      ),
                                  child: widhtCont == 50
                                      ? Icon(
                                          Icons.add,
                                          key: const ValueKey('icon1'),
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.close,
                                          key: const ValueKey('icon2'),
                                          color: Colors.white,
                                        )),
                            ),
                            AnimatedSize(
                                duration: Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                                child: Visibility(
                                    visible: widhtCont == 170,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            "Add Chat",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  getUsers();
                                                });
                                              },
                                              icon: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    body: isloadUserList
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: collectionStreamChatList!
                                .orderBy('lastChatTime', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Dismissible(
                                            onDismissed: (direction) {
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoAlertDialog(
                                                  title:
                                                      Text("Delete this chat?"),
                                                  content: Text("Hapus "),
                                                ),
                                              );
                                            },
                                            key: Key(
                                                snapshot.data!.docs[index].id),
                                            child: ListTile(
                                              onTap: () {
                                                setState(() {
                                                  email = snapshot
                                                      .data!.docs[index]
                                                      .get('email');
                                                  getDatachat();
                                                });
                                                isload = true;
                                              },
                                              title: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      "Username",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          timeFormated(
                                                              date: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "lastChatTime")),
                                                          style: TextStyle(
                                                              color: greycolor,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot
                                                      .data!.docs[index]
                                                      .get("lastContent")),
                                                  Divider(
                                                    color: greycolor,
                                                  )
                                                ],
                                              ),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  "https://wallpaperaccess.com/full/3791635.jpg",
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else {
                                return Center(
                                    child: const CircularProgressIndicator());
                              }
                            },
                          ),
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                        title: Text(
                          "WhyApp",
                          style: TextStyle(color: secondarycolor),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                        actions: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: secondarycolor,
                              )),
                        ]),
                  ),
          ),

          // --------------------------------------------- Chat UI ------------------------------------------------------- //

          Expanded(
              child: email == ""
                  ? Center(
                      child: Text("Your chat in heree"),
                    )
                  : Scaffold(
                      backgroundColor: Color(0xffF3F3F3),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerDocked,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        actions: [
                          IconButton(
                            onPressed: () {
                              pushNotificationMessage(
                                  deviceTo: tokenDevice,
                                  content: "Voice call from " +
                                      auth.currentUser!.displayName.toString(),
                                  title: "Voice Call");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CallAction(
                                        userImages: auth.currentUser!.photoURL
                                            .toString(),
                                        callId: chatId.toString(),
                                        userId: auth.currentUser!.uid,
                                        username: auth.currentUser!.displayName
                                            .toString()),
                                  ));
                            },
                            icon: Icon(
                              Icons.call,
                              color: Colors.black,
                            ),
                          )
                        ],
                        titleSpacing: -15,
                        title: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => profileUserSecond(),
                                ));
                          },
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Hero(
                              tag: 'photo-profile-chat',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: imgUser == null
                                    ? SvgPicture.asset(
                                        "Assets/Svg/DefaultImg.svg",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        imgUser,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          title: Text(
                            username.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            status.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      body: isload
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: collectionStream!
                                        .orderBy("timestamp")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return GroupedListView<dynamic, String>(
                                          controller: _controllerscroll,
                                          shrinkWrap: true,
                                          floatingHeader: true,
                                          reverse: true,
                                          elements: snapshot.data!.docs,
                                          order: GroupedListOrder.DESC,
                                          groupBy: (element) => formatTglIndo(
                                              date: element['date']),
                                          useStickyGroupSeparators: hidedate,
                                          groupSeparatorBuilder:
                                              (String value) => Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color.fromARGB(
                                                    255, 247, 109, 107)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.2,
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
                                          indexedItemBuilder:
                                              (context, elemnt, idx) {
                                            return WidgetChatList(
                                                snapsot: elemnt,
                                                idx: idx,
                                                dataNotIndex: snapshot.data);
                                          },
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return const Text('Error');
                                      } else {
                                        return Center(
                                            child:
                                                const CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                                // GetX<replyController>(
                                //   init: replyController(),
                                //   builder: (controller) => Text(controller.getMessageReply),
                                // ),
                                // Visibility(
                                //     visible: getReplyController.getMessageReply != "",
                                //     child: Text(getReplyController.getMessageReply.toString())),

                                Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffFFEAEA),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        controller: message,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
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
                                              onTap: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  if (message.text != "") {
                                                    MessageHelper()
                                                        .onConnection(
                                                            image: "",
                                                            tokenDevice:
                                                                tokenDevice,
                                                            chatID: chatId
                                                                .toString(),
                                                            message:
                                                                message.text,
                                                            uidSecondUsers:
                                                                uidseconduser,
                                                            emailSecondUsers:
                                                                email);
                                                    message.clear();
                                                    scrollDown();
                                                  }
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Color(0xffFFA8A7)),
                                                  child: Icon(
                                                    Icons.send,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
                                            )),
                                      ),
                                    )),
                              ],
                            )))
        ],
      ),
    );
  }

  WidgetChatList(
      {required dynamic snapsot,
      required int idx,
      required dynamic dataNotIndex}) {
    return snapsot.get('idSecondUser') != uidseconduser
        ? Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 5),
            child: SwipeTo(
              onRightSwipe: () {},
              child: CupertinoContextMenu(
                previewBuilder: (context, animation, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: imgUser == null
                            ? SvgPicture.asset(
                                "Assets/Svg/DefaultImg.svg",
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imgUser,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Column(
                      children: [
                        Visibility(
                          visible: snapsot.get('image') != "",
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapsot.get('image'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: snapsot.get('content') != "",
                          child: Material(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(13),
                                bottomRight: Radius.circular(20)),
                            color: Color(0xffFFFFFF),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: double.infinity,
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4),
                              child: Text(
                                snapsot.get('content'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  CupertinoContextMenuAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isDefaultAction: true,
                    trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
                    child: const Text('Copy'),
                  ),
                  CupertinoContextMenuAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    trailingIcon: CupertinoIcons.reply,
                    child: const Text('Reply'),
                  ),
                  CupertinoContextMenuAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isDestructiveAction: true,
                    trailingIcon: CupertinoIcons.delete,
                    child: const Text('Delete'),
                  ),
                ],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: imgUser == null
                            ? SvgPicture.asset(
                                "Assets/Svg/DefaultImg.svg",
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imgUser,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(13),
                          bottomRight: Radius.circular(20)),
                      color: Color(0xffFFFFFF),
                      child: Container(
                          padding: EdgeInsets.all(13),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: snapsot.get('image') != "",
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      snapsot.get('image'),
                                    ),
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
                                ),
                              ),
                              Text(
                                timeFormated(date: snapsot.get('date')),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 5),
            child: SwipeTo(
              onLeftSwipe: () {},
              child: InkWell(
                onLongPress: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {},
                            child: Text("Reply",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              MessageHelper().deleteMessage(
                                  chatId: chatId.toString(),
                                  dateId: snapsot.id);
                              Navigator.pop(context);
                            },
                            child: Text("Delete",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)))
                      ],
                    ),
                  );
                },
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
                          color: Color(0xffF28F8F),
                        ),
                        padding: EdgeInsets.all(13),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: snapsot.get('image') != "",
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    snapsot.get('image'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Visibility(
                              visible: snapsot.get('content') != "",
                              child: Text(snapsot.get('content'),
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Text(
                              timeFormated(date: snapsot.get('date')),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: auth.currentUser!.photoURL == null
                            ? SvgPicture.asset(
                                "Assets/Svg/DefaultImg.svg",
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                auth.currentUser!.photoURL.toString(),
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
