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
  final String vendorName;
  final String status;
  final List<ContractItemModel> items;

  ContractModel({
    required this.vendorName,
    required this.status,
    required this.items,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      vendorName: json['vendorName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ContractItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorName': vendorName,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
