import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatUi.dart';

class ListUserUI extends StatefulWidget {
  ListUserUI({Key? key}) : super(key: key);

  @override
  State<ListUserUI> createState() => _ListUserUIState();
}

class _ListUserUIState extends State<ListUserUI> {
  // CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('user');

  // Future<void> getData() async {
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  var username;
  bool isload = true;

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
        isload = false;
      });
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ya"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Visibility(
                  visible:
                      snapshot.data!.docs[index].get('username') != username,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatUI(
                              email: snapshot.data!.docs[index].get('email'),
                            ),
                          ));
                    },
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
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
