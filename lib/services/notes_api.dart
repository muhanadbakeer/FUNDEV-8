import 'package:flutter/material.dart';
import '../SERFICES/notes_api.dart';
import 'notes_api.dart';

class NotesProvider extends ChangeNotifier {
  final NotesApi api;
  NotesProvider(this.api);

  bool loading = false;
  String? error;
  List<Map<String, dynamic>> notes = [];

  Future<void> fetch(int userId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      notes = await api.getAllNotes(userId);
    } catch (e) {
      error = "Failed to load notes";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> add(int userId, Map<String, dynamic> note) async {
    try {
      final created = await api.addNote(userId, note);
      notes.insert(0, created); // تحديث فوري
      notifyListeners();
    } catch (e) {
      error = "Failed to add note";
      notifyListeners();
    }
  }

  Future<void> update(int id, Map<String, dynamic> note) async {
    try {
      final updated = await api.updateNote(id, note);
      final i = notes.indexWhere((n) => n['id'] == id);
      if (i != -1) notes[i] = updated;
      notifyListeners();
    } catch (e) {
      error = "Failed to update note";
      notifyListeners();
    }
  }

  Future<void> remove(int id) async {
    try {
      await api.deleteNote(id);
      notes.removeWhere((n) => n['id'] == id);
      notifyListeners();
    } catch (e) {
      error = "Failed to delete note";
      notifyListeners();
    }
  }
}
