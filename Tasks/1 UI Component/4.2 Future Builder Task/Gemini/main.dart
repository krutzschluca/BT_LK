import 'package:flutter/material.dart';
import 'dynamic_list.dart'; // Import the dynamic_list.dart file

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic List')),
        body: const DynamicItemList(),
      ),
    );
  }
}