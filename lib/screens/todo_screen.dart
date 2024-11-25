import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_structured/bloc/todo_bloc.dart';
import 'package:todo_structured/screens/addtodo_screen.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();
    // Trigger the FetchTodos event
    BlocProvider.of<TodoBloc>(context).add(FetchTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              if (state.todos.isEmpty) {
                return const Center(child: Text('No Todos Available'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<TodoBloc>(context).add(FetchTodos());
                },
                child: ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final item = state.todos[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      onTap: () {
                        _showTodoDetailsModal(context, item);
                      },
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == "delete") {
                            _showDeleteConfirmationDialog(item['_id']);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            )
                          ];
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (state is TodoError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigatetoAddPage,
        label: const Text("Add"),
      ),
    );
  }

  void navigatetoAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<TodoBloc>(context),
        child: const AddTodoPage(),
      ),
    );
    Navigator.push(context, route);
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Todo"),
          content: const Text("Are you sure you want to delete this todo?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<TodoBloc>(context).add(DeleteTodo(id: id));
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
 void _showTodoDetailsModal(BuildContext context, Map<String, dynamic> todo) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(50),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // This ensures the bottom sheet is not full screen
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo['title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              todo['description'],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal sheet
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}
