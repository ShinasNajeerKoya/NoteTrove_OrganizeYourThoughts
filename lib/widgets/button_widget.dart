import 'package:flutter/material.dart';
import 'package:note_app/theme/colors.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const ButtonWidget({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        width: 75,
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
