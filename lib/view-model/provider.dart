import 'package:flutter/material.dart';
import 'package:todo/model/database.dart';
import 'package:todo/model/todo_model.dart';

class NotesProvider extends ChangeNotifier {
  List<TodoModel> _todos = [];
  List<TodoModel> get todo => _todos;

  Future<void> loadTodo() async {
    _todos = await DatabaseHelper.instance.fetchAddTodo();
    notifyListeners();
  }

  Future<bool> addProviderNotes(
    String title,
    String priority,
    int? reminder,
  ) async {
    bool success = await DatabaseHelper.instance
        .addTodo(titleIs: title, reminder: reminder, priorityIs: priority);
    if (success) await loadTodo();
    return success;
  }

  Future<bool> updateProviderNotes(
    int id,
    String title,
    String priority,
    int? reminder,
  ) async {
    bool success = await DatabaseHelper.instance.updateTodo(
        sNo: id, titleIs: title, reminder: reminder, priorityIs: priority);
    if (success) await loadTodo();
    return success;
  }
}
