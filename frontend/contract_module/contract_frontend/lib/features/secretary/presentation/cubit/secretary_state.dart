import 'package:equatable/equatable.dart';
import '../../data/model/secretary_inbox_item_model.dart';
import '../../data/model/secretary_task_model.dart';

abstract class SecretaryState extends Equatable {
  const SecretaryState();

  @override
  List<Object?> get props => [];
}

class SecretaryInitial extends SecretaryState {}

class SecretaryLoading extends SecretaryState {}

class SecretaryInboxLoaded extends SecretaryState {
  final List<SecretaryInboxItemModel> items;

  const SecretaryInboxLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class SecretaryTasksLoaded extends SecretaryState {
  final List<SecretaryTaskModel> tasks;

  const SecretaryTasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class SecretaryTaskOperationSuccess extends SecretaryState {
  final String message;

  const SecretaryTaskOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SecretaryError extends SecretaryState {
  final String message;

  const SecretaryError(this.message);

  @override
  List<Object?> get props => [message];
}
