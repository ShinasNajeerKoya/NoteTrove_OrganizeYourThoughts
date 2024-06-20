import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/widgets/my_text.dart';

class SingleNoteContainerHomePage extends StatelessWidget {
  final String? title;
  final String? body;
  final int? backgroundColor;
  final String? imageAddress;
  final IconData heartIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isLeft;

  const SingleNoteContainerHomePage({
    super.key,
    required this.title,
    required this.body,
    this.backgroundColor,
    this.imageAddress,
    required this.heartIcon,
    this.onTap,
    this.onLongPress,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;

    if (imageAddress != null) {
      decoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAddress!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.5),
            BlendMode.softLight,
          ),
        ),
        borderRadius: BorderRadius.only(
          bottomRight: isLeft ? const Radius.circular(60) : Radius.zero,
          topLeft: isLeft ? Radius.zero : const Radius.circular(60),
          bottomLeft: const Radius.circular(60),
          topRight: const Radius.circular(60),
        ),
      );
    } else if (backgroundColor != null) {
      decoration = BoxDecoration(
        color: Color(backgroundColor!),
        borderRadius: BorderRadius.only(
          bottomRight: isLeft ? const Radius.circular(60) : Radius.zero,
          topLeft: isLeft ? Radius.zero : const Radius.circular(60),
          bottomLeft: const Radius.circular(60),
          topRight: const Radius.circular(60),
        ),
      );
    } else {
      decoration = BoxDecoration(
        color: Colors.red, // Use a default background color
        borderRadius: BorderRadius.only(
          bottomRight: isLeft ? const Radius.circular(60) : Radius.zero,
          topLeft: isLeft ? Radius.zero : const Radius.circular(60),
          bottomLeft: const Radius.circular(60),
          topRight: const Radius.circular(60),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: SvgPicture.asset(
                  "assets/svg/more_new.svg",
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 80,
                  child: MyText(
                    title ?? 'No Title',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
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
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: MyText(
                  body ?? 'No Content',
                  style: const TextStyle(fontSize: 15, color: Colors.black38),
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
