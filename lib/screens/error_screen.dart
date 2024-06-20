import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_app/widgets/my_text.dart';

enum ErrorType {
  noInternet,
  notFound404,
}

class ErrorScreen extends StatelessWidget {
  final ErrorType errorType;
  final VoidCallback? noInternetRetry;
  final VoidCallback? notFound404GoBack;

  const ErrorScreen({
    super.key, // Corrected parameter name
    required this.errorType,
    this.noInternetRetry,
    this.notFound404GoBack,
  });

  @override
  Widget build(BuildContext context) {
    String svgIconPath;
    String errorHeader;
    String errorBody;
    Widget? actionButton;

    switch (errorType) {
      case ErrorType.noInternet:
        svgIconPath = "assets/svg/no_internet.svg";
        errorHeader = "No Internet Connection";
        errorBody = "Please connect to the internet.";
        actionButton = _customErrorButton("Try again!!", noInternetRetry);
        break;
      case ErrorType.notFound404:
        svgIconPath = "assets/svg/404_error.svg";
        errorHeader = "404 - Page Not Found";
        errorBody = "Page is currently not available.";
        actionButton = _customErrorButton("Go back!!", notFound404GoBack);
        break;
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/ab_bg_w_light.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyText(
              "Ooopss...!",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SvgPicture.asset(height: 340, svgIconPath),
            const SizedBox(height: 40),
            MyText(
              errorHeader,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const MyText(
              "We're sorry,",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            MyText(
              errorBody,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 80),
            actionButton,
          ],
        ),
      ),
    );
  }

  GestureDetector _customErrorButton(String title, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              offset: const Offset(0.0, 10.0),
              blurRadius: 10.0,
              spreadRadius: -5.0,
            ),
          ],
        ),
        child:
            MyText(title, style: const TextStyle(color: Colors.white, fontSize: 19)),
      ),
    );
  }
}
