import 'package:flutter/material.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/size_configuration.dart'; // Import your SizeConfig class

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double height;
  final double width;

  const ButtonWidget({
    super.key,
    required this.icon,
    this.onTap,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.getHeight(height),
        width: SizeConfig.getWidth(width),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MyColors.black18,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: SizeConfig.getIconSize(28),
          ),
        ),
      ),
    );
  }
}
