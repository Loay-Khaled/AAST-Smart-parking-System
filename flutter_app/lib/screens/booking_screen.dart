import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';

class BookingScreen extends StatefulWidget {
  final String spotId;
  const BookingScreen({super.key, required this.spotId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedHours = 1;
  bool _loading = false;

  double get _cost => _selectedHours <= 1 ? 0 : (_selectedHours - 1) * 10.0;

  String get _endTime {
    final end = DateTime.now().add(Duration(hours: _selectedHours));
    return DateFormat('hh:mm a').format(end);
  }

  Future<void> _confirm() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.post(ApiConstants.bookings, {
        'spotId': widget.spotId,
        'duration': _selectedHours,
      });
      final booking = Booking.fromJson(data);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/confirmation', arguments: booking);
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
      appBar: AppBar(
        title: Text('Book Spot ${widget.spotId}'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground)),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: List.generate(5, (i) {
                  final hours = i + 1;
                  final cost = hours <= 1 ? 'FREE' : '${(hours - 1) * 10} EGP';
                  final isSelected = _selectedHours == hours;
                  return InkWell(
                    onTap: () => setState(() => _selectedHours = hours),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.06) : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: hours,
                            groupValue: _selectedHours,
                            onChanged: (v) => setState(() => _selectedHours = v!),
                            activeColor: AppColors.primary,
                          ),
                          Text('$hours ${hours == 1 ? 'Hour' : 'Hours'}', style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.foreground)),
                          const Spacer(),
                          Text(cost, style: TextStyle(fontWeight: FontWeight.bold, color: hours == 1 ? AppColors.secondary : AppColors.primary)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.foreground)),
                    const SizedBox(height: 12),
                    const _Row('First hour', 'FREE'),
                    if (_selectedHours > 1) _Row('${_selectedHours - 1} additional hour(s)', '${(_selectedHours - 1) * 10} EGP'),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          _cost == 0 ? 'FREE' : '${_cost.toStringAsFixed(0)} EGP',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _cost == 0 ? AppColors.secondary : AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.muted),
                  const SizedBox(width: 6),
                  Text(
                    'Start: Now  •  End: $_endTime',
                    style: const TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _confirm, child: const Text('Confirm Booking')),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppColors.foreground, fontSize: 14)),
        ],
      ),
    );
  }
}
