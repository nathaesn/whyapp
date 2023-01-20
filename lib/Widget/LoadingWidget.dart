import 'package:flutter/material.dart';
import 'package:whyapp/Theme.dart';

Widget loading() {
  return Container(
    color: primarycolor,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
