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
  late TextEditingController _taskController;

  late List<bool> _taskDone;

  late AnimationController animationController;
  late Animation<double> degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  late Animation<double> rotationAnimation;

  double getRadianFromDegree(double degree) {
    double unitRadian = 57.2958;
    return degree / unitRadian;
  }

  void initState() {
    super.initState();
    _taskController = TextEditingController();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 50.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 50.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.7), weight: 25.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.7, end: 1.0), weight: 75.0),
    ]).animate(animationController);
    rotationAnimation = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    animationController.addListener(() {
      setState(() {});
    });
  }

  //drawer section end

  //

  //

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
              builder: (context) =>
                  CreateNotePage(height: height, width: width),
            ),
          );
        },
      ),
      // FloatingDrawerItem(
      //   imageUrl: 'assets/images/abstract_1.png',
      //   onTap: () {
      //     // Function to be called when this item is tapped
      //     print('Item with abstract image tapped');
      //
      //     // Add your specific logic here
      //   },
      // ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/ab_1.png"),
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
                          itemCount: 5,
                          // Replace with your actual categories count
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
                                    Border.all(width: 1, color: Colors.white),
                              ),
                              child: Row(
                                children: [
                                  MyText(
                                    "All", // Replace with category text
                                    style: TextStyle(
                                        fontSize: 28, color: Colors.white),
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
                              left: 10, right: 10, top: 25, bottom: 20),
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
                                    title:
                                        "Are you sure you want\nto delete this note?",
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
                // color: Colors.yellow,
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
