import 'package:flutter/material.dart';
import '../models/parking_spot.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<ParkingSpot> _spots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get(ApiConstants.spots);
      final list =
          (data['spots'] as List).map((e) => ParkingSpot.fromJson(e)).toList();
      if (mounted)
        setState(() {
          _spots = list;
          _loading = false;
        });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  List<ParkingSpot> _zone(String z) =>
      _spots.where((s) => s.zone == z).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Parking Map',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground)),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search spot (e.g. A1)',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.border)),
                    ),
                    onChanged: (v) {},
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      _Legend('Available', AppColors.available),
                      SizedBox(width: 16),
                      _Legend('Occupied', AppColors.occupied),
                      SizedBox(width: 16),
                      _Legend('Reserved', AppColors.reserved),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadSpots,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: ['A', 'B', 'C'].map((zone) {
                          final zoneSpots = _zone(zone);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text('Zone $zone',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                        'Floor ${zone == 'A' ? 1 : zone == 'B' ? 2 : 3}',
                                        style: const TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.1,
                                ),
                                itemCount: zoneSpots.length,
                                itemBuilder: (_, i) =>
                                    _SpotCard(spot: zoneSpots[i]),
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      ],
    );
  }
}

class _SpotCard extends StatelessWidget {
  final ParkingSpot spot;
  const _SpotCard({required this.spot});

  @override
  Widget build(BuildContext context) {
    final color = spot.isAvailable
        ? AppColors.available
        : spot.isOccupied
            ? AppColors.occupied
            : AppColors.reserved;
    final canTap = !spot.isOccupied;

    return Opacity(
      opacity: spot.isOccupied ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: canTap
            ? () => Navigator.pushNamed(context, '/spot-details',
                arguments: spot.spotId)
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car, color: color, size: 22),
              const SizedBox(height: 4),
              Text(spot.spotId,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
