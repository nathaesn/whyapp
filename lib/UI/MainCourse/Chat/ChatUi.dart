import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whyapp/Theme.dart';

class ChatUI extends StatefulWidget {
  ChatUI({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var uidseconduser;
  var username;
  var status;
  bool isload = true;

  String? chatId;

  final FirebaseAuth auth = FirebaseAuth.instance;

  //Scroll to end
  final ScrollController _controllerscroll = ScrollController();

// This is what you're looking for!
  void scrollDown() {
    _controllerscroll.animateTo(
      _controllerscroll.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> getData() async {
    //query the user photo
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
        },
      );

      if (sendmessage != null) {
        message.clear();
        scrollDown();
        scrollDown();
      }
    });
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

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
              validator: (val) =>
                  val!.isEmpty ? 'Mohon Masukkan Chat Anda!' : null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  isDense: true,
                  hintText: "Pesan...",
                  prefixIcon: Icon(
                    Icons.image,
                    size: 20,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        onSendMessage();
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
          leading: Container(
            width: 50,
            height: 50,
            color: greycolor,
          ),
          title: Text(
            username.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            chatId.toString(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(chatId.toString())
            .collection(chatId.toString())
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.09),
              child: RotatedBox(
                quarterTurns: 2,
                child: ListView.builder(
                  controller: _controllerscroll,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return snapshot.data!.docs[index].get('idSecondUser') !=
                            uidseconduser
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5, right: 5),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Row(
                                children: [
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
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.65),
                                    child: Text(
                                      snapshot.data!.docs[index].get('content'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 5, right: 5),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.65),
                                    child: Text(
                                      snapshot.data!.docs[index].get('content'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                  },
                ),
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
}
