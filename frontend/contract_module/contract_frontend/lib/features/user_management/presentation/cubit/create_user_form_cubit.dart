import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class CreateUserFormState {
  final String selectedRole;
  final Uint8List? avatarBytes;
  final String? avatarFileName;
  final Map<String, Map<String, bool>> permissions;
  final int updateTrigger;

  CreateUserFormState({
    this.selectedRole = 'analyst',
    this.avatarBytes,
    this.avatarFileName,
    required this.permissions,
    this.updateTrigger = 0,
  });

  CreateUserFormState copyWith({
    String? selectedRole,
    Uint8List? avatarBytes,
    String? avatarFileName,
    Map<String, Map<String, bool>>? permissions,
    int? updateTrigger,
  }) {
    return CreateUserFormState(
      selectedRole: selectedRole ?? this.selectedRole,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      avatarFileName: avatarFileName ?? this.avatarFileName,
      permissions: permissions ?? this.permissions,
      updateTrigger: updateTrigger ?? this.updateTrigger,
    );
  }
}

class CreateUserFormCubit extends Cubit<CreateUserFormState> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CreateUserFormCubit() : super(CreateUserFormState(
    permissions: {
      'Financial Dashboard': {'View': false, 'Edit': false, 'Admin': false},
      'Client Records': {'View': true, 'Edit': false, 'Admin': false},
      'System Settings': {'View': false, 'Edit': false, 'Admin': false},
    },
  ));

  Future<void> pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      emit(state.copyWith(
        avatarBytes: result.files.first.bytes,
        avatarFileName: result.files.first.name,
      ));
    }
  }

  void setRole(String role) {
    emit(state.copyWith(selectedRole: role));
  }

  void togglePermission(String module, String access, bool value) {
    final newPermissions = Map<String, Map<String, bool>>.from(state.permissions);
    newPermissions[module] = Map<String, bool>.from(newPermissions[module]!);
    newPermissions[module]![access] = value;
    emit(state.copyWith(permissions: newPermissions, updateTrigger: state.updateTrigger + 1));
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    emit(CreateUserFormState(
      permissions: {
        'Financial Dashboard': {'View': false, 'Edit': false, 'Admin': false},
        'Client Records': {'View': false, 'Edit': false, 'Admin': false},
        'System Settings': {'View': false, 'Edit': false, 'Admin': false},
      },
    ));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
