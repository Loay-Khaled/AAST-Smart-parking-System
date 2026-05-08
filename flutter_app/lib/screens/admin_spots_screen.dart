import 'package:flutter/material.dart';
import '../models/parking_spot.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_bottom_nav.dart';

const Color _accent = Color(0xFF4F46E5);

class AdminSpotsScreen extends StatefulWidget {
  const AdminSpotsScreen({super.key});

  @override
  State<AdminSpotsScreen> createState() => _AdminSpotsScreenState();
}

class _AdminSpotsScreenState extends State<AdminSpotsScreen> {
  List<ParkingSpot> _spots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.spots);
      if (mounted) {
        setState(() {
          _spots = (data['spots'] as List).map((e) => ParkingSpot.fromJson(e)).toList();
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

  Future<void> _setStatus(ParkingSpot spot) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set status for ${spot.spotId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: AppColors.available),
              title: const Text('Available', style: TextStyle(color: AppColors.available, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context, 'available'),
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined, color: AppColors.occupied),
              title: const Text('Occupied', style: TextStyle(color: AppColors.occupied, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context, 'occupied'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: AppColors.reserved),
              title: const Text('Reserved', style: TextStyle(color: AppColors.reserved, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context, 'reserved'),
            ),
          ],
        ),
      ),
    );

    if (chosen == null) return;
    try {
      await ApiService.patch(ApiConstants.adminSpotUpdate(spot.spotId), {'status': chosen});
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  List<ParkingSpot> _zone(String z) => _spots.where((s) => s.zone == z).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Spots', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: ['A', 'B', 'C'].map((zone) {
                  final zoneSpots = _zone(zone);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(8)),
                              child: Text('Zone $zone', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text('Floor ${zone == 'A' ? 1 : zone == 'B' ? 2 : 3}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                          ],
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1),
                        itemCount: zoneSpots.length,
                        itemBuilder: (_, i) {
                          final spot = zoneSpots[i];
                          final color = spot.isAvailable ? AppColors.available : spot.isOccupied ? AppColors.occupied : AppColors.reserved;
                          return GestureDetector(
                            onLongPress: () => _setStatus(spot),
                            onTap: () => _setStatus(spot),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: color, width: 1.5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_car, color: color, size: 22),
                                  const SizedBox(height: 4),
                                  Text(spot.spotId, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Icon(Icons.touch_app, color: color.withAlpha(150), size: 12),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}

