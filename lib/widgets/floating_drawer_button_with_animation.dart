import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/theme/colors.dart';

const buttonSize = 75.0;

class FloatingDrawerButtonWithAnimation extends StatefulWidget {
  final List<FloatingDrawerItem> items;

  const FloatingDrawerButtonWithAnimation({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<FloatingDrawerButtonWithAnimation> createState() => _FloatingDrawerButtonWithAnimationState();
}

class _FloatingDrawerButtonWithAnimationState extends State<FloatingDrawerButtonWithAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(controller: controller, itemCount: widget.items.length),
      children: widget.items.map<Widget>((item) => buildCustomItem(item)).toList(),
    );
  }

  Widget buildCustomItem(FloatingDrawerItem item) {
    return GestureDetector(
      onTap: () {
        // Call the onTap function defined in FloatingDrawerItem
        item.onTap?.call();

        // Handle animation state
        if (controller.status == AnimationStatus.completed) {
          controller.reverse();
          log("closed");
        } else {
          controller.forward();
          log("opened");
        }
        log("$item is pressed");
      },
      child: Container(
        height: buttonSize,
        width: buttonSize,
        decoration: BoxDecoration(
          color: item.color ?? MyColors.backGroundDarkGrey2,
          shape: BoxShape.circle,
          border: Border.all(width: 0.5, color: Colors.transparent),
          image: item.imageUrl != null
              ? DecorationImage(image: AssetImage(item.imageUrl!), fit: BoxFit.cover)
              : null,
        ),
        child: item.icon != null ? Icon(item.icon, size: 30, color: Colors.white) : null,
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  final int itemCount;

  const FlowMenuDelegate({
    required this.controller,
    required this.itemCount,
  }) : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final yStart = size.height - buttonSize;

    for (int i = itemCount - 1; i >= 0; i--) {
      final margin = 10;
      final childSize = context.getChildSize(i)!.width;
      final dy = (childSize + margin) * i;
      final x = 0.0;
      final y = yStart - (buttonSize * itemCount) + dy * controller.value;
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return controller != oldDelegate.controller || itemCount != oldDelegate.itemCount;
  }
}

class FloatingDrawerItem {
  final IconData? icon;
  final Color? color;
  final String? imageUrl;
  final VoidCallback? onTap;

  FloatingDrawerItem({this.icon, this.color, this.imageUrl, this.onTap});
}
