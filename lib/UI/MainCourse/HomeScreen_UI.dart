import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/ChatList_UI.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/Profile-UI.dart';
import 'package:whyapp/UI/MainCourse/HomeScreen_Content/StatusList-UI.dart';

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
          automaticallyImplyLeading: false,
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
        children: [ChatList(), StatusUI(), ProfileUI()],
      ),
    );
  }
}
