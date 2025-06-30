import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String todoId;
  @HiveField(1)
  String todoName;
  @HiveField(2)
  String todoStatus;
  @HiveField(3)
  String? data;

  TodoModel({
    required this.todoId,
    required this.todoName,
    required this.todoStatus,
    this.data,
  });
}
