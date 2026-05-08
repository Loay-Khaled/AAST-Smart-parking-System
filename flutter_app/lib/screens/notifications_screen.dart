import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.notifications);
      if (mounted) {
        setState(() {
          _notifications = (data as List).map((e) => AppNotification.fromJson(e)).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  Future<void> _markAllRead() async {
    try {
      await ApiService.patch(ApiConstants.readAllNotifications);
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(onPressed: _markAllRead, child: const Text('Mark all read')),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: AppColors.muted),
                      SizedBox(height: 16),
                      Text('No notifications yet', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.foreground)),
                      SizedBox(height: 8),
                      Text('You\'ll see updates here', style: TextStyle(color: AppColors.muted)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (_, i) => _NotifCard(notification: _notifications[i]),
                  ),
                ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final AppNotification notification;
  const _NotifCard({required this.notification});

  Color get _iconColor {
    switch (notification.type) {
      case 'success': return AppColors.success;
      case 'warning': return AppColors.warning;
      case 'error': return AppColors.error;
      default: return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (notification.type) {
      case 'success': return Icons.check_circle_outline;
      case 'warning': return Icons.access_time;
      case 'error': return Icons.cancel_outlined;
      default: return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: notification.read ? AppColors.card : AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: notification.read ? AppColors.border : AppColors.primary.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: _iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(_icon, color: _iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.foreground)),
                  const SizedBox(height: 3),
                  Text(notification.message, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 6),
                  Text(notification.timeAgo, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                ],
              ),
            ),
            if (!notification.read)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
