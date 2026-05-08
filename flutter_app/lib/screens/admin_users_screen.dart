import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../widgets/admin_bottom_nav.dart';

const Color _accent = Color(0xFF4F46E5);

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<dynamic> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.adminUsers);
      if (mounted) setState(() { _users = data as List; _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  Future<void> _editUser(Map<String, dynamic> user) async {
    final nameCtrl = TextEditingController(text: user['name']);
    final plateCtrl = TextEditingController(text: user['carPlate'] ?? '');
    final penaltyCtrl = TextEditingController(text: '${user['activePenalties'] ?? 0}');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit ${user['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
            TextField(controller: plateCtrl, decoration: const InputDecoration(labelText: 'Car Plate')),
            const SizedBox(height: 12),
            TextField(controller: penaltyCtrl, decoration: const InputDecoration(labelText: 'Active Penalties'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await ApiService.patch(ApiConstants.adminUserById(user['_id']), {
        'name': nameCtrl.text.trim(),
        'carPlate': plateCtrl.text.trim(),
        'activePenalties': int.tryParse(penaltyCtrl.text) ?? 0,
      });
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Delete "${user['name']}"? This also removes their bookings and notifications.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApiService.delete(ApiConstants.adminUserById(user['_id']));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users (${_users.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text('No users found'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _users.length,
                    itemBuilder: (_, i) {
                      final u = _users[i] as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: _accent.withAlpha(25),
                            child: Text(
                              (u['name'] as String? ?? '?')[0].toUpperCase(),
                              style: const TextStyle(color: _accent, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(u['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u['email'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              const SizedBox(height: 2),
                              Text(
                                'Bookings: ${u['totalBookings'] ?? 0}  •  Spent: ${u['totalSpent'] ?? 0} EGP  •  Penalties: ${u['activePenalties'] ?? 0}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit_outlined, color: _accent, size: 20), onPressed: () => _editUser(u)),
                              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => _deleteUser(u)),
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
