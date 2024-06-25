import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/create_note_page.dart';
import 'package:note_app/screens/edit_note_page.dart';
import 'package:note_app/utils/size_configuration.dart'; // Assuming SizeConfig is defined for responsive design

class LoadingScreen extends StatefulWidget {
  final double height;
  final double width;
  final NoteModel? noteModel;

  const LoadingScreen({
    Key? key, // Corrected parameter name
    required this.height,
    required this.width,
    this.noteModel,
  }) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    var duration = const Duration(milliseconds: 2200);
    Timer(duration, navigateToNextPage);
  }

  void navigateToNextPage() {
    if (widget.noteModel == null || widget.noteModel!.id == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNotePage(
            height: widget.height,
            width: widget.width,
          ),
        ),
      );
    } else if (widget.noteModel != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EditNotePage(
            height: widget.height,
            width: widget.width,
            noteModel: widget.noteModel!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    String? loadingBackgroundImage;

    if (widget.noteModel != null) {
      if (widget.noteModel!.color != null) {
        backgroundColor = Color(widget.noteModel!.color!);
      } else if (widget.noteModel!.imageAddress != null) {
        backgroundColor = Colors.transparent;
      } else {
        backgroundColor = Colors.red;
      }
    } else {
      loadingBackgroundImage = "assets/images/ab_bg_w_normal.png"; // Default to an image if noteModel is null
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.noteModel != null && widget.noteModel!.imageAddress != null
                ? Image.asset(
                    widget.noteModel!.imageAddress!,
                    fit: BoxFit.cover,
                  )
                : (backgroundColor != null
                    ? Container(color: backgroundColor)
                    : Image.asset(
                        loadingBackgroundImage!,
                        fit: BoxFit.cover,
                      )),
          ),
          Center(
            child: Lottie.asset(
              "assets/loading_animations/loading_new.json",
              width: SizeConfig.getWidth(200),
              height: SizeConfig.getHeight(200),
            ),
          ),
        ],
      ),
    );
  }
}
