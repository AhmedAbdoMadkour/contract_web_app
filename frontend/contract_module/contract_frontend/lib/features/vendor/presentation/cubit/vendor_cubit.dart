import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/vendor_repository.dart';
import '../../data/model/create_vendor_model.dart';
import '../../data/model/update_vendor_model.dart';
import 'vendor_state.dart';

class VendorCubit extends Cubit<VendorState> {
  final VendorRepository _repository;

  VendorCubit(this._repository) : super(VendorInitial());

  Future<void> getVendors({int page = 1, int pageSize = 10}) async {
    emit(VendorLoading());
    final result = await _repository.getVendors(page: page, pageSize: pageSize);
    result.fold(
      (failure) => emit(VendorError(failure.message)),
      (vendors) => emit(VendorLoaded(vendors)),
    );
  }

  Future<void> createVendor(CreateVendorModel request) async {
    emit(VendorLoading());
    final result = await _repository.createVendor(request);
    result.fold(
      (failure) => emit(VendorError(failure.message)),
      (_) {
        emit(const VendorOperationSuccess('Vendor created successfully.'));
        getVendors(); // Refresh list
      },
    );
  }

  Future<void> updateVendor(String id, UpdateVendorModel request) async {
    emit(VendorLoading());
    final result = await _repository.updateVendor(id, request);
    result.fold(
      (failure) => emit(VendorError(failure.message)),
      (_) {
        emit(const VendorOperationSuccess('Vendor updated successfully.'));
        getVendors(); // Refresh list
      },
    );
  }

  Future<void> deleteVendor(String id) async {
    emit(VendorLoading());
    final result = await _repository.deleteVendor(id);
    result.fold(
      (failure) => emit(VendorError(failure.message)),
      (_) {
        emit(const VendorOperationSuccess('Vendor deleted successfully.'));
        getVendors(); // Refresh list
      },
    );
  }
}
