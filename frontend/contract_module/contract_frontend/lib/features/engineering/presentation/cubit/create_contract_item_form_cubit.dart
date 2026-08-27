import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CreateContractItemFormCubit extends Cubit<void> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descEnController = TextEditingController();
  final TextEditingController descArController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  CreateContractItemFormCubit() : super(null);

  @override
  Future<void> close() {
    descEnController.dispose();
    descArController.dispose();
    quantityController.dispose();
    priceController.dispose();
    return super.close();
  }
}
