import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/create_note_page.dart';
import 'package:note_app/screens/edit_note_page.dart';

class LoadingScreen extends StatefulWidget {
  final double height;
  final double width;
  final NoteModel? noteModel;

  const LoadingScreen({
    super.key,
    required this.height,
    required this.width,
    this.noteModel, // NoteModel is now nullable
  });

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
    var duration = Duration(milliseconds: 1500);
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
      // Navigate to EditNotePage if noteModel is not null and id is not null
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
      loadingBackgroundImage =
          "assets/images/ab_bg_w_normal.png"; // Default to an image if noteModel is null
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.noteModel != null &&
                    widget.noteModel!.imageAddress != null
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
              "assets/loading_animations/page_loading_animation.json",
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
