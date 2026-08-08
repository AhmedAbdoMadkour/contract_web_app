import 'package:equatable/equatable.dart';

class EngineeringProjectModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String status;
  final DateTime startDate;

  const EngineeringProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.startDate,
  });

  factory EngineeringProjectModel.fromJson(Map<String, dynamic> json) {
    return EngineeringProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'startDate': startDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, description, status, startDate];
}
