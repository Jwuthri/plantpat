import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../plants/models/plant.dart';
import '../../plants/providers/plants_provider.dart';

class PlantSelectionWidget extends ConsumerWidget {
  const PlantSelectionWidget({
    super.key,
    required this.onPlantSelected,
  });

  final Function(Plant) onPlantSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsState = ref.watch(plantsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.successColor.withOpacity(0.8),
                AppTheme.successColor.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select Plant to Diagnose',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Choose which plant you want to check for health issues',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Plants List
        Expanded(
          child: plantsState.when(
            data: (plants) => plants.isEmpty 
                ? _buildEmptyState(context, ref)
                : _buildPlantsList(plants),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(context, error, ref),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Plants Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You need to identify and save plants first\nbefore running health checks.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to identify plant
              // This could navigate to camera with identify action
            },
            icon: const Icon(Icons.search),
            label: const Text('Identify Plant First'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.plantGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to Load Plants',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.read(plantsNotifierProvider.notifier).refreshPlants(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantsList(List<Plant> plants) {
    return ListView.builder(
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return _PlantSelectionCard(
          plant: plant,
          onTap: () => onPlantSelected(plant),
        );
      },
    );
  }
}

class _PlantSelectionCard extends StatelessWidget {
  const _PlantSelectionCard({
    required this.plant,
    required this.onTap,
  });

  final Plant plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2E2E2E),
                const Color(0xFF3A3A3A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Plant Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.plantGreen.withOpacity(0.1),
                ),
                child: plant.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildPlantImage(plant.images.first),
                      )
                    : Icon(
                        Icons.eco,
                        color: AppTheme.plantGreen,
                        size: 30,
                      ),
              ),
              const SizedBox(width: 16),
              
              // Plant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (plant.scientificName?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        plant.scientificName!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                    if (plant.species?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.plantGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          plant.species!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.plantGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Select Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.plantGreen,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantImage(String imageData) {
    try {
      // Handle base64 images
      String base64String = imageData;
      if (imageData.contains(',')) {
        base64String = imageData.split(',').last;
      }
      
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.eco,
            color: AppTheme.plantGreen,
            size: 30,
          );
        },
      );
    } catch (e) {
      return Icon(
        Icons.eco,
        color: AppTheme.plantGreen,
        size: 30,
      );
    }
  }
}