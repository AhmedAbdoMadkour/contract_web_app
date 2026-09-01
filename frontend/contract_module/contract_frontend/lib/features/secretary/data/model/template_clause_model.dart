class TemplateClauseModel {
  final String id;
  final String title;
  final String content;
  final bool isMandatory;

  TemplateClauseModel({
    required this.id,
    required this.title,
    required this.content,
    this.isMandatory = false,
  });

  factory TemplateClauseModel.fromJson(Map<String, dynamic> json) {
    return TemplateClauseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isMandatory: json['isMandatory'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isMandatory': isMandatory,
    };
  }
}
