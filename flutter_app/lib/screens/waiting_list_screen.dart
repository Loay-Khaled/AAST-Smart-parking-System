import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';

class WaitingListScreen extends StatefulWidget {
  const WaitingListScreen({super.key});

  @override
  State<WaitingListScreen> createState() => _WaitingListScreenState();
}

class _WaitingListScreenState extends State<WaitingListScreen> {
  bool _loading = true;
  bool _inQueue = false;
  int? _position;
  int _totalWaiting = 0;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.myQueue);
      if (mounted) {
        setState(() {
          _inQueue = data['inQueue'] ?? false;
          _position = data['position'];
          _totalWaiting = data['totalWaiting'] ?? 0;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  Future<void> _join() async {
    setState(() => _actionLoading = true);
    try {
      await ApiService.post(ApiConstants.joinQueue, {});
      await _load();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _leave() async {
    setState(() => _actionLoading = true);
    try {
      await ApiService.delete(ApiConstants.leaveQueue);
      await _load();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waiting List')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _inQueue
                  ? _InQueueView(
                      position: _position ?? 0,
                      totalWaiting: _totalWaiting,
                      loading: _actionLoading,
                      onLeave: _leave)
                  : _NotInQueueView(loading: _actionLoading, onJoin: _join),
            ),
    );
  }
}

class _NotInQueueView extends StatelessWidget {
  final bool loading;
  final VoidCallback onJoin;
  const _NotInQueueView({required this.loading, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Icon(Icons.local_parking, size: 72, color: AppColors.muted),
        const SizedBox(height: 16),
        const Text('Parking Full',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground)),
        const SizedBox(height: 8),
        const Text('All spots are currently occupied',
            style: TextStyle(color: AppColors.muted)),
        const SizedBox(height: 28),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How It Works',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.foreground)),
                SizedBox(height: 14),
                _Step(1, 'Join the waiting list',
                    'We track your position in real time'),
                SizedBox(height: 10),
                _Step(
                    2, 'Get notified', 'You\'ll be notified when a spot opens'),
                SizedBox(height: 10),
                _Step(3, 'Confirm within 5 minutes',
                    'Book your spot before the window expires'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: onJoin, child: const Text('Join Waiting List')),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final int num;
  final String title;
  final String sub;
  const _Step(this.num, this.title, this.sub);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle),
          child: Center(
              child: Text('$num',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13))),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.foreground)),
            Text(sub,
                style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _InQueueView extends StatelessWidget {
  final int position;
  final int totalWaiting;
  final bool loading;
  final VoidCallback onLeave;
  const _InQueueView(
      {required this.position,
      required this.totalWaiting,
      required this.loading,
      required this.onLeave});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text('Your Queue Position',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              Text('#$position',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.bold)),
              Text('of $totalWaiting waiting',
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppColors.secondary),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimated Wait',
                        style: TextStyle(color: AppColors.muted, fontSize: 12)),
                    Text('15 - 20 minutes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                            fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_outlined,
                  color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Expanded(
                  child: Text(
                      'You have 5 minutes to confirm once a spot becomes available',
                      style: TextStyle(
                          color: AppColors.foreground, fontSize: 13))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        loading
            ? const CircularProgressIndicator()
            : OutlinedButton(
                onPressed: onLeave,
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error)),
                child: const Text('Leave Queue'),
              ),
      ],
    );
  }
}
