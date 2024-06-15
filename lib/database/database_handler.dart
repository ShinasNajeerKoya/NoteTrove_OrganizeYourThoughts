import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/note_model.dart';


class DatabaseHandler {
  //function to save notes to database, converting from dart to document
  static Future<void> createNote(NoteModel note) async {
    final notesCollection = FirebaseFirestore.instance.collection("notes");
    final id = notesCollection.doc().id;
    final newNotes = NoteModel(id: id, title: note.title, body: note.body, color: note.color).toDocument();

    try {
      notesCollection.doc(id).set(newNotes);
    } catch (errorCreating) {
      print("Some error occurred while creating: $errorCreating");
    }
  }

  // to read data from DB
  static Stream<List<NoteModel>> getNotes() {
    final notesCollection = FirebaseFirestore.instance.collection("notes");

    return notesCollection
        .snapshots()
        .map((querySnapshots) => querySnapshots.docs.map((e) => NoteModel.fromSnapShot(e)).toList());
  }

  // update / edit i DB
  static Future<void> updateNote(NoteModel note) async {
    final notesCollection = FirebaseFirestore.instance.collection("notes");
    final newNotes =
        NoteModel(id: note.id, title: note.title, body: note.body, color: note.color).toDocument();

    try {
      notesCollection.doc(note.id).set(newNotes);
    } catch (errorUpdating) {
      print("Some error occurred while updating: $errorUpdating");
    }
  }

  // to delete the note from DB
  static Future<void> deleteNote(String id) async {
    final notesCollection = FirebaseFirestore.instance.collection("notes");

    try {
      notesCollection.doc(id).delete();
    } catch (errorDeleting) {
      log("error occurred while deleting : $errorDeleting");
    }
  }
}
