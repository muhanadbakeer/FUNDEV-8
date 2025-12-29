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
        error = e.toString();
        isLoading = false;
      });
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
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
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

                  if (mounted) Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEdit ? "Updated" : "Added")),
                  );

                  _loadNotes();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
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
        const SnackBar(content: Text("Deleted")),
      );
      _loadNotes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () => _showNoteDialog(),
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotes,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? ListView(
          children: [
            const SizedBox(height: 120),
            Center(child: Text("Failed to load notes")),
            const SizedBox(height: 8),
            Center(
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: _loadNotes,
                child: const Text("Retry"),
              ),
            ),
          ],
        )
            : notes.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 140),
            Center(child: Text("No Notes Found")),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final item = notes[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  (item['title'] ?? "").toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  (item['content'] ?? "").toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _showNoteDialog(note: item),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
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
