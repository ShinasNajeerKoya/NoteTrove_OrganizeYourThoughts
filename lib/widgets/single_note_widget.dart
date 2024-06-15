import 'package:flutter/material.dart';

class SingleNoteWidget extends StatelessWidget {
  final String? title;
  final String? noteBody;
  final int? color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const SingleNoteWidget({
    super.key,
    required this.width, this.title, this.noteBody, this.color, this.onTap, this.onLongPress,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(15),
        width: width,
        decoration: BoxDecoration(
          color: Color(color!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              noteBody!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
