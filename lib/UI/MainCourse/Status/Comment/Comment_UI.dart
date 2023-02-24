import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/Status/StatusController.dart';

class CommentController extends StatefulWidget {
  CommentController({super.key, required this.id});
  String id;

  @override
  State<CommentController> createState() => _CommentControllerState();
}

class _CommentControllerState extends State<CommentController> {
  TextEditingController comment = TextEditingController();
  var username;
  var email;
  var img;
  var content;
  var userPhotos;
  bool isload = true;

  Future<void> getData() async {
    //query the user photo

    await FirebaseFirestore.instance
        .collection("status")
        .doc(widget.id)
        .snapshots()
        .listen((event) {
      setState(() async {
        email = event.get("email");
        content = event.get("content");
        email = event.get("email");
        img = event.get("image");
        await FirebaseFirestore.instance
            .collection("user")
            .doc(email)
            .snapshots()
            .listen((event) {
          setState(() {
            username = event.get("username");
            userPhotos = event.get("image");
            isload = false;
          });
        });
      });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: secondarycolor,
            )),
      ),
      body: isload
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: userPhotos == null
                            ? SvgPicture.asset(
                                "Assets/Svg/DefaultImg.svg",
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                userPhotos,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(content),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: img != "",
                    child: Container(
                      height: 135,
                      width: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(img), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey),
                    ),
                  ),
                  Divider(),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('status')
                        .doc(widget.id)
                        .collection("comment")
                        .orderBy('timestampt')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ListTile(
                            title:
                                Text(snapshot.data!.docs[index].get("email")),
                            subtitle:
                                Text(snapshot.data!.docs[index].get("comment")),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return Center(child: const CircularProgressIndicator());
                      }
                    },
                  )),
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0xffFFEAEA),
                          borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        child: TextFormField(
                          controller: comment,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              isDense: true,
                              hintText: "Pesan...",
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (comment.text != "") {
                                    StatusController().postcomment(
                                        contentID: widget.id,
                                        comment: comment.text,
                                        timestampt: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString());

                                    setState(() {
                                      comment.clear();
                                    });
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
              ),
            ),
    );
  }
}
