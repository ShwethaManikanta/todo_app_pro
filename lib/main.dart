import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/screens/task_screens.dart';
import 'package:todo_app/view_model/task_view_model.dart';


import 'core/services/task_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel(TaskService())),
      ],
      child: MaterialApp(
        title: 'TODO App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TaskScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}