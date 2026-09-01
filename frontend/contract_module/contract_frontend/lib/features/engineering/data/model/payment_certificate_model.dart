import 'package:equatable/equatable.dart';

class PaymentCertificateModel extends Equatable {
  final String id;
  final String contractId;
  final String vendorName;
  final String projectName;
  final DateTime date;
  final String certificateNumber;
  final List<PaymentCertificateItemModel> items;
  final double totalPrevious;
  final double currentTotal;
  final double netPayable;
  final PaymentCertificateApprovalModel? approval;

  const PaymentCertificateModel({
    required this.id,
    required this.contractId,
    required this.vendorName,
    required this.projectName,
    required this.date,
    required this.certificateNumber,
    required this.items,
    required this.totalPrevious,
    required this.currentTotal,
    required this.netPayable,
    this.approval,
  });

  factory PaymentCertificateModel.fromJson(Map<String, dynamic> json) {
    return PaymentCertificateModel(
      id: json['id'] as String? ?? '',
      contractId: json['contractId'] as String? ?? '',
      vendorName: json['vendorName'] as String? ?? '',
      projectName: json['projectName'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      certificateNumber: json['certificateNumber'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => PaymentCertificateItemModel.fromJson(
                  item as Map<String, dynamic>))
              .toList() ??
          const [],
      totalPrevious: (json['totalPrevious'] as num?)?.toDouble() ?? 0.0,
      currentTotal: (json['currentTotal'] as num?)?.toDouble() ?? 0.0,
      netPayable: (json['netPayable'] as num?)?.toDouble() ?? 0.0,
      approval: json['approval'] != null
          ? PaymentCertificateApprovalModel.fromJson(
              json['approval'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractId': contractId,
      'vendorName': vendorName,
      'projectName': projectName,
      'date': date.toIso8601String(),
      'certificateNumber': certificateNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrevious': totalPrevious,
      'currentTotal': currentTotal,
      'netPayable': netPayable,
      'approval': approval?.toJson(),
    };
  }

  PaymentCertificateModel copyWith({
    String? id,
    String? contractId,
    String? vendorName,
    String? projectName,
    DateTime? date,
    String? certificateNumber,
    List<PaymentCertificateItemModel>? items,
    double? totalPrevious,
    double? currentTotal,
    double? netPayable,
    PaymentCertificateApprovalModel? approval,
  }) {
    return PaymentCertificateModel(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      vendorName: vendorName ?? this.vendorName,
      projectName: projectName ?? this.projectName,
      date: date ?? this.date,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      items: items ?? this.items,
      totalPrevious: totalPrevious ?? this.totalPrevious,
      currentTotal: currentTotal ?? this.currentTotal,
      netPayable: netPayable ?? this.netPayable,
      approval: approval ?? this.approval,
    );
  }

  @override
  List<Object?> get props => [
        id,
        contractId,
        vendorName,
        projectName,
        date,
        certificateNumber,
        items,
        totalPrevious,
        currentTotal,
        netPayable,
        approval,
      ];
}

class PaymentCertificateItemModel extends Equatable {
  final String id;
  final String description;
  final double unitPrice;
  final double quantityPrevious;
  final double quantityCurrent;
  final double quantityTotal;

  const PaymentCertificateItemModel({
    required this.id,
    required this.description,
    required this.unitPrice,
    required this.quantityPrevious,
    required this.quantityCurrent,
    required this.quantityTotal,
  });

  // Computed properties
  double get totalPrevious => quantityPrevious * unitPrice;
  double get totalCurrent => quantityCurrent * unitPrice;
  double get totalAmount => quantityTotal * unitPrice;

  factory PaymentCertificateItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentCertificateItemModel(
      id: json['id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantityPrevious: (json['quantityPrevious'] as num?)?.toDouble() ?? 0.0,
      quantityCurrent: (json['quantityCurrent'] as num?)?.toDouble() ?? 0.0,
      quantityTotal: (json['quantityTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'unitPrice': unitPrice,
      'quantityPrevious': quantityPrevious,
      'quantityCurrent': quantityCurrent,
      'quantityTotal': quantityTotal,
    };
  }

  PaymentCertificateItemModel copyWith({
    String? id,
    String? description,
    double? unitPrice,
    double? quantityPrevious,
    double? quantityCurrent,
    double? quantityTotal,
  }) {
    return PaymentCertificateItemModel(
      id: id ?? this.id,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      quantityPrevious: quantityPrevious ?? this.quantityPrevious,
      quantityCurrent: quantityCurrent ?? this.quantityCurrent,
      quantityTotal: quantityTotal ?? this.quantityTotal,
    );
  }

  @override
  List<Object?> get props => [
        id,
        description,
        unitPrice,
        quantityPrevious,
        quantityCurrent,
        quantityTotal,
      ];
}

class PaymentCertificateApprovalModel extends Equatable {
  final bool isApprovedByEngineering;
  final bool isApprovedByFinance;
  final String comments;

  const PaymentCertificateApprovalModel({
    required this.isApprovedByEngineering,
    required this.isApprovedByFinance,
    required this.comments,
  });

  factory PaymentCertificateApprovalModel.fromJson(Map<String, dynamic> json) {
    return PaymentCertificateApprovalModel(
      isApprovedByEngineering:
          json['isApprovedByEngineering'] as bool? ?? false,
      isApprovedByFinance: json['isApprovedByFinance'] as bool? ?? false,
      comments: json['comments'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isApprovedByEngineering': isApprovedByEngineering,
      'isApprovedByFinance': isApprovedByFinance,
      'comments': comments,
    };
  }

  PaymentCertificateApprovalModel copyWith({
    bool? isApprovedByEngineering,
    bool? isApprovedByFinance,
    String? comments,
  }) {
    return PaymentCertificateApprovalModel(
      isApprovedByEngineering:
          isApprovedByEngineering ?? this.isApprovedByEngineering,
      isApprovedByFinance: isApprovedByFinance ?? this.isApprovedByFinance,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props =>
      [isApprovedByEngineering, isApprovedByFinance, comments];
}
