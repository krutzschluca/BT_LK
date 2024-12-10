import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class DynamicItemList extends StatefulWidget {
  const DynamicItemList({Key? key}) : super(key: key);

  @override
  State<DynamicItemList> createState() => _DynamicItemListState();
}

class _DynamicItemListState extends State<DynamicItemList> {
  Future<List<dynamic>> _fetchItems() async {
    // Simulate an asynchronous delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock data source
    const jsonString = '''
    [
      {"title": "Item 1", "description": "This is the description for item 1."},
      {"title": "Item 2", "description": "This is the description for item 2."},
      {"title": "Item 3", "description": "This is the description for item 3."}
    ]
    ''';

    // Simulate a network error
    // if (Random().nextBool()) {
    //   throw Exception('Failed to load items');
    // }

    // Parse the JSON data
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading spinner while fetching data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if the data fetch fails
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Render the list of items when the data fetch is successful
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                title: Text(
                  item['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item['description']),
              );
            },
          );
        } else {
          // Show a default message if no data is available
          return const Center(child: Text('No items found.'));
        }
      },
    );
  }
}