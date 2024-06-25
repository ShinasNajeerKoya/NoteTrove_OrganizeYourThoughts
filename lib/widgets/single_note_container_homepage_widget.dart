import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/size_configuration.dart';
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
    SizeConfig.init(context); // to get the current size of the screen for MediaQuery


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
          topLeft: isLeft ? Radius.zero : Radius.circular(SizeConfig.getRadius(60)),
          bottomLeft: Radius.circular(SizeConfig.getRadius(60)),
          topRight: Radius.circular(SizeConfig.getRadius(60)),
        ),
      );
    } else if (backgroundColor != null) {
      decoration = BoxDecoration(
        color: Color(backgroundColor!),
        borderRadius: BorderRadius.only(
          bottomRight: isLeft ? Radius.circular(SizeConfig.getRadius(60)) : Radius.zero,
          topLeft: isLeft ? Radius.zero : Radius.circular(SizeConfig.getRadius(60)),
          bottomLeft: Radius.circular(SizeConfig.getRadius(60)),
          topRight: Radius.circular(SizeConfig.getRadius(60)),
        ),
      );
    } else {
      decoration = BoxDecoration(
        color: Colors.red, // Use a default background color
        borderRadius: BorderRadius.only(
          bottomRight: isLeft ? Radius.circular(SizeConfig.getRadius(60)) : Radius.zero,
          topLeft: isLeft ? Radius.zero : Radius.circular(SizeConfig.getRadius(60)),
          bottomLeft: Radius.circular(SizeConfig.getRadius(60)),
          topRight: Radius.circular(SizeConfig.getRadius(60)),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.only(
          left: SizeConfig.getHeight(12),
          right: SizeConfig.getHeight(12),
          bottom: SizeConfig.getHeight(12),
        ),
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: SizeConfig.getHeight(40),
                width: SizeConfig.getWidth(40),
                child: SvgPicture.asset(
                  "assets/svg/more_new.svg",
                ),
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: SizeConfig.getHeight(60),
                  width: SizeConfig.getWidth(100),
                  child: MyText(
                    title ?? 'No Title',
                    style: TextStyle(fontSize: SizeConfig.getFontSize(22), fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Container(
                  height: SizeConfig.getHeight(60),
                  width: SizeConfig.getWidth(60),
                  decoration: const BoxDecoration(
                    color: MyColors.black8,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    heartIcon,
                    size: SizeConfig.getIconSize(26),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.getHeight(10),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.getHeight(10), bottom: SizeConfig.getHeight(20)),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double containerHeight = constraints.maxHeight;
                    int maxLines =
                        SizeConfig.getMaxLines(containerHeight, 20); // Adjust line height as needed

                    return MyText(
                      body ?? 'No Content',
                      style: TextStyle(fontSize: SizeConfig.getIconSize(15), color: Colors.black38),
                      overflow: TextOverflow.ellipsis,
                      maxLines: maxLines,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
