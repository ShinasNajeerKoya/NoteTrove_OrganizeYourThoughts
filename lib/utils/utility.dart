import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final List<Color> preDefinedNoteColors = [
  const Color(0xfffff6ef),
  const Color(0xfff6ecc9),
  const Color(0xffebf6fc),
  const Color(0xffa8d672),
  const Color(0xfff6f7e7),
  const Color(0xfffddee6),
  const Color(0xfff1fdf1),
];

List preDefinesNoteImages = [
  {"image": "assets/images/ab_2.png"},
  {"image": "assets/images/ab_4.png"},
  {"image": "assets/images/ab_7.png"},
  {"image": "assets/images/ab_8.png"},
  {"image": "assets/images/ab_9.png"},
  {"image": "assets/images/ab_10.png"},
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
