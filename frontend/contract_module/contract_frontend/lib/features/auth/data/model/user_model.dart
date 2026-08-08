import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String token;
  final String roleId;
  final String position;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.roleId,
    required this.position,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Note: The API returns `user` object and a separate `token`.
    // In AuthRepository, they might be merged, so we check for both.
    final userObj = json['user'] as Map<String, dynamic>? ?? json;
    
    return UserModel(
      id: userObj['id'] as String? ?? '',
      email: userObj['employeeNumber'] as String? ?? userObj['email'] as String? ?? '',
      name: userObj['name'] as String? ?? '',
      token: json['token'] as String? ?? '',
      roleId: userObj['roleId'] as String? ?? '',
      position: userObj['position'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'roleId': roleId,
      'position': position,
    };
  }

  @override
  List<Object?> get props => [id, email, name, token, roleId, position];
}
