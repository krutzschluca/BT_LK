import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoItem {
  String id;
  String title;
  bool isCompleted;

  TodoItem({required this.id, required this.title, this.isCompleted = false});

  // Convert a TodoItem to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Create a TodoItem from a map
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }
}

class TodoListProvider extends ChangeNotifier {
  List<TodoItem> _items = [];

  List<TodoItem> get items => List.unmodifiable(_items);

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedItems = prefs.getString('todoList');

    if (savedItems != null) {
      final List<dynamic> decodedList = json.decode(savedItems);
      _items = decodedList.map((item) => TodoItem.fromMap(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(_items.map((item) => item.toMap()).toList());
    await prefs.setString('todoList', encodedList);
  }

  void addItem(String title) {
    final newItem = TodoItem(id: DateTime.now().toIso8601String(), title: title);
    _items.add(newItem);
    saveItems();
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    saveItems();
    notifyListeners();
  }

  void editItem(String id, String newTitle) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = TodoItem(id: _items[index].id, title: newTitle, isCompleted: _items[index].isCompleted);
      saveItems();
      notifyListeners();
    }
  }

  void toggleCompletion(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = TodoItem(id: _items[index].id, title: _items[index].title, isCompleted: !_items[index].isCompleted);
      saveItems();
      notifyListeners();
    }
  }
}

// Mock testing the provider logic
void main() async {
  final todoListProvider = TodoListProvider();
  await todoListProvider.loadItems();

  // Adding items
  todoListProvider.addItem("Buy groceries");
  todoListProvider.addItem("Walk the dog");

  // Editing an item
  if (todoListProvider.items.isNotEmpty) {
    todoListProvider.editItem(todoListProvider.items.first.id, "Buy groceries and snacks");
  }

  // Toggling completion
  if (todoListProvider.items.isNotEmpty) {
    todoListProvider.toggleCompletion(todoListProvider.items.first.id);
  }

  // Deleting an item
  if (todoListProvider.items.isNotEmpty) {
    todoListProvider.deleteItem(todoListProvider.items.first.id);
  }

  // Print current items
  for (var item in todoListProvider.items) {
    print('ID: ${item.id}, Title: ${item.title}, Completed: ${item.isCompleted}');
  }
}
