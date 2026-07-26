import 'package:equatable/equatable.dart';

class DashboardMetricsModel extends Equatable {
  final int totalUsers;
  final int pendingApprovals;
  final double revenue;
  final int activeProjects;

  const DashboardMetricsModel({
    required this.totalUsers,
    required this.pendingApprovals,
    required this.revenue,
    required this.activeProjects,
  });

  factory DashboardMetricsModel.fromJson(Map<String, dynamic> json) {
    return DashboardMetricsModel(
      totalUsers: json['totalUsers'] as int? ?? 0,
      pendingApprovals: json['pendingApprovals'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      activeProjects: json['activeProjects'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'pendingApprovals': pendingApprovals,
      'revenue': revenue,
      'activeProjects': activeProjects,
    };
  }

  @override
  List<Object?> get props => [
        totalUsers,
        pendingApprovals,
        revenue,
        activeProjects,
      ];
}
