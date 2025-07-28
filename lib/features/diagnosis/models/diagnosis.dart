import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnosis.freezed.dart';
part 'diagnosis.g.dart';

@freezed
class Diagnosis with _$Diagnosis {
  const factory Diagnosis({
    required String id,
    required String plantId,
    required String imageUrl,
    required List<HealthIssue> detectedIssues,
    required double overallHealthScore, // 0.0 to 1.0
    required DiagnosisStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
    String? userNotes,
    String? treatmentApplied,
    DateTime? followUpDate,
  }) = _Diagnosis;

  factory Diagnosis.fromJson(Map<String, dynamic> json) => 
      _$DiagnosisFromJson(json);
}

@freezed
class HealthIssue with _$HealthIssue {
  const factory HealthIssue({
    required String name,
    required String description,
    required IssueType type,
    required IssueSeverity severity,
    required double confidence, // 0.0 to 1.0
    required List<String> symptoms,
    required List<TreatmentOption> treatments,
    String? cause,
    String? prevention,
  }) = _HealthIssue;

  factory HealthIssue.fromJson(Map<String, dynamic> json) => 
      _$HealthIssueFromJson(json);
}

@freezed
class TreatmentOption with _$TreatmentOption {
  const factory TreatmentOption({
    required String title,
    required String description,
    required List<String> steps,
    required TreatmentUrgency urgency,
    String? estimatedTime,
    List<String>? requiredMaterials,
  }) = _TreatmentOption;

  factory TreatmentOption.fromJson(Map<String, dynamic> json) => 
      _$TreatmentOptionFromJson(json);
}

@JsonEnum()
enum DiagnosisStatus {
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('reviewing')
  reviewing,
}

@JsonEnum()
enum IssueType {
  @JsonValue('disease')
  disease,
  @JsonValue('pest')
  pest,
  @JsonValue('nutrient_deficiency')
  nutrientDeficiency,
  @JsonValue('watering_issue')
  wateringIssue,
  @JsonValue('environmental')
  environmental,
  @JsonValue('physical_damage')
  physicalDamage,
  @JsonValue('fungal')
  fungal,
  @JsonValue('bacterial')
  bacterial,
  @JsonValue('viral')
  viral,
}

@JsonEnum()
enum IssueSeverity {
  @JsonValue('low')
  low,
  @JsonValue('moderate')
  moderate,
  @JsonValue('high')
  high,
  @JsonValue('critical')
  critical,
}

@JsonEnum()
enum TreatmentUrgency {
  @JsonValue('immediate')
  immediate,
  @JsonValue('within_24h')
  within24h,
  @JsonValue('within_week')
  withinWeek,
  @JsonValue('routine')
  routine,
} 