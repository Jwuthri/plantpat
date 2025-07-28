import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../plants/models/plant.dart';

class RecentPlantsSection extends StatelessWidget {
  const RecentPlantsSection({
    super.key,
    required this.plants,
  });

  final List<Plant> plants;

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return _EmptyPlantsWidget();
    }

    final recentPlants = plants.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Plants',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.go('/plants'),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.plantGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentPlants.length,
            itemBuilder: (context, index) {
              final plant = recentPlants[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == recentPlants.length - 1 ? 0 : 16,
                ),
                child: _PlantCard(plant: plant),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlantCard extends StatelessWidget {
  const _PlantCard({required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/plants/${plant.id}'),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.lightGreen.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: plant.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          plant.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              _PlantPlaceholder(),
                        ),
                      )
                    : _PlantPlaceholder(),
              ),
            ),
            
            // Plant Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (plant.isFavorite) ...[
                        const Icon(
                          Icons.favorite,
                          size: 12,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Icon(
                        _getHealthIcon(),
                        size: 12,
                        color: _getHealthColor(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getHealthIcon() {
    if (plant.nextWateringDate == null) return Icons.warning;
    
    final needsWater = DateTime.now().isAfter(plant.nextWateringDate!);
    return needsWater ? Icons.water_drop : Icons.check_circle;
  }

  Color _getHealthColor() {
    if (plant.nextWateringDate == null) return AppTheme.warningColor;
    
    final needsWater = DateTime.now().isAfter(plant.nextWateringDate!);
    return needsWater ? AppTheme.warningColor : AppTheme.successColor;
  }
}

class _PlantPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.local_florist,
      size: 40,
      color: AppTheme.plantGreen,
    );
  }
}

class _EmptyPlantsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_florist,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No plants yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your plant journey by identifying your first plant!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.go('/camera?action=identify'),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Identify Plant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.plantGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 