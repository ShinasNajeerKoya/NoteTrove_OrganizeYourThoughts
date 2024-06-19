import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String? id;
  final String? title;
  final String? body;
  final int? color;
  final String? imageAddress; // New field

  NoteModel({
    this.id,
    this.title,
    this.body,
    this.color,
    this.imageAddress,
  });

  factory NoteModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return NoteModel(
      title: snapshot["title"],
      body: snapshot["body"],
      color: snapshot["color"],
      id: snapshot["id"],
      imageAddress: snapshot["imageAddress"], // Updated
    );
  }

  Map<String, dynamic> toDocument() => {
    "title": title,
    "body": body,
    "color": color,
    "id": id,
    "imageAddress": imageAddress, // Updated
  };
}
