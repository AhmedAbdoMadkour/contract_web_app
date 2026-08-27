import 'package:equatable/equatable.dart';

class RoleModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> permissions;

  const RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => (e is Map) ? e['name']?.toString() ?? '' : e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions,
    };
  }

  @override
  List<Object?> get props => [id, name, description, permissions];
}
