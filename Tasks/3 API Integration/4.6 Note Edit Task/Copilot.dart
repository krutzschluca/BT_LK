import 'dart:convert';
import 'package:http/http.dart' as http;

class Note {
  final String id;
  final String title;
  final String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class NoteService {
  final String apiUrl = 'https://mockapi.example.com/notes';

  Future<Note> createNote(String title, String content) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content}),
    );

    if (response.statusCode == 201) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<List<Note>> fetchNotes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Note.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }
}

void main() async {
  final noteService = NoteService();

  try {
    // Create a new note
    Note newNote = await noteService.createNote(
      'Sample Title',
      'This is the content of the sample note.',
    );
    print('Note created: ${newNote.id}');

    // Fetch all notes
    List<Note> notes = await noteService.fetchNotes();
    print('Fetched ${notes.length} notes');

    // Delete a note
    if (notes.isNotEmpty) {
      await noteService.deleteNote(notes[0].id);
      print('Note deleted: ${notes[0].id}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}