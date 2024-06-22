import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const TodoListPage(title: 'Todo List'),
        '/createTodo': (context) => const CreateTodoPage(),
      },
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.title});

  final String title;

  @override
  State<TodoListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TodoListPage> {
  late List<List<String>> listTodo = [];

  @override
  void initState() {
    listTodo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void navCreateTodoPage() async {
      final navData = await Navigator.pushNamed(context, '/createTodo');

      if (navData != null) {
        List<String> todoData = navData.toString().split('|');
        listTodo.add(todoData);
        setState(() {
          listTodo;
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: navCreateTodoPage,
                child:
                    const Text('Создать Todo', style: TextStyle(fontSize: 20))),
            const SizedBox(
              width: 1000,
              height: 10,
            ),
            const Text('Список Todo:', style: TextStyle(fontSize: 30)),
            listTodo.isEmpty
                ? const Text('Todo еще не созданы.',
                    style: TextStyle(fontSize: 20))
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: listTodo.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<String> dataTodo = listTodo[index];
                      return Todo(
                          Todo.getLastID() + 1, dataTodo[0], dataTodo[1]);
                    },
                  )
          ],
        ));
  }
}

class Todo extends StatelessWidget {
  final String title;
  final String description;
  final int _ID;

  static int lastID = 0;

  Todo(this._ID, this.title, this.description, {Key? key}) : super(key: key) {
    lastID = _ID;
  }

  static int getLastID() {
    return lastID;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 22)),
        Text(description, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 5)
      ],
    );
  }
}

class CreateTodoPage extends StatelessWidget {
  const CreateTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    void cancelButton() {
      Navigator.of(context).pop("");
    }

    void saveButton() {
      String title = titleController.text;
      String desc = descriptionController.text;

      if (title != '') {
        Navigator.of(context).pop("$title|$desc");
      } else {
        cancelButton();
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Создание Todo'),
        ),
        body: Column(children: [
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  const Text('Название: ', style: TextStyle(fontSize: 20)),
                  TextField(
                    controller: titleController,
                  ),
                  const Text('Описание: ', style: TextStyle(fontSize: 20)),
                  TextField(
                    controller: descriptionController,
                  )
                ],
              )),
          Expanded(
            flex: 3,
            child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: cancelButton,
                      child:
                          const Text('Отмена', style: TextStyle(fontSize: 20))),
                  TextButton(
                      onPressed: saveButton,
                      child: const Text('Сохранить',
                          style: TextStyle(fontSize: 20))),
                ]),
          ),
        ]));
  }
}
