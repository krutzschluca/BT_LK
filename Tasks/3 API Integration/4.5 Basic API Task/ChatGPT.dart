import 'dart:convert';
import 'package:http/http.dart' as http;

// User data model
class User {
  final String name;
  final String email;
  final String phone;

  User({required this.name, required this.email, required this.phone});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      phone: json['phone'] ?? 'Unknown',
    );
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email, phone: $phone)';
  }
}

// Mocked API Endpoint
Future<http.Response> mockApiEndpoint() async {
  // Simulated JSON response
  const String mockResponse = '[
    {"name": "John Doe", "email": "john.doe@example.com", "phone": "123-456-7890"},
    {"name": "Jane Smith", "email": "jane.smith@example.com", "phone": "987-654-3210"}
  ]';

  // Simulating network delay
  await Future.delayed(Duration(seconds: 2));

  return http.Response(mockResponse, 200);
}

// Fetch user data
Future<List<User>> fetchUserData() async {
  try {
    // Mocked API response
    final response = await mockApiEndpoint();

    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user data. HTTP status: ${response.statusCode}');
    }
  } catch (e) {
    // Error handling
    print('Error occurred while fetching user data: $e');
    return [];
  }
}

// Main function for testing
void main() async {
  print('Fetching user data...');
  
  final users = await fetchUserData();

  if (users.isNotEmpty) {
    print('User data fetched successfully:');
    users.forEach((user) => print(user));
  } else {
    print('No user data available.');
  }
}
