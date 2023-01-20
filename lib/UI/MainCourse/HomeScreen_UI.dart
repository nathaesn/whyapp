import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/ChatList_UI.dart';

class HomeScreenUI extends StatefulWidget {
  HomeScreenUI({Key? key}) : super(key: key);

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI>
    with TickerProviderStateMixin {
  //CONTROLLER
  late TabController _tabController;

//START
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text(
            "WhyApp",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: TabBar(
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: secondarycolorhigh,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 13),
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Container(
                      height: 30.0,
                      child: Tab(text: 'Chat'),
                    ),
                    Container(
                      height: 30.0,
                      child: Tab(text: 'Status'),
                    ),
                    Container(
                      height: 30.0,
                      child: Tab(text: 'Profile'),
                    ),
                  ],
                ),
              ),
            ),
          )),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatList(),
          Container(
            child: ListView.builder(
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
                                style: TextStyle(
                                    fontSize: 12, color: surfacecolor),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 135,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "2023-01-11T14:54:13.000000Z"),
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
            ),
          ),
          Center(
            child: Text("VIEW 3"),
          ),
        ],
      ),
    );
  }
}
