// class Dummy extends StatefulWidget {
//   const Dummy({super.key});
//
//   @override
//   State<Dummy> createState() => _DummyState();
// }
//
// class _DummyState extends State<Dummy> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.darkBackroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: MyColors.darkBackroundColor,
//         title: Text(
//           "Notes",
//           style: TextStyle(fontSize: 40),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 10),
//             child: Row(
//               children: [
//                 ButtonWidget(icon: Icons.search),
//                 SizedBox(width: 10),
//                 ButtonWidget(icon: Icons.info_outline)
//               ],
//             ),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<NoteModel>>(
//         stream: DatabaseHandler.getNotes(),
//         builder: (context, snapshots) {
//           if (snapshots.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshots.hasData == false) {
//             return Center(
//               child: Text(" No data in database"),
//             );
//           }
//           if (snapshots.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 "Data is empty, create new notes / add image for this",
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }
//           if (snapshots.hasData) {
//             final notes = snapshots.data;
//             return ListView.builder(
//                 itemCount: notes!.length,
//                 itemBuilder: (context, index) {
//                   return SingleNoteWidget(
//                     width: width,
//                     title: notes[index].title,
//                     noteBody: notes[index].body,
//                     // color: 4294967295,
//                     color: notes[index].color,
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => EditNotePage(
//                                     height: height,
//                                     width: width,
//                                     noteModel: notes[index],
//                                   )));
//                     },
//                     onLongPress: () {
//                       showDialogBoxWidget(context,
//                           height: 230,
//                           width: width,
//                           title: "Are you sure you want\nto delete this note?", onTapYes: () {
//                         deleteNoteErrorHandler(notes[index]);
//                         Navigator.pop(context);
//                       });
//                     },
//                   );
//                 });
//           }
//
//           //this return for the  builder , or else it might be error
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black54,
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => CreateNotePage(
//                         height: height,
//                         width: width,
//                       )));
//         },
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 30,
//         ),
//       ),
//     );
//   }
// }


// hompage new
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

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: height - 40,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      margin: const EdgeInsets.only(top: 20, right: 20),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 10),
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
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
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
                              // Adjust based on position
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
