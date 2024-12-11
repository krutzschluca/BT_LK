import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      title: json['title'],
      isDone: json['isDone'],
    );
  }
}

class TodoListModel extends ChangeNotifier {
  List<TodoItem> _items = [];

  List<TodoItem> get items => _items;

  TodoListModel() {
    _loadItemsFromStorage();
  }

  void addItem(String title) {
    _items.add(TodoItem(title: title));
    _saveItemsToStorage();
    notifyListeners();
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    _saveItemsToStorage();
    notifyListeners();
  }

  void editItem(int index, String newTitle) {
    _items[index].title = newTitle;
    _saveItemsToStorage();
    notifyListeners();
  }

  void toggleItemDone(int index) {
    _items[index].isDone = !_items[index].isDone;
    _saveItemsToStorage();
    notifyListeners();
  }

  Future<void> _loadItemsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getStringList('todo_items') ?? [];
    _items = itemsJson.map((item) => TodoItem.fromJson(Map<String, dynamic>.from(item))).toList();
    notifyListeners();
  }

  Future<void> _saveItemsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = _items.map((item) => item.toJson()).toList();
    prefs.setStringList('todo_items', itemsJson.map((item) => item.toString()).toList());
  }
}