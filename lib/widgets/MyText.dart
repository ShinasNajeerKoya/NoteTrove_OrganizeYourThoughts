import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  final String fontFamily;
  final VoidCallback? onTap;

  const MyText(
    this.data, {
    Key? key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontFamily = 'Lufga',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        data,
        style: style?.copyWith(
              fontFamily: fontFamily,
            ) ??
            TextStyle(
              fontFamily: fontFamily,
              fontSize: 20,
            ),
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}
