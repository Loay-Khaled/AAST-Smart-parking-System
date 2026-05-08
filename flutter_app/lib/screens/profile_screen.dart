import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.profile);
      if (mounted) setState(() { _user = User.fromJson(data); _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await AuthService.clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.person, color: Colors.white, size: 36),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_user?.name ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                            Text(_user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Vehicle card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.directions_car, color: AppColors.primary),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Vehicle', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                                  Text(
                                    _user?.carPlate.isNotEmpty == true ? _user!.carPlate : 'No plate added',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Account summary
                      Row(
                        children: [
                          Expanded(child: _StatCard('Total Bookings', '${_user?.totalBookings ?? 0}', Icons.calendar_today, AppColors.primary)),
                          const SizedBox(width: 12),
                          Expanded(child: _StatCard('Penalties', '${_user?.activePenalties ?? 0}', Icons.warning_outlined, AppColors.warning)),
                          const SizedBox(width: 12),
                          Expanded(child: _StatCard('Total Spent', '${_user?.totalSpent.toStringAsFixed(0) ?? 0}', Icons.attach_money, AppColors.secondary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Menu
                      Card(
                        child: Column(
                          children: [
                            _MenuItem(Icons.payment_outlined, 'Payment Methods', onTap: () {}),
                            const Divider(height: 1, indent: 60),
                            _MenuItem(Icons.notifications_outlined, 'Notifications', onTap: () => Navigator.pushNamed(context, '/notifications')),
                            const Divider(height: 1, indent: 60),
                            _MenuItem(Icons.queue_outlined, 'Waiting List', onTap: () => Navigator.pushNamed(context, '/waiting-list')),
                            const Divider(height: 1, indent: 60),
                            _MenuItem(Icons.security_outlined, 'Privacy & Security', onTap: () {}),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Log Out'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.muted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(color: AppColors.foreground, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
      onTap: onTap,
    );
  }
}
