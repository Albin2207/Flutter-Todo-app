import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_structured/bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isEmpty || description.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in both fields')),
                );
                return; // Don't proceed if validation fails
              }
              // Dispatch AddTodo event when button is pressed
              BlocProvider.of<TodoBloc>(context).add(AddTodo(
                title: title,
                description: description,
              ));

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todo added successfully')),
              );
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
