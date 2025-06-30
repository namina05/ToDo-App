import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/model/todo_model.dart';

class Task extends StatefulWidget {
  TodoModel t;

  Task({super.key, required this.t});
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  Color pink = const Color.fromARGB(255, 232, 146, 175);
  final _formkey = GlobalKey<FormState>();
  final para = TextEditingController();

  @override
  void initState() {
    super.initState();
    para.text = widget.t.data ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        title: Column(
          children: [
            Text(
              widget.t.todoName,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.t.todoStatus == '1' ? "Completed" : "Incomplete",
              style: TextStyle(
                color: widget.t.todoStatus == '0' ? Colors.red : Colors.green,
                fontSize: 10,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, widget.t);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context, 'delete');
                },
                icon: Icon(Icons.delete, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  widget.t.data = para.text;
                  final box = Hive.box<TodoModel>('todos');
                  final key = box.keys.firstWhere(
                    (k) => box.get(k)!.todoId == widget.t.todoId,
                  );
                  box.put(key, widget.t);
                  Navigator.pop(context, widget.t);
                },
                icon: Icon(Icons.save, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Task Details..",
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: para,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
