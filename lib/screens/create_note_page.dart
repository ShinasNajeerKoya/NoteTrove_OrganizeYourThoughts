import 'package:flutter/material.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/utility.dart';
import 'package:note_app/widgets/button_widget.dart';
import 'package:note_app/widgets/form_widget.dart';

class CreateNotePage extends StatefulWidget {
  final double height;
  final double width;

  const CreateNotePage({super.key, required this.height, required this.width});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  bool _isCreatingNote = false;

  _createNote() {
    setState(() {
      _isCreatingNote = true;
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        //validation for empty title
        if (_titleController.text.isEmpty) {
          toast(message: "Please enter the title");
          setState(() {
            _isCreatingNote = false;
          });
          return;
        }
        // validation for empty body
        if (_bodyController.text.isEmpty) {
          toast(message: "Please enter body for the note");
          setState(() {
            _isCreatingNote = false;
          });
          return;
        }
        DatabaseHandler.createNote(NoteModel(
          title: _titleController.text,
          body: _bodyController.text,
          color: selectedColor,
        )).then((value) {
          _isCreatingNote = false;
          Navigator.pop(context);
        });
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  int selectedColor = 4294967295;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isCreatingNote == true ? Colors.grey.withOpacity(0.5):MyColors.darkBackroundColor,
      body: AbsorbPointer(
        absorbing: _isCreatingNote,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _isCreatingNote == true? CircularProgressIndicator():Container(),
            SingleChildScrollView(
              child: Container(
                height: widget.height,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        ButtonWidget(
                          icon: Icons.done,
                          onTap: _createNote,
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    FormWidget(
                      controller: _titleController,
                      hintText: "Title",
                      fontSize: 40,
                    ),
                    SizedBox(height: 10),
                    FormWidget(
                      maxLines: 15,
                      controller: _bodyController,
                      hintText: "Start Typing...",
                      fontSize: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: preDefinedColor.length,
                        itemBuilder: (context, index) {
                          final singleColor = preDefinedColor[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = singleColor.value;
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: singleColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 2,
                                      color:
                                          selectedColor == singleColor.value ? Colors.white : Colors.transparent)),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
