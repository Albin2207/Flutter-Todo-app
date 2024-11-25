import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_structured/screens/splash_screen.dart';
import 'bloc/todo_bloc.dart';
import 'repositories/api_repositories.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc(ApiService.instance)
        ),
      ],
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}