import 'package:flutter/material.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/widgets/MyText.dart';

class SingleNoteContainerHomePage extends StatelessWidget {
  final String? title;
  final String? body;
  final int? backgroundColor;
  final IconData heartIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isLeft;

  const SingleNoteContainerHomePage({
    Key? key,
    required this.title,
    required this.body,
    required this.backgroundColor,
    required this.heartIcon,
    this.onTap,
    this.onLongPress,
    required this.isLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(backgroundColor!),
          borderRadius: BorderRadius.only(
            bottomRight: isLeft ? Radius.circular(60) : Radius.zero,
            topLeft: isLeft ? Radius.zero : Radius.circular(60),
            bottomLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(Icons.horizontal_rule_outlined)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 80,
                  child: MyText(
                    title!,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: MyColors.black8,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    heartIcon,
                    size: 26,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: MyText(
                  body!,
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
