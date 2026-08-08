import 'package:equatable/equatable.dart';
import '../../data/model/site_model.dart';

abstract class SiteState extends Equatable {
  const SiteState();

  @override
  List<Object?> get props => [];
}

class SiteInitial extends SiteState {}

class SiteLoading extends SiteState {}

class SiteLoaded extends SiteState {
  final SiteModel site;

  const SiteLoaded({required this.site});

  @override
  List<Object?> get props => [site];
}

class SiteError extends SiteState {
  final String message;

  const SiteError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SiteLocationUpdated extends SiteState {}
