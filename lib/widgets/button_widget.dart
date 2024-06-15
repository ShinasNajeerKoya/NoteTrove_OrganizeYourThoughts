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
        height: 40,
        width: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: MyColors.backroundColor),
        child: Center(child: Icon(icon,color: Colors.white,),),
      ),
    );
  }
}
