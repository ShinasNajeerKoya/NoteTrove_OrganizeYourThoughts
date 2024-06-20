import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/widgets/my_text.dart';

showDialogBoxWidget(
  BuildContext context, {
  String? title,
  String? subTitle,
  String? popupIconAddress,
  VoidCallback? onTapYes,
  double? height,
  double? width,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.only(left: 10, top: 0),
                        child: Image.asset(
                          popupIconAddress!,
                          fit: BoxFit.fitHeight,
                          scale: 0.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 0.5,
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.xmark,
                            color: Colors.grey.shade500,
                            size: 15,
                          ),
                        ),
                      )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                MyText(
                  title!,
                  style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8,
                ),
                MyText(
                  subTitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade400)),
                        child: Center(
                            child: MyText(
                          "No, thanks",
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade400),
                        )),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: onTapYes,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(18)),
                          child: const Center(
                              child: MyText(
                            "Yes",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          )),
                        ),
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
