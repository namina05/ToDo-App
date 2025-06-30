import 'package:flutter/material.dart';
import 'package:todo/model/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/presentation/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todos');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Splash());
  }
}
