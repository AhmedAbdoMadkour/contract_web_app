import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/site_repository.dart';
import 'site_state.dart';

class SiteCubit extends Cubit<SiteState> {
  final SiteRepository repository;

  SiteCubit({required this.repository}) : super(SiteInitial());

  Future<void> fetchSiteDashboard() async {
    emit(SiteLoading());
    final result = await repository.getSiteDashboard();
    
    result.fold(
      (failure) => emit(SiteError(message: failure.message)),
      (site) => emit(SiteLoaded(site: site)),
    );
  }
  Future<void> updateSiteLocation(String siteId, double lat, double lng) async {
    emit(SiteLoading());
    final result = await repository.updateSiteLocation(siteId, lat, lng);
    
    result.fold(
      (failure) => emit(SiteError(message: failure.message)),
      (_) => emit(SiteLocationUpdated()),
    );
  }
}
