import 'package:flutter/material.dart';
import 'package:whyapp/NotificationController.dart';
import 'package:whyapp/Theme.dart';

class StatusUI extends StatefulWidget {
  StatusUI({Key? key}) : super(key: key);

  @override
  State<StatusUI> createState() => _StatusUIState();
}

class _StatusUIState extends State<StatusUI> {
  bool key = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {},
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
          : list(),
    );
  }

  Widget list() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: 315,
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
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Keyy",
                          style: TextStyle(
                              color: surfacecolor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Hari ini"
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
                          PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert_rounded,
                                color: surfacecolor,
                              ),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Text("Laporkan"),
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                if (value == 0) {}
                              })
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
                        "Lorem ipsum anet dot bla bla bla oke sip GG",
                        style: TextStyle(fontSize: 12, color: surfacecolor),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 135,
                      width: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  NetworkImage("2023-01-11T14:54:13.000000Z"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        size: 22,
                                        color: accentcolor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("2")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "10:00",
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
        );
      },
    );
  }
}
