import 'dart:convert';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final String? lastActive;
  final Uint8List? avatarBytes;
  final String? password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
    this.lastActive,
    this.avatarBytes,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String parsedName = json['name'] as String? ?? '';
    if (parsedName.isEmpty && json.containsKey('firstName') && json.containsKey('lastName')) {
      parsedName = '${json['firstName']} ${json['lastName']}';
    }
    
    Uint8List? avatarBytes;
    if (json.containsKey('avatarBase64') && json['avatarBase64'] != null) {
      try {
        final String b64 = json['avatarBase64'];
        if (b64.isNotEmpty) {
           String cleanB64 = b64.split(',').last.replaceAll(RegExp(r'\s+'), '');
           // Add padding if necessary
           while (cleanB64.length % 4 != 0) {
             cleanB64 += '=';
           }
           avatarBytes = base64Decode(cleanB64);
        }
      } catch (e) {
        print('Error decoding avatarBase64: $e');
        // Ignore decode error
      }
    }

    return UserModel(
      id: json['id'] as String? ?? '',
      name: parsedName,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      isActive: json['isActive'] ?? true,
      lastActive: json['lastActive'],
      avatarBytes: avatarBytes,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isActive,
    String? lastActive,
    Uint8List? avatarBytes,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastActive: lastActive ?? this.lastActive,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    final names = name.split(' ');
    final firstName = names.isNotEmpty ? names.first : '';
    final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';
    
    String? avatarBase64;
    if (avatarBytes != null) {
      avatarBase64 = base64Encode(avatarBytes!);
    }

    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'isActive': isActive,
      'password': password ?? '',
      'avatarBase64': avatarBase64,
    };
  }

  @override
  List<Object?> get props => [id, name, email, role, isActive, avatarBytes];
}
