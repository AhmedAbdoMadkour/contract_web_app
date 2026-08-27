import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CreateEngineeringProjectFormState {
  final DateTime? startDate;
  final DateTime? endDate;

  CreateEngineeringProjectFormState({this.startDate, this.endDate});

  CreateEngineeringProjectFormState copyWith({DateTime? startDate, DateTime? endDate}) {
    return CreateEngineeringProjectFormState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class CreateEngineeringProjectFormCubit extends Cubit<CreateEngineeringProjectFormState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  CreateEngineeringProjectFormCubit() : super(CreateEngineeringProjectFormState());

  void setStartDate(DateTime date) {
    emit(state.copyWith(startDate: date));
  }
  
  void setEndDate(DateTime date) {
    emit(state.copyWith(endDate: date));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descController.dispose();
    return super.close();
  }
}
