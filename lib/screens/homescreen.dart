import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/create_note_page.dart';
import 'package:note_app/screens/edit_note_page.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/utility.dart';
import 'package:note_app/widgets/MyText.dart';
import 'package:note_app/widgets/button_widget.dart';
import 'package:note_app/widgets/dialog_box_widget.dart';
import 'package:note_app/widgets/form_widget.dart';
import 'package:note_app/widgets/single_note_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void deleteNoteErrorHandler(NoteModel noteIndex) {
    try {
      if (noteIndex.id == null || noteIndex.id!.isEmpty) {
        toast(message: "Selected note's ID is missing or corrupted in the database.");
        throw Exception("Selected note's ID is missing or corrupted in the database.");
      }

      DatabaseHandler.deleteNote(noteIndex.id!);
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: MyColors.backGroundDarkGrey2,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.square_grid_2x2,
                      size: 30,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MyText(
                "My\nNotes",
                style: TextStyle(color: Colors.white, fontSize: 70),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Replace with your actual categories count
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      print("Category tapped: $index");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        border: Border.all(width: 1, color: Colors.white),
                      ),
                      child: MyText(
                        "All", // Replace with category text
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: StreamBuilder<List<NoteModel>>(
                  stream: DatabaseHandler.getNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No notes available",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final notes = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.74,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return SingleNoteContainerHomePage(
                          title: notes[index].title,
                          body: notes[index].body,
                          backgroundColor: notes[index].color,
                          heartIcon: CupertinoIcons.heart,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditNotePage(
                                  height: height,
                                  width: width,
                                  noteModel: notes[index],
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            showDialogBoxWidget(
                              context,
                              height: 230,
                              width: width,
                              title: "Are you sure you want\nto delete this note?",
                              onTapYes: () {
                                deleteNoteErrorHandler(notes[index]);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNotePage(
                height: height,
                width: width,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class SingleNoteContainerHomePage extends StatelessWidget {
  final String? title;
  final String? body;
  final int? backgroundColor;
  final IconData heartIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SingleNoteContainerHomePage({
    super.key,
    required this.title,
    required this.body,
    required this.backgroundColor,
    required this.heartIcon,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 12, right: 10, bottom: 20),
        decoration: BoxDecoration(
          color: Color(backgroundColor!),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(60),
            bottomLeft: Radius.circular(60),
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.linear_scale),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 80,
                  child: MyText(
                    title!,
                    // "Plan for the day",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                decoration: BoxDecoration(
                    // color: Colors.green,
                    ),
                child: MyText(
                  body!,
                  // "sahdgas jhgdas body of the note,fsdf sdfsd sdf sdfsd rgre refwe write anythiong here dghasd f the note, write anythiong here dghasd suayhdasjk suayhdasjk asiuasdas duahsd"
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
