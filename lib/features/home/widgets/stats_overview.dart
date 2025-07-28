import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../plants/models/plant.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({
    super.key,
    required this.plants,
  });

  final List<Plant> plants;

  @override
  Widget build(BuildContext context) {
    final totalPlants = plants.length;
    final favoritePlants = plants.where((p) => p.isFavorite).length;
    final healthyPlants = plants.where((p) => _isHealthy(p)).length;
    final plantsNeedingWater = plants.where((p) => _needsWatering(p)).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.plantGreen, AppTheme.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Garden',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: totalPlants.toString(),
                  label: 'Total Plants',
                  icon: Icons.local_florist,
                ),
              ),
              Expanded(
                child: _StatItem(
                  value: favoritePlants.toString(),
                  label: 'Favorites',
                  icon: Icons.favorite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: healthyPlants.toString(),
                  label: 'Healthy',
                  icon: Icons.health_and_safety,
                ),
              ),
              Expanded(
                child: _StatItem(
                  value: plantsNeedingWater.toString(),
                  label: 'Need Water',
                  icon: Icons.water_drop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isHealthy(Plant plant) {
    // Simple logic - assume plant is healthy if watered within schedule
    if (plant.lastWatered == null) return false;
    
    final daysSinceWatered = DateTime.now().difference(plant.lastWatered!).inDays;
    final maxDaysWithoutWater = _getMaxDaysWithoutWater(plant.careInfo.wateringFrequency);
    
    return daysSinceWatered <= maxDaysWithoutWater;
  }

  bool _needsWatering(Plant plant) {
    if (plant.nextWateringDate == null) return true;
    return DateTime.now().isAfter(plant.nextWateringDate!);
  }

  int _getMaxDaysWithoutWater(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return 1;
      case 'weekly':
        return 7;
      case 'bi-weekly':
        return 14;
      case 'monthly':
        return 30;
      default:
        return 7;
    }
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
} 