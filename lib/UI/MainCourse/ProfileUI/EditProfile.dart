import 'package:flutter/material.dart';

class EditProfileUI extends StatefulWidget {
  EditProfileUI({Key? key}) : super(key: key);

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit profile",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0,
      ),
    );
  }
}
