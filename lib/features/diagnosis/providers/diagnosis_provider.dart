import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

import '../models/diagnosis_database.dart';
import '../../../core/services/user_profile_service.dart';

class DiagnosisNotifier extends StateNotifier<AsyncValue<List<DiagnosisRecord>>> {
  DiagnosisNotifier() : super(const AsyncValue.loading()) {
    _initialize();
  }
  
  final _logger = Logger();
  final _supabase = Supabase.instance.client;
  final _profileService = UserProfileService();

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

  // Get device-based profile ID using shared service
  Future<String> _getDeviceProfileId() async {
    return await _profileService.getProfileId();
  }

  Future<List<DiagnosisRecord>> _fetchDiagnoses() async {
    try {
      // Get current user's profile ID
      final profileId = await _getDeviceProfileId();
      _logger.i('🩺 [DIAGNOSES] 👤 Fetching diagnoses for profile: $profileId');
      
      final response = await _supabase
          .from('diagnoses')
          .select('''
            *,
            plants:plant_id (
              id,
              name,
              species,
              scientific_name,
              confidence
            )
          ''')
          .eq('profile_id', profileId) // Only get diagnoses for this user
          .order('created_at', ascending: false);

      _logger.i('🩺 [DIAGNOSES] 📊 Query results: ${response.length} diagnoses found for profile: $profileId');
      _logger.i('🩺 [DIAGNOSES] 📄 Raw response: $response');
      
      // Supabase always returns a list, even if empty
      final diagnosesList = response as List;
      if (diagnosesList.isEmpty) {
        _logger.i('🩺 [DIAGNOSES] No diagnoses found in database');
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
      
      _logger.i('🩺 [DIAGNOSES] Successfully loaded ${diagnoses.length} diagnoses for current user');
      return diagnoses;
    } catch (e) {
      _logger.e('Error fetching diagnoses: $e');
      throw Exception('Failed to load diagnoses');
    }
  }

  Future<void> addDiagnosis(DiagnosisRecord diagnosis) async {
    try {
      await _supabase.from('diagnoses').insert(diagnosis.toJson());
      refreshDiagnoses(); // Refresh the state
    } catch (e) {
      _logger.e('Error adding diagnosis: $e');
      throw Exception('Failed to add diagnosis');
    }
  }

  Future<void> updateDiagnosis(DiagnosisRecord diagnosis) async {
    try {
      await _supabase
          .from('diagnoses')
          .update(diagnosis.toJson())
          .eq('id', diagnosis.id);
      refreshDiagnoses(); // Refresh the state
    } catch (e) {
      _logger.e('Error updating diagnosis: $e');
      throw Exception('Failed to update diagnosis');
    }
  }

  Future<void> deleteDiagnosis(String diagnosisId) async {
    try {
      await _supabase
          .from('diagnoses')
          .delete()
          .eq('id', diagnosisId);
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