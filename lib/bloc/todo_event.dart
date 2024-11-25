part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class FetchTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  final String description;

  const AddTodo({required this.title, required this.description});

  @override
  List<Object> get props => [title, description];
}

class DeleteTodo extends TodoEvent {
  final String id;

  const DeleteTodo({required this.id});

  @override
  List<Object> get props => [id];
}