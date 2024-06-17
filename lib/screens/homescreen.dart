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
import 'package:note_app/widgets/dialog_box_widget.dart';
import 'package:note_app/widgets/floating_drawer_button_with_animation.dart';
import 'package:note_app/widgets/single_note_container_homepage_widget.dart';

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

    List<IconData> icons = [
      CupertinoIcons.square_grid_2x2,
      Icons.call,
      Icons.notification_add_outlined,
    ];

    //converting iconData to widget, item accepts only list<widget>
    List<Widget> iconWidgets =
        icons.map((icon) => Icon(icon, size: 30, color: Colors.grey.shade300)).toList();

    // Example lists of items
    List<Widget> colorItems = [
      Container(color: Colors.red, width: 30, height: 30),
      Container(color: Colors.green, width: 30, height: 30),
      Container(color: Colors.blue, width: 30, height: 30),
    ];

    List<Widget> imageItems = [
      Image.network(
        'https://via.placeholder.com/30',
        width: 30,
        height: 30,

      ),
      Image.network('https://via.placeholder.com/30', width: 30, height: 30),
      Image.network('https://via.placeholder.com/30', width: 30, height: 30),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: MyText(
                      "My\nNotes",
                      style: TextStyle(color: Colors.white, fontSize: 70),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 65,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Replace with your actual categories count
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            print("Category tapped: $index");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(75),
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                            child: Row(
                              children: [
                                MyText(
                                  "All", // Replace with category text
                                  style: TextStyle(fontSize: 28, color: Colors.white),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  height: 25,
                                  width: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: MyColors.backGroundDarkGrey2,
                                    shape: BoxShape.circle,
                                  ),
                                  child: MyText(
                                    "25",
                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<List<NoteModel>>(
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
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.60,
                          ),
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return SingleNoteContainerHomePage(
                              title: notes[index].title,
                              body: notes[index].body,
                              backgroundColor: notes[index].color,
                              heartIcon: CupertinoIcons.heart,
                              isLeft: index % 2 == 0,
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40, // Adjust top margin dynamically
            right: 20,
            child: Container(
              height: 75 * icons.length.toDouble() + 75,
              width: 75,
              // color: Colors.red,
              child: Center(child: FloatingDrawerButtonWithAnimation(items: imageItems)),
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.black54,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CreateNotePage(
      //           height: height,
      //           width: width,
      //         ),
      //       ),
      //     );
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      // ),
    );
  }
}
