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
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void deleteNoteErrorHandler(NoteModel noteIndex) {
    try {
      // try to check if the id is missing or got corrupted in the db,
      if (noteIndex.id == null || noteIndex.id!.isEmpty) {
        toast(message: "Selected notes ID is missing or corrupted in the database.");
        throw Exception("Selected notes ID is missing or corrupted in the database.");
      }

      // if there are no issues then continue with the note deletion
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: height,
        width: width,
        child: Stack(
          children: [
            Container(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
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
                    MyText(
                      "My\nNotes",
                      style: TextStyle(color: Colors.white, fontSize: 70),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            print("ontap pressed");
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
                              "All",
                              style: TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: height * 0.3,
                          width: (width / 2) - 22.5,
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 11),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(60),
                              bottomRight: Radius.circular(60),
                              bottomLeft: Radius.circular(60),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.linear_scale),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 90,
                                    child: MyText(
                                      "Plan for the day",
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
                                      CupertinoIcons.heart,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.3,
                          width: (width / 2) - 22.5,
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 11),
                          decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                              bottomLeft: Radius.circular(60),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.linear_scale),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 90,
                                    child: MyText(
                                      "Plan for the day",
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
                                      CupertinoIcons.heart,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

    // return Scaffold(
    //   backgroundColor: MyColors.darkBackroundColor,
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: MyColors.darkBackroundColor,
    //     title: Text(
    //       "Notes",
    //       style: TextStyle(fontSize: 40),
    //     ),
    //     actions: [
    //       Padding(
    //         padding: EdgeInsets.only(right: 10),
    //         child: Row(
    //           children: [
    //             ButtonWidget(icon: Icons.search),
    //             SizedBox(width: 10),
    //             ButtonWidget(icon: Icons.info_outline)
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    //   body: StreamBuilder<List<NoteModel>>(
    //     stream: DatabaseHandler.getNotes(),
    //     builder: (context, snapshots) {
    //       if (snapshots.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       if (snapshots.hasData == false) {
    //         return Center(
    //           child: Text(" No data in database"),
    //         );
    //       }
    //       if (snapshots.data!.isEmpty) {
    //         return Center(
    //           child: Text(
    //             "Data is empty, create new notes / add image for this",
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         );
    //       }
    //       if (snapshots.hasData) {
    //         final notes = snapshots.data;
    //         return ListView.builder(
    //             itemCount: notes!.length,
    //             itemBuilder: (context, index) {
    //               return SingleNoteWidget(
    //                 width: width,
    //                 title: notes[index].title,
    //                 noteBody: notes[index].body,
    //                 // color: 4294967295,
    //                 color: notes[index].color,
    //                 onTap: () {
    //                   Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => EditNotePage(
    //                                 height: height,
    //                                 width: width,
    //                                 noteModel: notes[index],
    //                               )));
    //                 },
    //                 onLongPress: () {
    //                   showDialogBoxWidget(context,
    //                       height: 230,
    //                       width: width,
    //                       title: "Are you sure you want\nto delete this note?", onTapYes: () {
    //                     deleteNoteErrorHandler(notes[index]);
    //                     Navigator.pop(context);
    //                   });
    //                 },
    //               );
    //             });
    //       }
    //
    //       //this return for the  builder , or else it might be error
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     },
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: Colors.black54,
    //     onPressed: () {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => CreateNotePage(
    //                     height: height,
    //                     width: width,
    //                   )));
    //     },
    //     child: Icon(
    //       Icons.add,
    //       color: Colors.white,
    //       size: 30,
    //     ),
    //   ),
    // );
  }
}
