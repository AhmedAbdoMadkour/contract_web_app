class TemplateItemModel {
  final String id;
  final String type;
  final String name; // Or Number
  final String content;

  TemplateItemModel({
    required this.id,
    required this.type,
    required this.name,
    required this.content,
  });

  factory TemplateItemModel.fromJson(Map<String, dynamic> json) {
    return TemplateItemModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'content': content,
    };
  }
}

class ContractTemplateModel {
  final String id;
  final String title;
  final String status;
  final List<TemplateItemModel> items;
  final DateTime createdAt;

  ContractTemplateModel({
    required this.id,
    required this.title,
    required this.status,
    required this.items,
    required this.createdAt,
  });

  factory ContractTemplateModel.fromJson(Map<String, dynamic> json) {
    return ContractTemplateModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? 'Draft',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TemplateItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ContractTemplateModel copyWith({
    String? id,
    String? title,
    String? status,
    List<TemplateItemModel>? items,
    DateTime? createdAt,
  }) {
    return ContractTemplateModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
