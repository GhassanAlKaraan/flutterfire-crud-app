import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_crud_demo/service/firestore_service.dart';
import 'package:flutter/material.dart';
import '../model/note_model.dart';
import '../service/constants.dart';
import '../service/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_noteController.text.isEmpty) {
      // Navigator.pop(context);
      Utils.snackTopError(context, "Please enter your note.");
      return;
    }
    try {
      _firestoreService.createNote(Note(text: _noteController.text));
      Utils.snackTopSuccess(context, "Note Added");
    } catch (e) {
      Utils.snackTopError(context, e.toString());
    }
    _noteController.clear();
    Navigator.pop(context);
  }

  void _updateNote(String docId) {
    if (_noteController.text.isEmpty) {
      // Navigator.pop(context);
      Utils.snackTopError(context, "Please enter your note.");
      return;
    }
    try {
      _firestoreService.updateNote(docId, Note(text: _noteController.text));

      Utils.snackTopSuccess(context, "Note Updated");
    } catch (e) {
      Utils.snackTopError(context, e.toString());
    }
    _noteController.clear();
    Navigator.pop(context);
  }

  void _deleteNote(String docId) {
    try {
      _firestoreService.deleteNote(docId);

      Utils.snackTopInfo(context, "Note Deleted");
    } catch (e) {
      Utils.snackTopError(context, e.toString());
    }
  }

  void _showNoteDialog(BuildContext context, String? docId) async{
    String initialText = ""; // Initialize initialText as an empty string
    if (docId != null) {
      // If docId is not null, it means we are editing an existing note
      // Retrieve the existing note text and set it as initialText
      final String noteText = await _firestoreService.getNoteById(docId);
      initialText = noteText;
    }
    _noteController.text = initialText; // Set the text field with initialText

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note:'),
        content: TextField(
          maxLength: 80,
          minLines: 5,
          maxLines: 5,
          controller: _noteController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            labelText: 'Note (max 80 chars)',
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel', style: kTxt0),
              ),
              TextButton(
                onPressed: () {
                  if (docId == null) {
                    _addNote();
                  } else {
                    _updateNote(docId);
                  }

                  // Navigator.pop(context);
                },
                child: const Text('Add', style: kTxt0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[100],
        appBar: AppBar(
          title: const Text('Firestore CRUD Demo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showNoteDialog(context, null);
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Something went wrong',
                    style: kTxt1,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'No notes found',
                    style: kTxt1,
                  ),
                );
              } else {
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  primary: true, // scrollable : true
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // the document snapshot is a map
                    DocumentSnapshot ds = docs[index];
                    // to keep track of the notes, we need the document id
                    String docId = ds.id;
                    // get the text from the map
                    String text = ds['text'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        onTap: () => _showNoteDialog(context, docId),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                                width: 3, color: Colors.indigo)),
                        tileColor: Colors.white70,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(text, style: kTxt0),
                            const SizedBox(height: 10),
                            Text(docId, style: kTxt2),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () => Utils.showAlertDialog(context, () {
                            _deleteNote(docId);
                          }, "Delete Note?"),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
