import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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

class NoteApi {
  final String baseUrl = 'https://mockapi.io/notes'; // Mocked API endpoint

  Future<Note> createNote(String title, String content) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        return Note.fromJson(jsonDecode(response.body));
      } else {
        throw HttpException('Failed to create note: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating note: $e');
    }
  }

  Future<List<Note>> fetchNotes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> notesJson = jsonDecode(response.body);
        return notesJson.map((json) => Note.fromJson(json)).toList();
      } else {
        throw HttpException('Failed to fetch notes: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching notes: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw HttpException('Failed to delete note: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting note: $e');
    }
  }
}

void main() async {
  final api = NoteApi();

  // Test creating a note
  try {
    final newNote = await api.createNote('Test Title', 'This is a test note.');
    print('Note created: ${newNote.toJson()}');
  } catch (e) {
    print(e);
  }

  // Test fetching notes
  try {
    final notes = await api.fetchNotes();
    print('Fetched notes: ${notes.map((note) => note.toJson()).toList()}');
  } catch (e) {
    print(e);
  }

  // Test deleting a note
  try {
    const testNoteId = '1'; // Replace with an actual ID to test
    await api.deleteNote(testNoteId);
    print('Note with ID $testNoteId deleted.');
  } catch (e) {
    print(e);
  }
}
