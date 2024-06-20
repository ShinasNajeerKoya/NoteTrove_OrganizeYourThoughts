import 'package:flutter/material.dart';
import 'package:note_app/theme/colors.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const ButtonWidget(
      {super.key,
      required this.icon,
      this.onTap,
      this.height = 75.0,
      this.width = 75.0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: MyColors.black18),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }
}
