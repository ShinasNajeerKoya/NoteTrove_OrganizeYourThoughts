import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/database/database_handler.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/theme/colors.dart';
import 'package:note_app/utils/size_configuration.dart';
import 'package:note_app/utils/utility.dart';
import 'package:note_app/widgets/button_widget.dart';
import 'package:note_app/widgets/dialog_box_widget.dart';
import 'package:note_app/widgets/form_widget.dart';
import 'package:note_app/widgets/loading_widget.dart';

class EditNotePage extends StatefulWidget {
  final double height;
  final double width;
  final NoteModel noteModel;

  const EditNotePage({
    Key? key,
    required this.height,
    required this.width,
    required this.noteModel,
  }) : super(key: key);

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
        // Validation for empty title
        if (_titleController.text.isEmpty) {
          toast(message: "Please enter the title");
          setState(() {
            _isEditingNote = false;
          });
          return;
        }
        // Validation for empty body
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
            child: _isEditingNote ? const Center(child: CustomLoadingWidget()) : null,
          ),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: AbsorbPointer(
              absorbing: _isEditingNote,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(15),
                  vertical: SizeConfig.getHeight(50),
                ),
                child: Column(
                  children: [
                    Row(
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
                            onTap: () {
                              showDialogBoxWidget(
                                context,
                                height: SizeConfig.getHeight(240),
                                width: widget.width,
                                title: "Attention!!",
                                subTitle: "Save changes to your notes?",
                                popupIconAddress: "assets/images/save_icon_image.png",
                                onTapYes: () {
                                  _editNote();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.getHeight(30)),
                    FormWidget(
                      controller: _titleController,
                      hintText: "Enter Your Title",
                      fontSize: SizeConfig.getFontSize(70),
                      maxLines: 2,
                    ),
                    SizedBox(height: SizeConfig.getHeight(10)),
                    TextField(
                      controller: _bodyController,
                      minLines: 10,
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
                              height: SizeConfig.getHeight(60),
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
                                selectedColor = 0xFFFFFFFF; // Reset the color
                              });
                            },
                            child: Container(
                              height: SizeConfig.getHeight(60),
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
