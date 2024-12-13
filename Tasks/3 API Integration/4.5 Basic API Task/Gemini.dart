import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Mock API endpoint
const String apiUrl = 'https://mock-api.com/users';

// User data class
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

// Function to fetch user data
Future<List<User>> fetchUserData() async {
  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<User> users = jsonResponse.map((data) => User.fromJson(data)).toList();
      return users;
    } else {
      // Handle API error
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or other errors
    throw Exception('Error fetching data: $e');
  }
}

// Mock API response for testing
Future<List<User>> mockFetchUserData() async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

  final mockResponse = [
    {
      "name": "John Doe",
      "email": "john.doe@example.com",
      "phone": "1234567890"
    },
    {
      "name": "Jane Smith",
      "email": "jane.smith@example.com",
      "phone": "9876543210"
    }
  ];

  return mockResponse.map((data) => User.fromJson(data)).toList();
}

void main() async {
  // Fetch user data using the mock API
  List<User> users = await mockFetchUserData();

  // Process the fetched user data
  for (User user in users) {
    print('Name: ${user.name}');
    print('Email: ${user.email}');
    print('Phone: ${user.phone}');
    print('--------------------');
  }
}