import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      "assets/loading_animations/custom_loading_widget_black.json",
      width: 200,
      height: 200,
    ));
  }
}
