import 'package:flutter/material.dart';
import 'package:whyapp/Theme.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 50,
        decoration: BoxDecoration(
            color: secondarycolor, borderRadius: BorderRadius.circular(10)),
        height: 50,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: listchat(),
    );
  }
}

Widget listchat() {
  return ListView.builder(
    itemCount: 3,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: Text(
            "Keyy",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Lorem ipsum dolor sit amet, consectetur."),
          trailing: Column(
            children: [Text("10:00")],
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
                "https://i.pinimg.com/550x/9c/bc/af/9cbcafccdbd1995937772a047437ceb9.jpg"),
          ),
        ),
      );
    },
  );
}
