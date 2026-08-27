import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CreateContractFormState {
  final String? projectId;
  final String? vendorId;

  CreateContractFormState({this.projectId, this.vendorId});

  CreateContractFormState copyWith({String? projectId, String? vendorId}) {
    return CreateContractFormState(
      projectId: projectId ?? this.projectId,
      vendorId: vendorId ?? this.vendorId,
    );
  }
}

class CreateContractFormCubit extends Cubit<CreateContractFormState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController termsController = TextEditingController();

  CreateContractFormCubit() : super(CreateContractFormState());

  void setProject(String projectId) {
    emit(state.copyWith(projectId: projectId));
  }
  
  void setVendor(String vendorId) {
    emit(state.copyWith(vendorId: vendorId));
  }

  @override
  Future<void> close() {
    termsController.dispose();
    return super.close();
  }
}
