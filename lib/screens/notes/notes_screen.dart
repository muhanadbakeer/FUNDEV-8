import 'package:flutter/material.dart';
import '../../SERFICES/notes_api.dart';
import '../../services/notes_api.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final api = NotesApi();

  List<Map<String, dynamic>> notes = [];
  bool isLoading = true;
  String? error;

  int userId = 1;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await api.getAllNotes(userId);
      setState(() {
        notes = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load notes";
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _showNoteDialog({Map<String, dynamic>? note}) async {
    final titleController = TextEditingController(text: note?['title'] ?? "");
    final contentController = TextEditingController(text: note?['content'] ?? "");
    final isEdit = note != null;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Note" : "Add Note"),
          content: SizedBox(
            height: 260,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration:  InputDecoration(labelText: "Title"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration:  InputDecoration(labelText: "Content"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child:  Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(isEdit ? "Update" : "Save"),
              onPressed: () async {
                final body = {
                  "title": titleController.text.trim(),
                  "content": contentController.text.trim(),
                };

                try {
                  if (isEdit) {
                    await api.updateNote(note['id'], body);
                  } else {
                    await api.addNote(userId, body);
                  }

                  if (context.mounted) Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEdit ? "Updated ✅" : "Saved ✅")),
                  );

                  _loadNotes();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Operation failed: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNote(int id) async {
    try {
      await api.deleteNote(id);
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Deleted ✅")),
      );
      _loadNotes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Notes"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon:  Icon(Icons.refresh),
            onPressed: _loadNotes,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child:  Icon(Icons.add),
        onPressed: () => _showNoteDialog(),
      ),
      body: isLoading
          ?  Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style:  TextStyle(color: Colors.red)),
             SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadNotes,
              child:  Text("Retry"),
            )
          ],
        ),
      )
          : notes.isEmpty
          ?  Center(child: Text("No Notes Found"))
          : RefreshIndicator(
        onRefresh: _loadNotes,
        child: ListView.builder(
          padding:  EdgeInsets.all(12),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final item = notes[index];
            return Card(
              elevation: 3,
              margin:  EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  item['title'] ?? "",
                  style:  TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item['content'] ?? ""),
                onTap: () => _showNoteDialog(note: item),
                trailing: IconButton(
                  icon:  Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteNote(item['id']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
