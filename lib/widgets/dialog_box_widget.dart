import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/utils/size_configuration.dart';
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
  SizeConfig.init(context);
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.getRadius(35)),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.only(
              top: SizeConfig.getWidth(20),
              left: SizeConfig.getWidth(20),
              right: SizeConfig.getWidth(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    height: SizeConfig.getHeight(60),
                    width: SizeConfig.getWidth(60),
                    margin: EdgeInsets.only(left: SizeConfig.getWidth(10)),
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
                      height: SizeConfig.getHeight(30),
                      width: SizeConfig.getWidth(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.getRadius(10),
                        ),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: SizeConfig.getWidth(0.5),
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: Colors.grey.shade500,
                        size: SizeConfig.getIconSize(15),
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: SizeConfig.getHeight(10),
                ),
                MyText(
                  title!,
                  style: TextStyle(fontSize: SizeConfig.getFontSize(23), fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: SizeConfig.getHeight(8),
                ),
                MyText(
                  subTitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: SizeConfig.getFontSize(16), fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: SizeConfig.getHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: SizeConfig.getHeight(40),
                        width: SizeConfig.getWidth(90),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(SizeConfig.getRadius(10)),
                            border: Border.all(color: Colors.grey.shade400)),
                        child: Center(
                            child: MyText(
                          "No, thanks",
                          style: TextStyle(fontSize: SizeConfig.getFontSize(15), color: Colors.grey.shade400),
                        )),
                      ),
                    ),
                    SizedBox(width: SizeConfig.getWidth(8)),
                    Expanded(
                      child: GestureDetector(
                        onTap: onTapYes,
                        child: Container(
                          height: SizeConfig.getHeight(40),
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(SizeConfig.getRadius(10))),
                          child: Center(
                              child: MyText(
                            "Yes",
                            style: TextStyle(
                                fontSize: SizeConfig.getFontSize(20),
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
