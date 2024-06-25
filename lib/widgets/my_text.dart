import 'package:flutter/material.dart';
import 'package:note_app/utils/size_configuration.dart';

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
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontFamily = 'Lufga',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Text(
        data,
        style: style?.copyWith(
              fontFamily: fontFamily,
            ) ??
            TextStyle(
              fontFamily: fontFamily,
              fontSize: SizeConfig.getFontSize(20),
            ),
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}
