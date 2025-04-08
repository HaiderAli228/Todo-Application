import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/model/todo_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _database;

  final String tableName = "todo";
  final String firstColSerNo = "s_no";
  final String secondColTitle = "title";
  final String thirdColReminder = "reminder_time";
  final String fourthColPriority = "priority";
  final String fifthColStatus = "status";

  Future<Database> getTheDatabase() async {
    _database ??= await openDB();
    return _database!;
  }

  Future<Database> openDB() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dirPath = join(appDirectory.path, "todo.db");
    return await openDatabase(
      dirPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE $tableName ("
            "$firstColSerNo INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$secondColTitle TEXT NOT NULL, "
            "$thirdColReminder INTEGER, "
            "$fourthColPriority TEXT NOT NULL ,"
            "$fifthColStatus INTEGER DEFAULT 0 "
            ");");
      },
    );
  }

  Future<List<TodoModel>> fetchAddTodo() async {
    final dbRef = await getTheDatabase();
    final maps = await dbRef.query(tableName);
    return List.generate(
      maps.length,
      (index) {
        return TodoModel.fromMap({
          "id": maps[index][firstColSerNo],
          'title': maps[index][secondColTitle],
          'priority': maps[index][fourthColPriority],
          'reminder_time': maps[index][thirdColReminder],
          'status': maps[index][fifthColStatus],
        });
      },
    );
  }

  Future<bool> addTodo({
    int? reminder,
    required String titleIs,
    required String priorityIs,
  }) async {
    try {
      final dbRef = await getTheDatabase();
      int rowEffected = await dbRef.insert(tableName, {
        secondColTitle: titleIs,
        fourthColPriority: priorityIs,
        if (reminder != null) thirdColReminder: reminder,
      });

      return rowEffected > 0;
    } catch (e) {
      print("Error in add todo in db $e");
      return false;
    }
  }

  Future<bool> updateTodo(
      {int? reminder,
      required int sNo,
      required String titleIs,
      required String priorityIs}) async {
    try {
      final dbRef = await getTheDatabase();
      int rowEffected = await dbRef.update(
          tableName,
          {
            secondColTitle: titleIs,
            fourthColPriority: priorityIs,
            if (reminder != null) thirdColReminder: reminder
          },
          where: "$firstColSerNo = ?",
          whereArgs: [sNo]);

      return rowEffected > 0;
    } catch (e) {
      print("Error in updating the todo $e");
      return false;
    }
  }

  Future<bool> deleteTodo({
    required int sNo,
  }) async {
    final dbRef = await getTheDatabase();
    int rowEffected = await dbRef.delete(
      tableName,
      where: "$firstColSerNo = ?",
      whereArgs: [sNo],
    );
    return rowEffected > 0;
  }
}
