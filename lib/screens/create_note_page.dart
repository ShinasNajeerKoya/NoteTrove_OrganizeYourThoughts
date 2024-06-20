import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/error_screen.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool _isCreatingNote = false;

  int selectedColor = 0xfff6ecc9;
  String? selectedImage;

  _createNote() {
    setState(() {
      _isCreatingNote = true;
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
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
          color: selectedImage == null ? selectedColor : null,
          imageAddress: selectedImage, // Updated
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundCream,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: selectedImage == null ? Color(selectedColor) : Colors.red,
              image: selectedImage != null
                  ? DecorationImage(
                      image: AssetImage(selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _isCreatingNote
                ? const ErrorScreen(errorType: ErrorType.notFound404)
                : null,
          ),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: AbsorbPointer(
              absorbing: _isCreatingNote,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          icon: CupertinoIcons.left_chevron,
                          onTap: () => Navigator.pop(context),
                        ),
                        ButtonWidget(
                          icon: CupertinoIcons.floppy_disk,
                          onTap: _createNote,
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    FormWidget(
                      controller: _titleController,
                      hintText: "Enter Your Title",
                      fontSize: 70,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _bodyController,
                      minLines: 10,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Start Typing...",
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 20),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: preDefinedNoteColors.length,
                        itemBuilder: (context, index) {
                          final singleColor = preDefinedNoteColors[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = singleColor.value;
                                selectedImage =
                                    null; // Reset the selected image
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: singleColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: selectedColor == singleColor.value
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: preDefinesNoteImages.length,
                        itemBuilder: (context, index) {
                          final image = preDefinesNoteImages[index]["image"];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImage = image;
                                selectedColor =
                                    4294967295; // Reset the selected color
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: selectedImage == image
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
