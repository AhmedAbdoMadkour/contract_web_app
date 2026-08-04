import 'package:equatable/equatable.dart';

class ChartPointModel extends Equatable {
  final String label;
  final double value;

  const ChartPointModel({required this.label, required this.value});

  factory ChartPointModel.fromJson(Map<String, dynamic> json) {
    return ChartPointModel(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'value': value};

  @override
  List<Object?> get props => [label, value];
}

class DashboardMetricsModel extends Equatable {
  final int totalUsers;
  final int pendingApprovals;
  final double revenue;
  final int activeProjects;
  final List<ChartPointModel> userGrowthChart;
  final List<ChartPointModel> revenueChart;

  const DashboardMetricsModel({
    required this.totalUsers,
    required this.pendingApprovals,
    required this.revenue,
    required this.activeProjects,
    this.userGrowthChart = const [],
    this.revenueChart = const [],
  });

  factory DashboardMetricsModel.fromJson(Map<String, dynamic> json) {
    return DashboardMetricsModel(
      totalUsers: json['totalUsers'] as int? ?? 0,
      pendingApprovals: json['pendingApprovals'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      activeProjects: json['activeProjects'] as int? ?? 0,
      userGrowthChart: (json['userGrowthChart'] as List<dynamic>?)
              ?.map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      revenueChart: (json['revenueChart'] as List<dynamic>?)
              ?.map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'pendingApprovals': pendingApprovals,
      'revenue': revenue,
      'activeProjects': activeProjects,
      'userGrowthChart': userGrowthChart.map((e) => e.toJson()).toList(),
      'revenueChart': revenueChart.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        totalUsers,
        pendingApprovals,
        revenue,
        activeProjects,
        userGrowthChart,
        revenueChart,
      ];
}
