import 'package:flutter/cupertino.dart';
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
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  int selectedColor = 0xffa8d672; // Default to white color if none provided
  bool _isEditingNote = false;
  String? selectedImage;

  _editNote() {
    setState(() {
      _isEditingNote = true;
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        //validation for empty title
        if (_titleController.text.isEmpty) {
          toast(message: "Please enter the title");
          setState(() {
            _isEditingNote = false;
          });
          return;
        }
        // validation for empty body
        if (_bodyController.text.isEmpty) {
          toast(message: "Please enter body for the note");
          setState(() {
            _isEditingNote = false;
          });
          return;
        }
        DatabaseHandler.updateNote(NoteModel(
          id: widget.noteModel.id,
          title: _titleController.text,
          body: _bodyController.text,
          color: selectedColor,
          imageAddress: selectedImage,
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
    selectedColor = widget.noteModel.color ?? 0xFFFFFFFF; // Default to white
    selectedImage = widget.noteModel.imageAddress;
    super.initState();
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
              color: selectedImage == null ? Color(selectedColor) : null,
              image: selectedImage != null
                  ? DecorationImage(
                      image: AssetImage(selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _isEditingNote
                ? const Center(child: CircularProgressIndicator())
                : null,
          ),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: AbsorbPointer(
              absorbing: _isEditingNote,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
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
                          onTap: () {
                            showDialogBoxWidget(
                              context,
                              height: 240,
                              width: widget.width,
                              title: "Attention!!",
                              subTitle:
                                  "Save changes to your notes?",
                              popupIconAddress:
                                  "assets/images/save_icon_image.png",
                              onTapYes: () {
                                _editNote();
                                Navigator.pop(context);
                              },
                            );
                          },
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
                                selectedColor = 0xFFFFFFFF; // Reset the color
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
