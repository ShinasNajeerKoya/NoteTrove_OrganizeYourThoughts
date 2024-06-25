import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/loading_screen.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/size_configuration.dart';
import 'package:note_app/utils/utility.dart';
import 'package:note_app/widgets/dialog_box_widget.dart';
import 'package:note_app/widgets/floating_drawer_button_with_animation.dart';
import 'package:note_app/widgets/loading_widget.dart';
import 'package:note_app/widgets/my_text.dart';
import 'package:note_app/widgets/single_note_container_homepage_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
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

  int selectedIndex = 0;

  List<Map<String, String>> categoryListModel = [
    {"title": "All", "noteCount": "34"},
    {"title": "Important", "noteCount": "10"},
    {"title": "To-do", "noteCount": "15"},
    {"title": "Reminders", "noteCount": "7"},
    {"title": "Journal", "noteCount": "5"},
    {"title": "Favorite", "noteCount": "2"},
    {"title": "Casual", "noteCount": "7"},
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // to get the current size of the screen for MediaQuery
    final height = SizeConfig.screenHeight;
    final width = SizeConfig.screenWidth;

    // list of items for the drop down drawer
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ab_bg_w_dark.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: SizeConfig.getWidth(20), top: SizeConfig.getHeight(30)),
                      child: MyText(
                        "My\nNotes",
                        style: TextStyle(color: Colors.black, fontSize: SizeConfig.getFontSize(70)),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(20)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(20)),
                      child: SizedBox(
                        height: SizeConfig.getHeight(65),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryListModel.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                log("Category tapped: ${categoryListModel[index]['title']}");
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(20)),
                                margin: EdgeInsets.only(right: SizeConfig.getWidth(10)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(SizeConfig.getWidth(75)),
                                  border: Border.all(
                                    width: SizeConfig.getWidth(1),
                                    color: isSelected ? Colors.black : Colors.grey,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    MyText(
                                      categoryListModel[index]['title']!,
                                      style: TextStyle(
                                        fontSize: SizeConfig.getFontSize(28),
                                        color: isSelected ? Colors.black : Colors.grey,
                                      ),
                                    ),
                                    if (isSelected)
                                      Row(
                                        children: [
                                          SizedBox(width: SizeConfig.getWidth(5)),
                                          Container(
                                            height: SizeConfig.getHeight(25),
                                            width: SizeConfig.getWidth(25),
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: MyColors.backGroundDarkGrey2,
                                              shape: BoxShape.circle,
                                            ),
                                            child: MyText(
                                              categoryListModel[index]['noteCount']!,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: SizeConfig.getFontSize(13),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(20)),
                    StreamBuilder<List<NoteModel>>(
                      stream: DatabaseHandler.getNotes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CustomLoadingWidget(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No notes available",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final notes = snapshot.data!;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.getWidth(15),
                              right: SizeConfig.getWidth(15),
                              top: SizeConfig.getHeight(25),
                              bottom: SizeConfig.getHeight(20)),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: SizeConfig.getWidth(4),
                              mainAxisSpacing: SizeConfig.getHeight(10),
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
                                    height: SizeConfig.getHeight(240),
                                    width: SizeConfig.screenWidth,
                                    title: "Warning!!",
                                    subTitle: "Are you sure you want to delete this note?",
                                    popupIconAddress: "assets/images/delete_image.png",
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
              top: SizeConfig.getHeight(50),
              right: SizeConfig.getWidth(10),
              child: Container(
                height: SizeConfig.getWidth(75.0) * (items.length + 1),
                width: SizeConfig.getWidth(80),
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
