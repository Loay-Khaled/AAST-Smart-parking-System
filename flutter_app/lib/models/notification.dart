class AppNotification {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final bool read;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        type: json['type'] ?? 'info',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        read: json['read'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      );
}
