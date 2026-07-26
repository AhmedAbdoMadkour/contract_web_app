class FinanceReportModel {
  final double totalRevenue;
  final double totalExpenses;
  final double netIncome;
  final String currency;
  final DateTime reportDate;

  const FinanceReportModel({
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netIncome,
    required this.currency,
    required this.reportDate,
  });

  factory FinanceReportModel.fromJson(Map<String, dynamic> json) {
    return FinanceReportModel(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      netIncome: (json['netIncome'] as num).toDouble(),
      currency: json['currency'] as String,
      reportDate: DateTime.parse(json['reportDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'totalExpenses': totalExpenses,
      'netIncome': netIncome,
      'currency': currency,
      'reportDate': reportDate.toIso8601String(),
    };
  }
}
