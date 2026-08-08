import 'package:equatable/equatable.dart';
import '../../data/model/engineering_project_model.dart';
import '../../data/model/contract_model.dart';

abstract class EngineeringState extends Equatable {
  const EngineeringState();

  @override
  List<Object?> get props => [];
}

class EngineeringInitial extends EngineeringState {}

class EngineeringLoading extends EngineeringState {}

class EngineeringProjectsLoaded extends EngineeringState {
  final List<EngineeringProjectModel> projects;
  final List<ContractModel>? contracts;

  const EngineeringProjectsLoaded(this.projects, {this.contracts});

  @override
  List<Object?> get props => [projects, contracts];
}

class EngineeringProjectLoaded extends EngineeringState {
  final EngineeringProjectModel project;

  const EngineeringProjectLoaded(this.project);

  @override
  List<Object?> get props => [project];
}

class EngineeringProjectCreated extends EngineeringState {
  final EngineeringProjectModel project;

  const EngineeringProjectCreated(this.project);

  @override
  List<Object?> get props => [project];
}

class EngineeringError extends EngineeringState {
  final String message;

  const EngineeringError(this.message);

  @override
  List<Object?> get props => [message];
}

class EngineeringStatusUpdated extends EngineeringState {
  final String id;
  final String status;

  const EngineeringStatusUpdated({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

class EngineeringContractsLoaded extends EngineeringState {
  final List<ContractModel> contracts;
  final List<EngineeringProjectModel> projects;

  const EngineeringContractsLoaded(this.contracts, this.projects);

  @override
  List<Object?> get props => [contracts, projects];
}
