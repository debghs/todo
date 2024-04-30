import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme',
      debugShowCheckedModeBanner: false,

      /* light theme settings */
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        brightness: Brightness.light,
        dividerColor: Colors.white54,
        scaffoldBackgroundColor: Colors.white,

      ),

      /* Dark theme settings */
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        dividerColor: Colors.black12,
        scaffoldBackgroundColor: Colors.black,

      ),

      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme */
      themeMode: ThemeMode.system,
      home: _ToDoHomePage(),
    );
  }
}

class _ToDoHomePage extends StatefulWidget {

  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<_ToDoHomePage> {
  List<String> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTodos = prefs.getStringList('todos');
    if (savedTodos != null) {
      setState(() {
        todos = savedTodos;
      });
    }
  }

  Future<void> _saveTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    //print('Saving Todos: $todos');
    await prefs.setStringList('todos', todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todos',
         style: TextStyle(fontStyle:FontStyle.italic, color: Color.fromARGB(255, 249, 160, 27), fontSize: 43)),
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: const Color.fromARGB(255, 249, 160, 27),
            height: 4.0,
          )
        ) 
      ),
body: ListView.builder(
  itemCount: todos.length,
  padding: const EdgeInsets.only(top: 15,left: 10,right: 10),
  itemBuilder: (context, index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 52, 51, 51), // Grey background color
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: ListTile(
        title: Text(
          todos[index],
          style: const TextStyle(
            fontStyle:FontStyle.italic, 
            color:  Color.fromARGB(255, 249, 160, 27),
            fontSize: 20,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete,color: Colors.white),
          onPressed: () {
            setState(() {
              todos.removeAt(index);
              _saveTodoList(); // Save todo list after removal
            });
          },
        ),
      ),
    );
  },
),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoDialog(context);
        },
        backgroundColor: const Color.fromARGB(255, 249, 160, 27),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Make it circular
          ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodoDialog(BuildContext context) {
    TextEditingController todoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add ToDo'),
          content: TextField(
            controller: todoController,
            decoration: const InputDecoration(hintText: 'Enter ToDo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String todo = todoController.text.trim();
                if (todo.isNotEmpty) {
                  setState(() {
                    todos.add(todo);
                    _saveTodoList(); // Save todo list after addition
                  });
                  todoController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
