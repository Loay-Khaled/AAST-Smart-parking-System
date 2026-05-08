import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_bottom_nav.dart';

const Color _accent = Color(0xFF4F46E5);

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  List<dynamic> _bookings = [];
  bool _loading = true;

  static const _statuses = ['all', 'active', 'completed', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.adminBookings);
      if (mounted) setState(() { _bookings = data as List; _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  List<dynamic> _filtered(String status) =>
      status == 'all' ? _bookings : _bookings.where((b) => b['status'] == status).toList();

  Future<void> _cancel(dynamic booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Cancel booking for spot ${booking['spotId']}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApiService.patch(ApiConstants.adminBookingCancel(booking['_id']));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bookings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: _statuses.map((s) => Tab(text: s[0].toUpperCase() + s.substring(1))).toList(),
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: _statuses.map((status) {
                final list = _filtered(status);
                if (list.isEmpty) {
                  return const Center(child: Text('No bookings', style: TextStyle(color: Color(0xFF64748B))));
                }
                return RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final b = list[i] as Map<String, dynamic>;
                      final user = b['user'] as Map<String, dynamic>?;
                      final bStatus = b['status'] as String? ?? '';
                      final statusColor = bStatus == 'active' ? AppColors.secondary : bStatus == 'cancelled' ? AppColors.error : AppColors.muted;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(color: statusColor.withAlpha(25), borderRadius: BorderRadius.circular(6)),
                                    child: Text(bStatus[0].toUpperCase() + bStatus.substring(1), style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                                  ),
                                  const Spacer(),
                                  Text(
                                    (b['cost'] ?? 0) == 0 ? 'FREE' : '${b['cost']} EGP',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: (b['cost'] ?? 0) == 0 ? AppColors.secondary : const Color(0xFF1A1F36)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.directions_car, size: 16, color: _accent),
                                  const SizedBox(width: 6),
                                  Text('Spot ${b['spotId']} · Zone ${b['zone']} · ${b['duration']}h', style: const TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                              if (user != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 14, color: Color(0xFF64748B)),
                                    const SizedBox(width: 6),
                                    Text('${user['name']} · ${user['email']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ],
                              if (bStatus == 'active') ...[
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () => _cancel(b),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                    side: const BorderSide(color: AppColors.error),
                                    minimumSize: const Size(double.infinity, 38),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text('Cancel Booking'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
    );
  }
}
