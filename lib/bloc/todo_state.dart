part of 'todo_bloc.dart';

@immutable
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<dynamic> todos;

  const TodoLoaded(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodoAdded extends TodoState {}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object> get props => [message];
}