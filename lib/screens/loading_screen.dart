import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/create_note_page.dart';
import 'package:note_app/screens/edit_note_page.dart';

class LoadingScreen extends StatefulWidget {
  final double height;
  final double width;
  final NoteModel? noteModel; // Make NoteModel nullable

  const LoadingScreen({
    Key? key,
    required this.height,
    required this.width,
    this.noteModel, // NoteModel is now nullable
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
    var duration = Duration(milliseconds: 1500);
    Timer(duration, navigateToNextPage);
  }

  void navigateToNextPage() {
    if (widget.noteModel == null || widget.noteModel!.id == null) {
      // Navigate to CreateNotePage if noteModel or id is null
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNotePage(
            height: widget.height,
            width: widget.width,
          ),
        ),
      );
    } else {
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

    if (widget.noteModel != null) {
      if (widget.noteModel!.color != null) {
        backgroundColor = Color(widget.noteModel!.color!);
      } else if (widget.noteModel!.imageAddress != null) {
        backgroundColor = Colors.transparent;
      } else {
        backgroundColor = Colors.red;
      }
    } else {
      backgroundColor =
          Color(0xfff6ecc9); // Default to red if noteModel is null
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
                : Container(color: backgroundColor),
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
