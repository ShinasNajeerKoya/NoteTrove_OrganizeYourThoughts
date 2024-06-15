import 'package:flutter/material.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/utility.dart';
import 'package:note_app/widgets/button_widget.dart';
import 'package:note_app/widgets/dialog_box_widget.dart';
import 'package:note_app/widgets/form_widget.dart';

class EditNotePage extends StatefulWidget {
  final double height;
  final double width;
  final NoteModel noteModel;

  const EditNotePage({
    super.key,
    required this.height,
    required this.width,
    required this.noteModel,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  TextEditingController? _titleController;
  TextEditingController? _bodyController;
  int selectedColor = 4294967295;
  bool _isEditingNote = false;

  _editNote() {
    setState(() {
      _isEditingNote = true;
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        //validation for empty title
        if (_titleController!.text.isEmpty) {
          toast(message: "Please enter the title");
          setState(() {
            _isEditingNote = false;
          });
          return;
        }
        // validation for empty body
        if (_bodyController!.text.isEmpty) {
          toast(message: "Please enter body for the note");
          setState(() {
            _isEditingNote = false;
          });
          return;
        }
        DatabaseHandler.updateNote(NoteModel(
          id: widget.noteModel.id,
          title: _titleController!.text,
          body: _bodyController!.text,
          color: selectedColor,
        )).then((value) {
          _isEditingNote = false;
          Navigator.pop(context);
        });
      });
    });
  }

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.noteModel.title);
    _bodyController = TextEditingController(text: widget.noteModel.body);
    selectedColor = widget.noteModel.color!;
    super.initState();
  }

  @override
  void dispose() {
    _titleController!.dispose();
    _bodyController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isEditingNote == true ? Colors.grey.shade300:MyColors.darkBackroundColor,
      body: AbsorbPointer(
        absorbing: _isEditingNote,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _isEditingNote == true ? CircularProgressIndicator():Container(),
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
                          icon: Icons.save,
                          onTap: () {
                            showDialogBoxWidget(context, height: 200, width: widget.width, title: "Save Changes ?",
                                onTapYes: () {
                              _editNote();
                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    FormWidget(
                      controller: _titleController!,
                      hintText: "Title",
                      fontSize: 40,
                    ),
                    SizedBox(height: 10),
                    FormWidget(
                      maxLines: 15,
                      controller: _bodyController!,
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
