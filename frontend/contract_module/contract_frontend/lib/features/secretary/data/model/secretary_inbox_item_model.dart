class SecretaryInboxItemModel {
  final String id;
  final String sender;
  final String subject;
  final String content;
  final bool isRead;
  final DateTime receivedAt;

  SecretaryInboxItemModel({
    required this.id,
    required this.sender,
    required this.subject,
    required this.content,
    required this.isRead,
    required this.receivedAt,
  });

  factory SecretaryInboxItemModel.fromJson(Map<String, dynamic> json) {
    return SecretaryInboxItemModel(
      id: json['id'] ?? '',
      sender: json['sender'] ?? '',
      subject: json['subject'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      receivedAt: json['receivedAt'] != null
          ? DateTime.parse(json['receivedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'subject': subject,
      'content': content,
      'isRead': isRead,
      'receivedAt': receivedAt.toIso8601String(),
    };
  }
}
