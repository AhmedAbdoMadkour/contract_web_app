import 'package:equatable/equatable.dart';

class UpdateVendorModel extends Equatable {
  final String? name;
  final String? contactPerson;
  final String? email;
  final String? phone;

  const UpdateVendorModel({
    this.name,
    this.contactPerson,
    this.email,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (contactPerson != null) data['contactPerson'] = contactPerson;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    return data;
  }

  @override
  List<Object?> get props => [name, contactPerson, email, phone];
}
