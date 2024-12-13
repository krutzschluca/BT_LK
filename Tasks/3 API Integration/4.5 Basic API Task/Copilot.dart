import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String name;
  final String email;
  final String phone;

  User({required this.name, required this.email, required this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class ApiService {
  final String apiUrl = 'https://mockapi.example.com/users';

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<User> users = body.map((dynamic item) => User.fromJson(item)).toList();
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}

void main() async {
  ApiService apiService = ApiService();

  try {
    List<User> users = await apiService.fetchUsers();
    for (var user in users) {
      print('Name: ${user.name}, Email: ${user.email}, Phone: ${user.phone}');
    }
  } catch (e) {
    print('Error: $e');
  }
}