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
    itemCount: 23,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            ListTile(
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
