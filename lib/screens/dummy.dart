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
