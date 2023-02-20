import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whyapp/Fromated/timeFormated.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatUi.dart';
import 'package:whyapp/UI/MainCourse/ListUser/ListUser_UI.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool key = false;

  //GetUser
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListUserUI(),
              ));
        },
        child: Container(
          width: 50,
          decoration: BoxDecoration(
              color: secondarycolor, borderRadius: BorderRadius.circular(10)),
          height: 50,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: key
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    SizedBox(
                        height: 250,
                        width: 350,
                        child: Lottie.asset(
                          'Assets/Animation/chat-home.json',
                          repeat: true,
                          reverse: true,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Anda belum melakukan chat kepada siapapun",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ],
            )
          : listchat(auth: auth),
    );
  }
}

Widget listchat({required FirebaseAuth auth}) {
  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                        builder: (context) => CupertinoAlertDialog(
                          title: Text("Delete this chat?"),
                          content: Text("Hapus "),
                        ),
                      );
                    },
                    key: Key(snapshot.data!.docs[index].id),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatUI(
                                  email:
                                      snapshot.data!.docs[index].get("email")),
                            ));
                      },
                      title: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              firstAsync().toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  timeFormated(
                                      date: snapshot.data!.docs[index]
                                          .get("lastChatTime")),
                                  style:
                                      TextStyle(color: greycolor, fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.docs[index].get("lastContent")),
                          Divider(
                            color: greycolor,
                          )
                        ],
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          auth.currentUser!.photoURL.toString(),
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
        return Center(child: const CircularProgressIndicator());
      }
    },
  );
}

Future<String> getUsername({required String emailUser}) async {
  var usernameUser = "gda";
  await FirebaseFirestore.instance
      .collection("user")
      .doc(emailUser.toString())
      .snapshots()
      .listen((event) {
    usernameUser = event.get("username");
  });
  return usernameUser;
}

Future<int> four() async {
  return 4;
}

Future<String> firstAsync() async {
  await Future<String>.delayed(const Duration(seconds: 2));
  return "First!";
}
