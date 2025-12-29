import '../core/api_client.dart';

class NotesApi {
  final _dio = ApiClient.instance.dio;

  /// GET: كل الملاحظات
  Future<List<Map<String, dynamic>>> getAllNotes(int userId) async {
    try {
      final res = await _dio.get("/api/notes/$userId");
      return List<Map<String, dynamic>>.from(res.data);
    } catch (e) {
      throw Exception("Failed to load notes");
    }
  }

  /// POST: إضافة ملاحظة
  Future<Map<String, dynamic>> addNote(
      int userId,
      Map<String, dynamic> note,
      ) async {
    try {
      final res = await _dio.post(
        "/api/notes/$userId",
        data: note,
      );
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      throw Exception("Failed to add note");
    }
  }

  /// PUT: تعديل ملاحظة
  Future<Map<String, dynamic>> updateNote(
      int id,
      Map<String, dynamic> note,
      ) async {
    try {
      final res = await _dio.put(
        "/api/notes/$id",
        data: note,
      );
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      throw Exception("Failed to update note");
    }
  }

  /// DELETE: حذف ملاحظة
  Future<void> deleteNote(int id) async {
    try {
      await _dio.delete("/api/notes/$id");
    } catch (e) {
      throw Exception("Failed to delete note");
    }
  }
}
