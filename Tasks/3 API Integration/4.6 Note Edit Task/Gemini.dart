import 'dart:convert';
import 'package:http/http.dart' as http;

// Mock API endpoint URLs
const String baseUrl = 'https://mock-api.example.com';
const String notesEndpoint = '/notes';

// Data structure for a note
class Note {
  final String id;
  final String title;
  final String content;

  Note({required this.id, required this.title, required this.content});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}

// API service class
class ApiService {
  // Create a new note
  Future<Note> createNote(String title, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$notesEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'content': content}),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Note.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to create note: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  // Fetch all notes
  Future<List<Note>> fetchNotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$notesEndpoint'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List;
        return jsonResponse.map((note) => Note.fromJson(note)).toList();
      } else {
        throw Exception('Failed to fetch notes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$notesEndpoint/$id'),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete note: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}

// Mock data for testing
final mockNotes = [
  Note(id: '1', title: 'Note 1', content: 'Content 1'),
  Note(id: '2', title: 'Note 2', content: 'Content 2'),
];

// Mock API responses
class MockApiService extends ApiService {
  @override
  Future<Note> createNote(String title, String content) async {
    final newNote =
        Note(id: (mockNotes.length + 1).toString(), title: title, content: content);
    mockNotes.add(newNote);
    return newNote;
  }

  @override
  Future<List<Note>> fetchNotes() async {
    return mockNotes;
  }

  @override
  Future<void> deleteNote(String id) async {
    mockNotes.removeWhere((note) => note.id == id);
  }
}