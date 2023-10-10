import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/note_model.dart';

class FirestoreService {
  // Collection Reference
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  // CREATE
  Future<void> createNote(Note note) async {
    return await _notes
        .add(note.toMap()) //firestore add() takes a map, http post takes json
        .then((value) => print("Note Added"))
        .catchError((_) {
      print("Could not add note");
    });
  }

  //UPDATE
  Future<void> updateNote(String docId, Note note) async {
    return await _notes
        .doc(docId)
        .update(note.toMap())
        .then((value) => print("Note Updated"))
        .catchError((_) {
      print("Could not update note");
    });
  }


  // READ
  // Stream is used to listen to changes in the database.
  Stream<QuerySnapshot> getNotesStream() {
    return _notes.orderBy('createdAt', descending: false).snapshots();
  }

  // DELETE
  Future<void> deleteNote(String docId) async {
    return await _notes
        .doc(docId)
        .delete()
        .then((value) => print("Note Deleted"))
        .catchError((_) {
      print("Could not delete note");
    });
  }

  //Get a single note
  Future<String> getNoteById(String docId) async {
    DocumentSnapshot ds = await _notes.doc(docId).get();
    final Map<String, dynamic> map = ds.data() as Map<String, dynamic>;
    return map['text'].toString();
  }

}
