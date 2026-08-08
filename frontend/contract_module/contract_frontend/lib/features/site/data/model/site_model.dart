import 'package:equatable/equatable.dart';

class ContractSummaryModel extends Equatable {
  final String contractId;
  final String vendor;
  final String type;
  final String value;

  const ContractSummaryModel({
    required this.contractId,
    required this.vendor,
    required this.type,
    required this.value,
  });

  factory ContractSummaryModel.fromJson(Map<String, dynamic> json) {
    return ContractSummaryModel(
      contractId: json['contractId'] as String? ?? '',
      vendor: json['vendor'] as String? ?? '',
      type: json['type'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractId': contractId,
      'vendor': vendor,
      'type': type,
      'value': value,
    };
  }

  @override
  List<Object?> get props => [contractId, vendor, type, value];
}

class SiteModel extends Equatable {
  final String projectCode;
  final String projectNameEn;
  final String projectNameAr;
  final int totalContracts;
  final int totalAddenda;
  final String activeValue;
  final List<ContractSummaryModel> contracts;

  const SiteModel({
    required this.projectCode,
    required this.projectNameEn,
    required this.projectNameAr,
    required this.totalContracts,
    required this.totalAddenda,
    required this.activeValue,
    required this.contracts,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      projectCode: json['projectCode'] as String? ?? '',
      projectNameEn: json['projectNameEn'] as String? ?? '',
      projectNameAr: json['projectNameAr'] as String? ?? '',
      totalContracts: json['totalContracts'] as int? ?? 0,
      totalAddenda: json['totalAddenda'] as int? ?? 0,
      activeValue: json['activeValue'] as String? ?? '',
      contracts: (json['contracts'] as List<dynamic>?)
              ?.map((e) => ContractSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectCode': projectCode,
      'projectNameEn': projectNameEn,
      'projectNameAr': projectNameAr,
      'totalContracts': totalContracts,
      'totalAddenda': totalAddenda,
      'activeValue': activeValue,
      'contracts': contracts.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        projectCode,
        projectNameEn,
        projectNameAr,
        totalContracts,
        totalAddenda,
        activeValue,
        contracts,
      ];
}
