import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_bottom_nav.dart';

const Color _accent = Color(0xFF4F46E5);

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.adminNotifications);
      if (mounted) setState(() { _notifications = data as List; _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'success': return AppColors.success;
      case 'warning': return AppColors.warning;
      case 'error': return AppColors.error;
      default: return _accent;
    }
  }

  IconData _icon(String type) {
    switch (type) {
      case 'success': return Icons.check_circle_outline;
      case 'warning': return Icons.access_time;
      case 'error': return Icons.cancel_outlined;
      default: return Icons.info_outline;
    }
  }

  String _timeAgo(String iso) {
    final diff = DateTime.now().difference(DateTime.parse(iso));
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No notifications', style: TextStyle(color: Color(0xFF64748B))))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (_, i) {
                      final n = _notifications[i] as Map<String, dynamic>;
                      final type = n['type'] as String? ?? 'info';
                      final color = _iconColor(type);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 38, height: 38,
                                decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(10)),
                                child: Icon(_icon(type), color: color, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(n['userEmail'] ?? '', style: const TextStyle(fontSize: 11, color: _accent, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(n['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text(n['message'] ?? '', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, height: 1.4)),
                                    const SizedBox(height: 4),
                                    Text(_timeAgo(n['createdAt'] ?? DateTime.now().toIso8601String()), style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                  ],
                                ),
                              ),
                              if (!(n['read'] as bool? ?? false))
                                Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: _accent, shape: BoxShape.circle)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
