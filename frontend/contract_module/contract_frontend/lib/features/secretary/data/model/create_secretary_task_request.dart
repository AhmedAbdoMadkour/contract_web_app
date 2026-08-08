class CreateSecretaryTaskRequest {
  final String title;
  final String description;
  final DateTime? dueDate;

  CreateSecretaryTaskRequest({
    required this.title,
    required this.description,
    this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    };
  }
}
