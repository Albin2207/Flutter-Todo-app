import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  static const String baseUrl = 'https://api.nstack.in/v1/todos';

  Future<List<dynamic>> fetchTodos(int page, int limit) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));

      // Check for successful response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['items'] as List<dynamic>;
      } else {
        // Handle error response
        throw Exception('Failed to load todos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load todos: ${e.toString()}');
    }
  }

  Future<bool> addTodo(String title, String description) async {
    try {
      final body = jsonEncode({
        "title": title,
        "description": description,
        "is_completed": false,
      });
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw Exception('Failed to add todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add todo: ${e.toString()}');
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw Exception('Failed to delete todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete todo: ${e.toString()}');
    }
  }
}
