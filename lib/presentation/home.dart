import 'package:flutter/material.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/presentation/task.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formkey = GlobalKey<FormState>();
  String taskFilter = 'all';

  final task = TextEditingController();
  late Box<TodoModel> todobox;

  String editToDoTaskID = '0';
  String font = "Times New Roman";

  List<TodoModel> todoList = [];
  List<TodoModel> get filteredList {
    switch (taskFilter) {
      case 'complete':
        return todoList.where((t) => t.todoStatus == '1').toList();
      case 'incomplete':
        return todoList.where((t) => t.todoStatus == '0').toList();
      default:
        return todoList;
    }
  }

  int counter = 0;

  Color pink = const Color.fromARGB(255, 232, 146, 175);
  int editFlag = 0;

  @override
  void initState() {
    super.initState();
    todobox = Hive.box<TodoModel>('todos');
    todoList = todobox.values.toList().reversed.toList();
    if (todoList.isNotEmpty) {
      counter = todoList
          .map((e) => int.tryParse(e.todoId) ?? 0)
          .reduce((a, b) => a > b ? a : b);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        leading: Image(image: AssetImage("assets/hello-kitty.gif")),
        title: Text(
          "To Do List",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Times New Roman",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Value";
                              }
                              return null;
                            },
                            controller: task,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: pink),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: pink),
                              ),
                              hintText: "Enter Your Task Here",
                              hintStyle: TextStyle(fontFamily: font),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    counter = counter + 1;
                                    TodoModel t = TodoModel(
                                      todoId: counter.toString(),
                                      todoName: task.text,
                                      todoStatus: "0",
                                    );
                                    setState(() {
                                      if (editFlag == 0) {
                                        addtodo(t);
                                        task.text = '';
                                      } else {
                                        editTodoTask();
                                        editFlag = 0;
                                        task.text = '';
                                      }
                                      task.clear();
                                    });
                                  }
                                },
                                icon: CircleAvatar(
                                  backgroundColor: pink,
                                  child: Icon(
                                    editFlag == 0 ? Icons.add : Icons.save,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: editFlag == 0 ? false : true,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      editFlag = 0;
                                      task.text = '';
                                      editToDoTaskID = '';
                                    });
                                  },
                                  icon: CircleAvatar(
                                    backgroundColor: pink,
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              taskFilter = 'all';
                              todoList = todoList;
                            });
                          },
                          icon: Text("All", style: TextStyle(color: pink)),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              taskFilter = 'incomplete';
                            });
                          },
                          icon: Text(
                            "Incomplete Tasks",
                            style: TextStyle(color: pink),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              taskFilter = 'complete';
                            });
                          },
                          icon: Text(
                            "Complete Tasks",
                            style: TextStyle(color: pink),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // height: MediaQuery.of(context).size.height * .8,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  TodoModel todo = filteredList[index];
                  return Visibility(
                    visible: true,
                    child: ListTile(
                      onTap: () async {
                        final update = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Task(t: todo),
                          ),
                        );
                        if (update is TodoModel) {
                          setState(() {
                            todo = update;
                          });
                        } else if (update == 'delete') {
                          setState(() {
                            deletetodo(todo.todoId);
                          });
                        }
                      },
                      leading: Text(
                        '${index + 1}'.toString(),
                        style: TextStyle(fontFamily: font, fontSize: 15),
                      ),
                      title: Text(
                        todo.todoName,
                        style: TextStyle(fontFamily: font),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            todo.todoStatus == '0'
                                ? 'Status : Incomplete'
                                : 'Status : Completed',
                            style: TextStyle(
                              color: todo.todoStatus == '0'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                changeStatus(todo.todoId, todo.todoStatus);
                              });
                            },
                            icon: Icon(
                              todo.todoStatus == '0'
                                  ? Icons.check_box_outline_blank
                                  : Icons.fact_check_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                deletetodo(todo.todoId);
                              });
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                editFlag = 1;
                                task.text = todo.todoName;
                                editToDoTaskID = todo.todoId;
                              });
                            },

                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: filteredList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addtodo(TodoModel t) {
    todobox.add(t);
    todoList = todobox.values.toList().reversed.toList();
  }

  void deletetodo(String todoId) {
    final index = todoList.indexWhere((test) => test.todoId == todoId);
    if (index != -1) {
      final key = todobox.keyAt(todoList.length - index - 1);
      todobox.delete(key);
      todoList = todobox.values.toList().reversed.toList();
    }
  }

  void changeStatus(String todoID, String todoStatus) {
    String newStatus = todoStatus == '1' ? '0' : '1';
    final index = todoList.indexWhere((test) => test.todoId == todoID);
    if (index != -1) {
      final update = todoList[index];
      update.todoStatus = newStatus;
      final key = todobox.keyAt(todoList.length - index - 1);
      todobox.put(key, update);
      todoList = todobox.values.toList().reversed.toList();
    }
  }

  void editTodoTask() {
    final index = todoList.indexWhere((test) => test.todoId == editToDoTaskID);
    if (index != -1) {
      final key = todobox.keyAt(todoList.length - index - 1);
      final t = todoList[index];
      t.todoName = task.text;
      todobox.put(key, t);
      todoList = todobox.values.toList().reversed.toList();
    }
  }
}
