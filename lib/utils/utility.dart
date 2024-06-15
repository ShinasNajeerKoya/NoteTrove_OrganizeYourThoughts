import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final List<Color> preDefinedColor = [
  const Color(0xfffd99ff),
  const Color(0xffff9e9e),
  const Color(0xfffedc56),
  const Color(0xfffca3b7),
  const Color(0xff91f48f),
  const Color(0xffb69cff),
  const Color(0xff9effff),
];

final List<Color> preDefinedNoteColors = [
  const Color(0xff000000),
  const Color(0xfff7d44c),
  const Color(0xffeb7a53),
  const Color(0xff98b7db),
  const Color(0xffa8d672),
  const Color(0xfff6ecc9),
  const Color(0xffffffff),
];

// for the floating notification, used toast instead of snackbar
void toast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    fontSize: 15.0,
  );
}
