import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whyapp/Theme.dart';
import 'package:whyapp/UI/MainCourse/ListUser/ListUser_UI.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool key = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListUserUI(),));
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
                        child: Lottie.asset('Assets/Animation/chat-home.json',
                            repeat: true)),
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
          : listchat(),
    );
  }
}

Widget listchat() {
  return ListView.builder(
    itemCount: 23,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("TES"),
                      content:
                          Text("TESting jkaslkdjalksdjaldjakldjlkajiodusoiu"),
                      actions: [
                        TextButton(onPressed: () {}, child: Text("ok")),
                        TextButton(onPressed: () {}, child: Text("ok"))
                      ],
                    );
                  },
                );
              },
              title: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Cece Kevin",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "10:00",
                          style: TextStyle(color: greycolor, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              subtitle: Column(
                children: [
                  Text("Lorem ipsum dolor sit amet, consectetur."),
                  Divider(
                    color: greycolor,
                  )
                ],
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "http://evillagesite.xyz/storage/public/profiles/1673449854.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
