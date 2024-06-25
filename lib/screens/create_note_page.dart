import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/size_configuration.dart'; // Import your SizeConfig class
import 'package:note_app/utils/utility.dart';
import 'package:note_app/widgets/button_widget.dart';
import 'package:note_app/widgets/form_widget.dart';
import 'package:note_app/widgets/loading_widget.dart';

class CreateNotePage extends StatefulWidget {
  final double height;
  final double width;

  const CreateNotePage({Key? key, required this.height, required this.width}) : super(key: key);

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
        // Validation for empty title
        if (_titleController.text.isEmpty) {
          // Use SizeConfig for dynamic toast position
          toast(message: "Please enter the title");
          setState(() {
            _isCreatingNote = false;
          });
          return;
        }
        // Validation for empty body
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
          imageAddress: selectedImage,
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
            child: _isCreatingNote ? const Center(child: CustomLoadingWidget()) : null,
          ),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: AbsorbPointer(
              absorbing: _isCreatingNote,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(15),
                  vertical: SizeConfig.getHeight(50),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: SizeConfig.getWidth(75),
                            child: ButtonWidget(
                              icon: CupertinoIcons.left_chevron,
                              onTap: () => Navigator.pop(context),
                              height: SizeConfig.getHeight(75),
                              width: SizeConfig.getWidth(75),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.getWidth(75),
                            child: ButtonWidget(
                              height: SizeConfig.getHeight(75),
                              width: SizeConfig.getWidth(75),
                              icon: CupertinoIcons.floppy_disk,
                              onTap: _createNote,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(30)),
                    FormWidget(
                      controller: _titleController,
                      hintText: "Enter \nYour Title",
                      fontSize: SizeConfig.getFontSize(70),
                      minLines: SizeConfig.getHeight(2).toInt(),
                      maxLines: null,
                    ),
                    SizedBox(height: SizeConfig.getHeight(10)),
                    TextField(
                      controller: _bodyController,
                      minLines: SizeConfig.getHeight(10).toInt(),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Start Typing...",
                        hintStyle: TextStyle(fontSize: SizeConfig.getFontSize(20)),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: SizeConfig.getFontSize(20)),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: SizeConfig.getHeight(10)),
                    SizedBox(
                      height: SizeConfig.getHeight(80),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: preDefinedNoteColors.length,
                        itemBuilder: (context, index) {
                          final singleColor = preDefinedNoteColors[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = singleColor.value;
                                selectedImage = null; // Reset the selected image
                              });
                            },
                            child: Container(
                              height: SizeConfig.getWidth(60),
                              width: SizeConfig.getWidth(60),
                              margin: EdgeInsets.only(right: SizeConfig.getWidth(10)),
                              decoration: BoxDecoration(
                                color: singleColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: SizeConfig.getWidth(2),
                                  color:
                                      selectedColor == singleColor.value ? Colors.white : Colors.transparent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(10)),
                    SizedBox(
                      height: SizeConfig.getHeight(80),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: preDefinesNoteImages.length,
                        itemBuilder: (context, index) {
                          final image = preDefinesNoteImages[index]["image"];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImage = image;
                                selectedColor = 4294967295; // Reset the selected color
                              });
                            },
                            child: Container(
                              height: SizeConfig.getWidth(60),
                              width: SizeConfig.getWidth(60),
                              margin: EdgeInsets.only(right: SizeConfig.getWidth(10)),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: SizeConfig.getWidth(2),
                                  color: selectedImage == image ? Colors.white : Colors.transparent,
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
