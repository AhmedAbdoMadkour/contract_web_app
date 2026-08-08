import 'package:equatable/equatable.dart';
import '../../data/model/vendor_model.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object?> get props => [];
}

class VendorInitial extends VendorState {}

class VendorLoading extends VendorState {}

class VendorLoaded extends VendorState {
  final List<VendorModel> vendors;

  const VendorLoaded(this.vendors);

  @override
  List<Object?> get props => [vendors];
}

class VendorOperationSuccess extends VendorState {
  final String message;

  const VendorOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class VendorError extends VendorState {
  final String message;

  const VendorError(this.message);

  @override
  List<Object?> get props => [message];
}
