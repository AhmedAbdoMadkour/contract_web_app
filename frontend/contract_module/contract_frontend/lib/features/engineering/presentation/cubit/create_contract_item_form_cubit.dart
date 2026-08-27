import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CreateContractItemFormCubit extends Cubit<void> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  CreateContractItemFormCubit() : super(null);

  @override
  Future<void> close() {
    itemCodeController.dispose();
    itemNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    return super.close();
  }
}
