class ContractModel {
  final String id;
  final String title;
  final String clientName;
  final String status;
  final double amount;

  ContractModel({
    required this.id,
    required this.title,
    required this.clientName,
    required this.status,
    required this.amount,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      clientName: json['clientName'] ?? '',
      status: json['status'] ?? 'Draft',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'clientName': clientName,
      'status': status,
      'amount': amount,
    };
  }
  
  ContractModel copyWith({
    String? id,
    String? title,
    String? clientName,
    String? status,
    double? amount,
  }) {
    return ContractModel(
      id: id ?? this.id,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      amount: amount ?? this.amount,
    );
  }
}
