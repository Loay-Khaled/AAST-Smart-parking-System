import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  int _availableCount = 0;
  int _totalCount = 18;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _user = await AuthService.getUser();
      final data = await ApiService.get(ApiConstants.spots);
      if (mounted) {
        setState(() {
          _availableCount = data['availableCount'] ?? 0;
          _totalCount = data['totalCount'] ?? 18;
          _loading = false;
        });
      }
      // Refresh user from server
      final userData = await ApiService.get(ApiConstants.profile);
      if (mounted) setState(() => _user = User.fromJson(userData));
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Good day,', style: TextStyle(color: Colors.white70, fontSize: 14)),
                            Text(
                              _user?.name ?? 'User',
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pushNamed(context, '/notifications'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Available Spots', style: TextStyle(color: Colors.white70, fontSize: 13)),
                              Text(
                                '$_availableCount / $_totalCount',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _totalCount > 0 ? _availableCount / _totalCount : 0,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Nearest Spot Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.location_on_outlined, color: AppColors.secondary),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nearest Spot', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                                Text('Zone A — Spot A1', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.foreground, fontSize: 16)),
                                Text('Floor 1 · ~2 min walk', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/spot-details', arguments: 'A1'),
                            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
                            child: const Text('Book', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quick Summary
                  const Text('Quick Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Total Bookings', value: '${_user?.totalBookings ?? 0}', icon: Icons.calendar_today, color: AppColors.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(label: 'Total Spent', value: '${_user?.totalSpent.toStringAsFixed(0) ?? 0} EGP', icon: Icons.attach_money, color: AppColors.secondary)),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(label: 'Penalties', value: '${_user?.activePenalties ?? 0}', icon: Icons.warning_outlined, color: AppColors.warning)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Promo Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_offer_outlined, color: Colors.white, size: 32),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('First Hour Free!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('Every parking session starts free', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.muted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
