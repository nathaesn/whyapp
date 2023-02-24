import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whyapp/Fromated/timeFormated.dart';
import 'package:whyapp/NotificationController.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/Chat/ChatController.dart';
import 'package:whyapp/UI/MainCourse/Status/AddStatusUI.dart';
import 'package:whyapp/UI/MainCourse/Status/Comment/Comment_UI.dart';

import '../Status/StatusController.dart';

class StatusUI extends StatefulWidget {
  StatusUI({Key? key}) : super(key: key);

  @override
  State<StatusUI> createState() => _StatusUIState();
}

class _StatusUIState extends State<StatusUI> {
  bool key = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  StatusGet statusGet = Get.put(StatusGet());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStatusUI(),
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
          ? Center(
              child: Text("NODATA"),
            )
          : ListView(
              children: [
                Visibility(
                  visible: MediaQuery.of(context).size.width >= 750,
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                list(),
              ],
            ),
    );
  }

  Widget list() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('status')
          .orderBy('timestampt')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 25,
            children: List.generate(
                snapshot.data!.docs.length,
                (index) => Container(
                      margin: EdgeInsets.all(20),
                      width: 350,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(37, 0, 0, 0),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: boxcolor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20, left: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 35,
                                  child: Expanded(
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://i.pinimg.com/550x/9c/bc/af/9cbcafccdbd1995937772a047437ceb9.jpg"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Username",
                                      style: TextStyle(
                                          color: surfacecolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatTglIndo(
                                            date: snapshot.data!.docs[index]
                                                .get("datetime"))

                                        // formatTglIndo(date: rembugData!.rembug![index].createdDate.toString()) ==
                                        //         datenow
                                        //             .toString()
                                        //     ? "Hari ini"
                                        //     : daykmrin(date: rembugData!.rembug![index].createdDate.toString()).toString() + formatBulanIndo(date: rembugData!.rembug![index].createdDate.toString()) ==
                                        //             daynow.toString() + datenow2.toString()
                                        //         ? "Kemarin"
                                        //         : formatTglIndo(date: rembugData!.rembug![index].createdDate.toString()),
                                        ,
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Visibility(
                                          visible: snapshot.data!.docs[index]
                                                  .get("email") !=
                                              auth.currentUser!.email,
                                          child: SizedBox(
                                            width: 10,
                                          )),
                                      Visibility(
                                        visible: snapshot.data!.docs[index]
                                                .get("email") ==
                                            auth.currentUser!.email,
                                        child: PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert_rounded,
                                              color: surfacecolor,
                                            ),
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text("Delete"),
                                                ),
                                              ];
                                            },
                                            onSelected: (value) {
                                              if (value == 0) {
                                                StatusController().deleteStatus(
                                                    snapshot
                                                        .data!.docs[index].id
                                                        .toString(),
                                                    context);
                                              }
                                            }),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    snapshot.data!.docs[index].get("content"),
                                    style: TextStyle(
                                        fontSize: 12, color: surfacecolor),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      snapshot.data!.docs[index].get("image") !=
                                          "",
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 135,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data!.docs[index]
                                                .get("image")),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentController(
                                                        id: snapshot.data!
                                                            .docs[index].id,
                                                      ),
                                                    ));
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.comment,
                                                    size: 22,
                                                    color: accentcolor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
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
                                                      .get("datetime")),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
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
}
