import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnosis_database.freezed.dart';
part 'diagnosis_database.g.dart';

@freezed
class DiagnosisRecord with _$DiagnosisRecord {
  const factory DiagnosisRecord({
    required String id,
    @JsonKey(name: 'profile_id') String? profileId,
    @JsonKey(name: 'plant_id') String? plantId,
    @Default([]) List<String> images,
    @JsonKey(name: 'ai_analysis') required Map<String, dynamic> aiAnalysis,
    @JsonKey(name: 'user_feedback') Map<String, dynamic>? userFeedback,
    @Default('completed') String status,
    Map<String, dynamic>? error,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Plant information from join
    Map<String, dynamic>? plants,
  }) = _DiagnosisRecord;

  factory DiagnosisRecord.fromJson(Map<String, dynamic> json) => _$DiagnosisRecordFromJson(json);
}

// Helper extension for easy access to diagnosis data
extension DiagnosisRecordHelpers on DiagnosisRecord {
  String get overallHealth => aiAnalysis['health_assessment']?['overall_health'] ?? 'unknown';
  double get healthConfidence => (aiAnalysis['health_assessment']?['confidence'] ?? 0.0).toDouble();
  List<dynamic> get healthIssues => aiAnalysis['health_assessment']?['issues'] ?? [];
  List<dynamic> get immediateActions => aiAnalysis['care_recommendations']?['immediate'] ?? [];
  List<dynamic> get ongoingCare => aiAnalysis['care_recommendations']?['ongoing'] ?? [];
  List<dynamic> get preventiveCare => aiAnalysis['care_recommendations']?['preventive'] ?? [];
  
  String get identifiedSpecies => aiAnalysis['plant_identification']?['species'] ?? 'Unknown';
  String get scientificName => aiAnalysis['plant_identification']?['scientific_name'] ?? '';
  double get identificationConfidence => (aiAnalysis['plant_identification']?['confidence'] ?? 0.0).toDouble();
  
  // Plant information from linked plant record
  String get plantName => plants?['name'] ?? 'Unknown Plant';
  String get plantScientificName => plants?['scientific_name'] ?? '';
  String get plantSpecies => plants?['species'] ?? '';
  double get plantConfidence => (plants?['confidence'] ?? 0.0).toDouble();
  
  // Check if diagnosis has a linked plant
  bool get hasLinkedPlant => plantId != null && plants != null;
}