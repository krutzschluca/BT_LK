import 'package:shared_preferences/shared_preferences.dart';

class TodoList with ChangeNotifier {
  List<String> _items = [];

  TodoList() {
    _loadItems();
  }

  List<String> get items => _items;

  void addItem(String item) {
    _items.add(item);
    _saveItems();
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _saveItems();
    notifyListeners();
  }

  void editItem(int index, String newItem) {
    _items[index] = newItem;
    _saveItems();
    notifyListeners();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todo_list', _items);
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList('todo_list');
    if (savedItems != null) {
      _items = savedItems;
    }
    notifyListeners();
  }
}

// Mock data for testing
void main() async {
  final todoList = TodoList();

  // Add some initial items
  todoList.addItem('Buy groceries');
  todoList.addItem('Finish report');
  todoList.addItem('Call John');

  // Edit an item
  todoList.editItem(1, 'Submit report');

  // Remove an item
  todoList.removeItem(0);

  // Print the current list (this would normally be displayed in the UI)
  print(todoList.items); // Output: [Submit report, Call John]
}