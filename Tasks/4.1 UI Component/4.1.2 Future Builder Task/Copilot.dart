import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('FutureBuilder Example')),
        body: ItemList(),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  Future<List<Map<String, String>>> fetchItems() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    final response = '''
    [
      {"title": "Item 1", "description": "Description 1"},
      {"title": "Item 2", "description": "Description 2"},
      {"title": "Item 3", "description": "Description 3"}
    ]
    ''';
    return List<Map<String, String>>.from(json.decode(response));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: fetchItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items found'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item['description']!),
              );
            },
          );
        }
      },
    );
  }
}