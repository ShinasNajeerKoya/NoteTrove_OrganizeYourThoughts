import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/create_note_page.dart';
import 'package:note_app/screens/edit_note_page.dart';
import 'package:note_app/screens/loading_screen.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/utility.dart';
import 'package:note_app/widgets/MyText.dart';
import 'package:note_app/widgets/circular_floating_button.dart';
import 'package:note_app/widgets/dialog_box_widget.dart';
import 'package:note_app/widgets/floating_drawer_button_with_animation.dart';
import 'package:note_app/widgets/single_note_container_homepage_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // drawer section start

  //drawer section end

  void deleteNoteErrorHandler(NoteModel noteIndex) {
    try {
      if (noteIndex.id == null || noteIndex.id!.isEmpty) {
        toast(
            message:
                "Selected note's ID is missing or corrupted in the database.");
        throw Exception(
            "Selected note's ID is missing or corrupted in the database.");
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

    //List of items for the drop down drawer
    List<FloatingDrawerItem> items = [
      FloatingDrawerItem(
        icon: CupertinoIcons.square_grid_2x2,
      ),
      FloatingDrawerItem(
        icon: CupertinoIcons.add,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoadingScreen(
                height: height,
                width: width,
              ),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/ab_bg_w_dark.png"),
                fit: BoxFit.cover)),
        child: Stack(
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
                        style: TextStyle(color: Colors.black, fontSize: 70),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 65,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          //todo - replace this with state
                          itemCount: 5,
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
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: Row(
                                children: [
                                  MyText(
                                    "All", // Replace with category text
                                    style: TextStyle(
                                        fontSize: 28, color: Colors.black),
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 25, bottom: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                imageAddress: notes[index].imageAddress,
                                heartIcon: CupertinoIcons.heart,
                                isLeft: index % 2 == 0,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoadingScreen(
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
                                    title: "Warning!!",
                                    subTitle:
                                        "Are you sure you want to delete this note?",
                                    popupIconAddress:
                                        "assets/images/delete_image.png",
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
              top: 50,
              right: 10,
              child: Container(
                height: buttonSize * (items.length + 1),
                width: 80,
                child: Center(
                  child: FloatingDrawerButtonWithAnimation(
                    items: items,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
