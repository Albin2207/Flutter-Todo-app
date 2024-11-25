import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/api_repositories.dart';


part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final ApiService apiService;

  TodoBloc(this.apiService) : super(TodoLoading()) {
    on<FetchTodos>(_onFetchTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onFetchTodos(FetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await apiService.fetchTodos(1, 20);
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to load todos'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final success = await apiService.addTodo(event.title, event.description);
      if (success) {
        emit(TodoAdded());
        add(FetchTodos());  
      } else {
        emit(TodoError('Failed to add todo'));
      }
    } catch (e) {
      emit(TodoError('Failed to add todo'));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      final success = await apiService.deleteTodo(event.id);
      if (success) {
        add(FetchTodos());  
      } else {
        emit(TodoError('Failed to delete todo'));
      }
    } catch (e) {
      emit(TodoError('Failed to delete todo: ${e.toString()}'));
    }
  }
}
