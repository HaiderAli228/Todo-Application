import 'package:flutter/material.dart';
import 'package:todo/model/database.dart';
import 'package:todo/utlis/app_color.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final dbRef = DatabaseHelper.instance;


  @override
  void initState() {
    super.initState();
    dbRef.getTheDatabase();
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
      body:
    );
  }
}
