import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/diagnosis_database.dart';
import '../../../core/services/http_service.dart';

class DiagnosisNotifier extends StateNotifier<AsyncValue<List<DiagnosisRecord>>> {
  DiagnosisNotifier() : super(const AsyncValue.loading()) {
    _initialize();
  }
  
  final _logger = Logger();
  final _httpService = HttpService();

  void _initialize() async {
    try {
      final diagnoses = await _fetchDiagnoses();
      state = AsyncValue.data(diagnoses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Method to manually refresh diagnoses
  Future<void> refreshDiagnoses() async {
    state = const AsyncValue.loading();
    try {
      final diagnoses = await _fetchDiagnoses();
      state = AsyncValue.data(diagnoses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

    Future<List<DiagnosisRecord>> _fetchDiagnoses() async {
    try {
      _logger.i('🩺 [DIAGNOSES] Fetching diagnoses via HTTP API...');
      
      final diagnosesList = await _httpService.getDiagnoses();
      _logger.i('🩺 [DIAGNOSES] 📊 API results: ${diagnosesList.length} diagnoses found');
      
      if (diagnosesList.isEmpty) {
        _logger.i('🩺 [DIAGNOSES] No diagnoses found');
        return [];
      }

      final diagnoses = <DiagnosisRecord>[];
      for (final json in diagnosesList) {
        try {
          final diagnosis = DiagnosisRecord.fromJson(json as Map<String, dynamic>);
          diagnoses.add(diagnosis);
        } catch (diagnosisError) {
          _logger.w('🩺 [DIAGNOSES] Failed to parse diagnosis: $diagnosisError, data: $json');
          // Skip invalid diagnoses but continue processing others
        }
      }
      
      _logger.i('🩺 [DIAGNOSES] Successfully loaded ${diagnoses.length} diagnoses');
      return diagnoses;
    } catch (e) {
      _logger.e('Error fetching diagnoses: $e');
      throw Exception('Failed to load diagnoses');
    }
  }

  Future<void> addDiagnosis(DiagnosisRecord diagnosis) async {
    try {
      await _httpService.saveDiagnosis(diagnosis.toJson());
      refreshDiagnoses(); // Refresh the state
    } catch (e) {
      _logger.e('Error adding diagnosis: $e');
      throw Exception('Failed to add diagnosis');
    }
  }

  Future<void> updateDiagnosis(DiagnosisRecord diagnosis) async {
    try {
      // TODO: Create update endpoint in backend  
      // For now, use saveDiagnosis for updates too
      await _httpService.saveDiagnosis(diagnosis.toJson());
      refreshDiagnoses(); // Refresh the state
    } catch (e) {
      _logger.e('Error updating diagnosis: $e');
      throw Exception('Failed to update diagnosis');
    }
  }

  Future<void> deleteDiagnosis(String diagnosisId) async {
    try {
      // TODO: Create delete endpoint in backend
      // For now, just refresh and let the backend handle this
      refreshDiagnoses(); // Refresh the state
    } catch (e) {
      _logger.e('Error deleting diagnosis: $e');
      throw Exception('Failed to delete diagnosis');
    }
  }
}

// Providers
final diagnosisNotifierProvider = StateNotifierProvider<DiagnosisNotifier, AsyncValue<List<DiagnosisRecord>>>((ref) {
  return DiagnosisNotifier();
});

final diagnosisProvider = Provider.family<AsyncValue<DiagnosisRecord?>, String>((ref, diagnosisId) {
  final diagnoses = ref.watch(diagnosisNotifierProvider);
  return diagnoses.when(
    data: (diagnosisList) {
      try {
        return AsyncValue.data(diagnosisList.firstWhere((diagnosis) => diagnosis.id == diagnosisId));
      } catch (e) {
        return const AsyncValue.data(null);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final recentDiagnosesProvider = Provider<AsyncValue<List<DiagnosisRecord>>>((ref) {
  final diagnoses = ref.watch(diagnosisNotifierProvider);
  return diagnoses.when(
    data: (diagnosisList) => AsyncValue.data(diagnosisList.take(5).toList()),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Provider to get diagnoses for a specific plant
final plantDiagnosesProvider = Provider.family<AsyncValue<List<DiagnosisRecord>>, String>((ref, plantId) {
  final diagnoses = ref.watch(diagnosisNotifierProvider);
  return diagnoses.when(
    data: (diagnosisList) {
      final plantDiagnoses = diagnosisList.where((diagnosis) => diagnosis.plantId == plantId).toList();
      return AsyncValue.data(plantDiagnoses);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});