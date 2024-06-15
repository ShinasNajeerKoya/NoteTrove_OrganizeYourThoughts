import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_app/theme/colors.dart';

showDialogBoxWidget(BuildContext context,
    {String? title, VoidCallback? onTapYes, double? height, double? width}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.black87,
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                Icon(
                  Icons.info,
                  color: MyColors.lightGrey,
                  size: 40,
                ),
                SizedBox(height: 20),
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, color: Colors.white70),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTapYes,
                      child: Container(
                        width: 130,
                        height: 40,
                        decoration:
                            BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                          "Yes",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
