import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final double? fontSize;
  final int? minLines;
  final int? maxLines;
  final TextEditingController controller;
  final String hintText;

  const FormWidget(
      {super.key,
      this.fontSize,
      this.maxLines,
      required this.controller,
      required this.hintText,
      this.minLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      controller: controller,
      style: TextStyle(fontSize: fontSize, fontFamily: "Lufga"),
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
      ),
    );
  }
}
