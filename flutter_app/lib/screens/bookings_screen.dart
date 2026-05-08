import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<Booking> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.myBookings);
      if (mounted) {
        setState(() {
          _bookings = (data as List).map((e) => Booking.fromJson(e)).toList();
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

  Future<void> _cancel(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Cancel booking for spot ${booking.spotId}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ApiService.patch(ApiConstants.cancelBooking(booking.id));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _bookings.where((b) => b.status == 'active').toList();
    final past = _bookings.where((b) => b.status != 'active').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.muted),
                      const SizedBox(height: 16),
                      const Text('No bookings yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.foreground)),
                      const SizedBox(height: 8),
                      const Text('Book a parking spot to get started', style: TextStyle(color: AppColors.muted)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/map'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(160, 48)),
                        child: const Text('Find a Spot'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (active.isNotEmpty) ...[
                        const Text('Active Bookings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground)),
                        const SizedBox(height: 12),
                        ...active.map((b) => _BookingCard(booking: b, onCancel: () => _cancel(b))),
                        const SizedBox(height: 20),
                      ],
                      if (past.isNotEmpty) ...[
                        const Text('Past Bookings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground)),
                        const SizedBox(height: 12),
                        ...past.map((b) => _BookingCard(booking: b)),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCancel;
  const _BookingCard({required this.booking, this.onCancel});

  Color get _statusColor {
    switch (booking.status) {
      case 'active': return AppColors.secondary;
      case 'cancelled': return AppColors.error;
      default: return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.directions_car, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spot ${booking.spotId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.foreground)),
                      Text('Zone ${booking.zone} · ${booking.timeRange}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(booking.costDisplay, style: TextStyle(fontWeight: FontWeight.bold, color: booking.cost == 0 ? AppColors.secondary : AppColors.foreground)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        booking.status[0].toUpperCase() + booking.status.substring(1),
                        style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (onCancel != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('Cancel Booking'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
