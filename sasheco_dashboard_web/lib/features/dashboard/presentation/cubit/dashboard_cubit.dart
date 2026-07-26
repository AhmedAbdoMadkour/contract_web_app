import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;

  DashboardCubit(this._repository) : super(const DashboardInitial());

  Future<void> loadDashboardMetrics() async {
    emit(const DashboardLoading());

    final result = await _repository.getDashboardMetrics();

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (metrics) => emit(DashboardLoaded(metrics)),
    );
  }
}
