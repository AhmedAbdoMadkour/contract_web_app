import 'package:equatable/equatable.dart';

class CreateVendorModel extends Equatable {
  final String name;
  final String contactPerson;
  final String email;
  final String phone;

  const CreateVendorModel({
    required this.name,
    required this.contactPerson,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contactPerson': contactPerson,
      'email': email,
      'phone': phone,
    };
  }

  @override
  List<Object?> get props => [name, contactPerson, email, phone];
}
