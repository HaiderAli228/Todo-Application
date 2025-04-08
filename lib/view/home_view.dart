import 'package:flutter/material.dart';
import 'package:todo/model/database.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/utlis/app_color.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final dbRef = DatabaseHelper.instance;
  late Future<List<TodoModel>> _futureTodo;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    setState(() {
      _futureTodo = dbRef.fetchAddTodo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            "Todo App",
            style: TextStyle(
                color: Colors.white,
                backgroundColor: AppColors.themeColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<List<TodoModel>>(
          future: _futureTodo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.themeColor,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong "),
              );
            }
            final todos = snapshot.data!;
            if (todos.isEmpty) {
              return Center(
                child: Text("No Item Found"),
              );
            } else {
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  var todoItem = todos[index];
                  return ListTile(
                    title: Text(todoItem.title),
                  );
                },
              );
            }
          },
        ));
  }
}
