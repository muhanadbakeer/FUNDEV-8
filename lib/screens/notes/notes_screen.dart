import 'package:flutter/material.dart';
import '../../core/uite/db_helper.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await NotesDatabase().getAllNotes();
    setState(() {
      notes = data;
      isLoading = false;
    });
  }

  Future<void> _showNoteDialog({Map<String, dynamic>? note}) async {
    final titleController = TextEditingController(text: note?['title'] ?? "");
    final contentController = TextEditingController(
      text: note?['content'] ?? "",
    );
    final isEdit = note != null;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Note" : "Add Note"),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: "Content"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(isEdit ? "Update" : "Save"),
              onPressed: () async {
                final newNote = {
                  "title": titleController.text,
                  "content": contentController.text,
                  "created_at": DateTime.now().toString(),
                  "updated_at": DateTime.now().toString(),
                };
                if (isEdit) {
                  newNote.addAll({"id": note['id'].toString()});
                  await NotesDatabase().updateNote(newNote);
                } else {
                  await NotesDatabase().insertNote(newNote);
                }

                Navigator.pop(context);
                _loadNotes();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNote(int id) async {
    await NotesDatabase().deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () => _showNoteDialog(),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? Center(
              child: Text("No Notes Found", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final item = notes[index];

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      item['content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _showNoteDialog(note: item),

                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(item['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
