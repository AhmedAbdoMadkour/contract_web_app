class ContractTermModel {
  final String id;
  final String title;
  final String content;

  ContractTermModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory ContractTermModel.fromJson(Map<String, dynamic> json) {
    return ContractTermModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}

class DrawingAttachmentModel {
  final String id;
  final String fileName;
  final String fileUrl;

  DrawingAttachmentModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
  });

  factory DrawingAttachmentModel.fromJson(Map<String, dynamic> json) {
    return DrawingAttachmentModel(
      id: json['id']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
    };
  }
}

class ContractItemModel {
  final String id;
  final String description;
  final double quantity;
  final double price;

  ContractItemModel({
    required this.id,
    required this.description,
    required this.quantity,
    required this.price,
  });

  factory ContractItemModel.fromJson(Map<String, dynamic> json) {
    return ContractItemModel(
      id: json['id']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'quantity': quantity,
      'price': price,
    };
  }
}

class ContractModel {
  final String id;
  final String vendorName;
  final String status;
  final List<ContractItemModel> items;
  final List<ContractTermModel> terms;
  final List<DrawingAttachmentModel> drawings;

  ContractModel({
    required this.id,
    required this.vendorName,
    required this.status,
    required this.items,
    required this.terms,
    required this.drawings,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id']?.toString() ?? '',
      vendorName: json['vendorName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ContractItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      terms: (json['terms'] as List<dynamic>?)
              ?.map((term) => ContractTermModel.fromJson(term as Map<String, dynamic>))
              .toList() ??
          [],
      drawings: (json['drawings'] as List<dynamic>?)
              ?.map((drawing) => DrawingAttachmentModel.fromJson(drawing as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorName': vendorName,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'terms': terms.map((term) => term.toJson()).toList(),
      'drawings': drawings.map((drawing) => drawing.toJson()).toList(),
    };
  }
}
