import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whyapp/Fromated/timeFormated.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatUi.dart';
import 'package:whyapp/UI/MainCourse/ListUser/ListUser_UI.dart';

class TabListChat extends StatefulWidget {
  const TabListChat({super.key});

  @override
  State<TabListChat> createState() => _TabListChatState();
}

class _TabListChatState extends State<TabListChat> {
  double widhtCont = 50;

  var username;

  String email = "qilaadikara@gmail.com";

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> getData() async {
    //query the user photo
    await FirebaseFirestore.instance
        .collection("user")
        .doc(auth.currentUser!.email)
        .snapshots()
        .listen((event) {
      setState(() {
        username = event.get("username");
      });
    });
  }

  @override
  void initState() {
    getData();
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
                    appBar: AppBar(
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              isAddWidget = false;
                            });
                          },
                          icon: Icon(Icons.arrow_back)),
                    ),
                    body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Visibility(
                                visible: snapshot.data!.docs[index]
                                        .get('username') !=
                                    username,
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      email = snapshot.data!.docs[index]
                                          .get('email');
                                      initState();
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
                                  subtitle: Text(
                                      snapshot.data!.docs[index].get('status')),
                                  title: Text(
                                    snapshot.data!.docs[index].get('username'),
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
                                                  isAddWidget = true;
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
                    body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc(auth.currentUser!.email)
                          .collection('chatList')
                          .orderBy('lastChatTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Dismissible(
                                      onDismissed: (direction) {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                            title: Text("Delete this chat?"),
                                            content: Text("Hapus "),
                                          ),
                                        );
                                      },
                                      key: Key(snapshot.data!.docs[index].id),
                                      child: ListTile(
                                        onTap: () {
                                          setState(() {
                                            email = snapshot.data!.docs[index]
                                                .get('email');
                                            initState();
                                          });
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
                                                            .data!.docs[index]
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
                                            Text(snapshot.data!.docs[index]
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
                                            auth.currentUser!.photoURL
                                                .toString(),
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
          Expanded(child: ChatUI(email: email))
        ],
      ),
    );
  }
}
