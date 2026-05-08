import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../widgets/admin_bottom_nav.dart';

const Color _accent = Color(0xFF4F46E5);

class AdminWaitingListScreen extends StatefulWidget {
  const AdminWaitingListScreen({super.key});

  @override
  State<AdminWaitingListScreen> createState() => _AdminWaitingListScreenState();
}

class _AdminWaitingListScreenState extends State<AdminWaitingListScreen> {
  List<dynamic> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.adminWaitingList);
      if (mounted) setState(() { _entries = data as List; _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  Future<void> _remove(dynamic entry) async {
    final user = entry['user'] as Map<String, dynamic>?;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove from Queue'),
        content: Text('Remove ${user?['name'] ?? 'this user'} from the waiting list?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApiService.delete(ApiConstants.adminWaitingListEntry(entry['_id']));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting List (${_entries.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.queue, size: 64, color: Color(0xFF94A3B8)),
                      SizedBox(height: 16),
                      Text('Waiting list is empty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _entries.length,
                    itemBuilder: (_, i) {
                      final e = _entries[i] as Map<String, dynamic>;
                      final user = e['user'] as Map<String, dynamic>?;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF3730A3)]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text('#${e['position']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user?['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text(user?['email'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => _remove(e),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  minimumSize: const Size(80, 36),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                child: const Text('Remove', style: TextStyle(fontSize: 13)),
                              ),
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
