import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:note_app/utils/size_configuration.dart';

class FloatingDrawerButtonWithAnimation extends StatefulWidget {
  final List<FloatingDrawerItem> items;

  const FloatingDrawerButtonWithAnimation({
    super.key,
    required this.items,
  });

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
      duration: const Duration(milliseconds: 300),
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
    // Initialize SizeConfig
    SizeConfig.init(context);
    double buttonSize = SizeConfig.getWidth(75.0);

    return Flow(
      delegate: FlowMenuDelegate(controller: controller, itemCount: widget.items.length, buttonSize: buttonSize),
      children: widget.items.map<Widget>((item) => buildCustomItem(item, buttonSize)).toList(),
    );
  }

  Widget buildCustomItem(FloatingDrawerItem item, double buttonSize) {
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
          color: item.color ?? Colors.grey.shade200,
          shape: BoxShape.circle,
          border: Border.all(width: SizeConfig.getWidth(0.5), color: Colors.white),
          image: item.imageUrl != null
              ? DecorationImage(image: AssetImage(item.imageUrl!), fit: BoxFit.cover)
              : null,
        ),
        child: item.icon != null
            ? Icon(item.icon, size: SizeConfig.getIconSize(35.0), color: Colors.grey.shade700)
            : null,
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  final int itemCount;
  final double buttonSize;

  const FlowMenuDelegate({
    required this.controller,
    required this.itemCount,
    required this.buttonSize,
  }) : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final yStart = size.height - buttonSize;

    for (int i = itemCount - 1; i >= 0; i--) {
      const margin = 10;
      final childSize = context.getChildSize(i)!.width;
      final dy = (childSize + margin) * i;
      const x = 0.0;
      final y = yStart - (buttonSize * itemCount) + dy * controller.value;
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return controller != oldDelegate.controller || itemCount != oldDelegate.itemCount || buttonSize != oldDelegate.buttonSize;
  }
}

class FloatingDrawerItem {
  final IconData? icon;
  final Color? color;
  final String? imageUrl;
  final VoidCallback? onTap;

  FloatingDrawerItem({this.icon, this.color, this.imageUrl, this.onTap});
}
