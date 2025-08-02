import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

import '../models/plant.dart';

class PlantsNotifier extends StateNotifier<AsyncValue<List<Plant>>> {
  PlantsNotifier() : super(const AsyncValue.loading()) {
    _initialize();
  }
  
  final _logger = Logger();
  final _supabase = Supabase.instance.client;

  void _initialize() async {
    try {
      final plants = await _fetchPlants();
      state = AsyncValue.data(plants);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<Plant>> _fetchPlants() async {
    try {
      final response = await _supabase
          .from('plants')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      _logger.i('🌱 Raw plants response: $response');
      
      if (response == null) {
        _logger.w('🌱 No plants data returned');
        return [];
      }

      final plantsList = response as List;
      if (plantsList.isEmpty) {
        _logger.i('🌱 No plants found in database');
        return [];
      }

      final plants = <Plant>[];
      for (final json in plantsList) {
        try {
          final plant = Plant.fromJson(json as Map<String, dynamic>);
          plants.add(plant);
        } catch (plantError) {
          _logger.w('🌱 Failed to parse plant: $plantError, data: $json');
          // Skip invalid plants but continue processing others
        }
      }
      
      _logger.i('🌱 Successfully loaded ${plants.length} plants');
      return plants;
    } catch (e) {
      _logger.e('Error fetching plants: $e');
      throw Exception('Failed to load plants');
    }
  }

  Future<void> addPlant(Plant plant) async {
    try {
      await _supabase.from('plants').insert(plant.toJson());
      _initialize(); // Refresh the state
    } catch (e) {
      _logger.e('Error adding plant: $e');
      throw Exception('Failed to add plant');
    }
  }

  Future<void> updatePlant(Plant plant) async {
    try {
      await _supabase
          .from('plants')
          .update(plant.toJson())
          .eq('id', plant.id);
      _initialize(); // Refresh the state
    } catch (e) {
      _logger.e('Error updating plant: $e');
      throw Exception('Failed to update plant');
    }
  }

  Future<void> deletePlant(String plantId) async {
    try {
      await _supabase
          .from('plants')
          .update({'is_active': false})
          .eq('id', plantId);
      _initialize(); // Refresh the state
    } catch (e) {
      _logger.e('Error deleting plant: $e');
      throw Exception('Failed to delete plant');
    }
  }

  Future<void> toggleFavorite(String plantId) async {
    final currentState = state.value;
    if (currentState == null) return;
    
    final plant = currentState.firstWhere((p) => p.id == plantId);
    final updatedPlant = plant.copyWith(isFavorite: !plant.isFavorite);
    await updatePlant(updatedPlant);
  }

  Future<void> updateWateringDate(String plantId, DateTime wateringDate) async {
    final currentState = state.value;
    if (currentState == null) return;
    
    final plant = currentState.firstWhere((p) => p.id == plantId);
    
    // Update care history with watering record
    final updatedCareHistory = List<dynamic>.from(plant.careHistory);
    updatedCareHistory.add({
      'type': 'watering',
      'date': wateringDate.toIso8601String(),
      'notes': 'Watered',
    });
    
    final updatedPlant = plant.copyWith(careHistory: updatedCareHistory);
    await updatePlant(updatedPlant);
  }

  DateTime _calculateNextWateringDate(String? frequency, DateTime lastWatered) {
    if (frequency == null) return lastWatered.add(const Duration(days: 7));
    
    switch (frequency.toLowerCase()) {
      case 'daily':
        return lastWatered.add(const Duration(days: 1));
      case 'weekly':
        return lastWatered.add(const Duration(days: 7));
      case 'bi-weekly':
        return lastWatered.add(const Duration(days: 14));
      case 'monthly':
        return lastWatered.add(const Duration(days: 30));
      default:
        return lastWatered.add(const Duration(days: 7));
    }
  }
}

// Providers
final plantsNotifierProvider = StateNotifierProvider<PlantsNotifier, AsyncValue<List<Plant>>>((ref) {
  return PlantsNotifier();
});

final plantProvider = Provider.family<AsyncValue<Plant?>, String>((ref, plantId) {
  final plants = ref.watch(plantsNotifierProvider);
  return plants.when(
    data: (plantList) {
      try {
        return AsyncValue.data(plantList.firstWhere((plant) => plant.id == plantId));
      } catch (e) {
        return const AsyncValue.data(null);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final favoritePlantsProvider = Provider<AsyncValue<List<Plant>>>((ref) {
  final plants = ref.watch(plantsNotifierProvider);
  return plants.when(
    data: (plantList) => AsyncValue.data(plantList.where((plant) => plant.isFavorite).toList()),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final plantsByCategoryProvider = Provider.family<AsyncValue<List<Plant>>, String>((ref, category) {
  final plants = ref.watch(plantsNotifierProvider);
  return plants.when(
    data: (plantList) => AsyncValue.data(plantList.where((plant) {
      // Filter by species or tags since we no longer have category
      return plant.species?.toLowerCase().contains(category.toLowerCase()) == true ||
             plant.tags.any((tag) => tag.toLowerCase().contains(category.toLowerCase()));
    }).toList()),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
}); 