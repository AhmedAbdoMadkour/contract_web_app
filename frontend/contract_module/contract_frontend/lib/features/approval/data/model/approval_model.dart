class ApprovalModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String requestedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ApprovalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.requestedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory ApprovalModel.fromJson(Map<String, dynamic> json) {
    return ApprovalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      requestedBy: json['requestedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'requestedBy': requestedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
