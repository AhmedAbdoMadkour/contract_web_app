import 'template_clause_model.dart';

class DocumentTemplateModel {
  final String id;
  final String name;
  final String description;
  final List<TemplateClauseModel> clauses;

  DocumentTemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.clauses,
  });

  factory DocumentTemplateModel.fromJson(Map<String, dynamic> json) {
    return DocumentTemplateModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      clauses: (json['clauses'] as List<dynamic>?)
              ?.map((e) => TemplateClauseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'clauses': clauses.map((e) => e.toJson()).toList(),
    };
  }
}
