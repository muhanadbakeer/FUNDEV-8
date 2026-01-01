import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeDto {
  final int id;
  final String title;
  final int minutes;
  final String imageUrl;
  final bool isPro;

  RecipeDto({
    required this.id,
    required this.title,
    required this.minutes,
    required this.imageUrl,
    required this.isPro,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> j) {
    return RecipeDto(
      id: (j['id'] ?? 0) as int,
      title: (j['title'] ?? '') as String,
      minutes: (j['minutes'] ?? 0) as int,
      imageUrl: (j['imageUrl'] ?? '') as String,
      isPro: (j['isPro'] ?? false) as bool,
    );
  }
}

class RecipesApi {

  static const String baseUrl = "http://10.0.2.2:5172";

  static Future<List<RecipeDto>> getExplore({String? search}) async {
    final uri = Uri.parse("$baseUrl/api/recipes/explore")
        .replace(queryParameters: {
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Explore failed: ${res.statusCode}");
    }

    final List data = jsonDecode(res.body) as List;
    return data.map((e) => RecipeDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<RecipeDto>> getFavorites(String userId) async {
    final uri = Uri.parse("$baseUrl/api/recipes/favorites/$userId");
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception("Favorites failed: ${res.statusCode}");
    }

    final List data = jsonDecode(res.body) as List;
    return data.map((e) => RecipeDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<RecipeDto>> getRatings(String userId) async {
    final uri = Uri.parse("$baseUrl/api/recipes/ratings/$userId");
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception("Ratings failed: ${res.statusCode}");
    }

    final List data = jsonDecode(res.body) as List;
    return data.map((e) => RecipeDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
