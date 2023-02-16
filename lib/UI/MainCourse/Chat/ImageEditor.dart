import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ImageActionUI extends StatefulWidget {
  ImageActionUI({Key? key, required this.imageFile}) : super(key: key);
  File? imageFile;

  @override
  State<ImageActionUI> createState() => _ImageActionUIState();
}

class _ImageActionUIState extends State<ImageActionUI> {
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: InkWell(
                onTap: () {
                  widget.imageFile = null;
                  // if (imageFile != null) {
                  //   print("ssdh : " + imageFile.toString());
                  // }
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ))),
        floatingActionButton: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 72, 72, 72),
                borderRadius: BorderRadius.circular(30)),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: message,
                validator: (val) =>
                    val!.isEmpty ? 'Mohon Masukkan Chat Anda!' : null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    isDense: true,
                    hintText: "Caption...",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xffFFA8A7)),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          )),
                    )),
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Zoom(
                initTotalZoomOut: true,
                canvasColor: Colors.black,
                enableScroll: false,
                maxZoomWidth: MediaQuery.of(context).size.width,
                maxZoomHeight: MediaQuery.of(context).size.width,
                child: Image.file(widget.imageFile ?? File(''))),
          ),
        ));
  }
}
