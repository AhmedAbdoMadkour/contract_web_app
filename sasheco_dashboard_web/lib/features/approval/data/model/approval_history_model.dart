class ApprovalHistoryModel {
  final String id;
  final String actionTaken;
  final String comments;
  final DateTime timestamp;
  final String userName;

  ApprovalHistoryModel({
    required this.id,
    required this.actionTaken,
    required this.comments,
    required this.timestamp,
    required this.userName,
  });

  factory ApprovalHistoryModel.fromJson(Map<String, dynamic> json) {
    return ApprovalHistoryModel(
      id: json['id']?.toString() ?? '',
      actionTaken: json['actionTaken']?.toString() ?? '',
      comments: json['comments']?.toString() ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'].toString()) 
          : DateTime.now(),
      userName: json['userName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actionTaken': actionTaken,
      'comments': comments,
      'timestamp': timestamp.toIso8601String(),
      'userName': userName,
    };
  }
}
