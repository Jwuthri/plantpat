class Diagnosis {
  final String id;
  final String plantId;
  final String imageUrl;
  final List<HealthIssue> detectedIssues;
  final double overallHealthScore; // 0.0 to 1.0
  final DiagnosisStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final String? userNotes;
  final String? treatmentApplied;
  final DateTime? followUpDate;

  const Diagnosis({
    required this.id,
    required this.plantId,
    required this.imageUrl,
    required this.detectedIssues,
    required this.overallHealthScore,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.userNotes,
    this.treatmentApplied,
    this.followUpDate,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) => Diagnosis(
        id: json['id'] as String,
        plantId: json['plant_id'] as String,
        imageUrl: json['image_url'] as String,
        detectedIssues: (json['detected_issues'] as List)
            .map((e) => HealthIssue.fromJson(e))
            .toList(),
        overallHealthScore: json['overall_health_score'] as double,
        status: DiagnosisStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
        ),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        isDeleted: json['is_deleted'] as bool? ?? false,
        userNotes: json['user_notes'] as String?,
        treatmentApplied: json['treatment_applied'] as String?,
        followUpDate: json['follow_up_date'] != null
            ? DateTime.parse(json['follow_up_date'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'plant_id': plantId,
        'image_url': imageUrl,
        'detected_issues': detectedIssues.map((e) => e.toJson()).toList(),
        'overall_health_score': overallHealthScore,
        'status': status.toString().split('.').last,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_deleted': isDeleted,
        'user_notes': userNotes,
        'treatment_applied': treatmentApplied,
        'follow_up_date': followUpDate?.toIso8601String(),
      };
}

class HealthIssue {
  final String name;
  final String description;
  final IssueType type;
  final IssueSeverity severity;
  final double confidence; // 0.0 to 1.0
  final List<String> symptoms;
  final List<TreatmentOption> treatments;
  final String? cause;
  final String? prevention;

  const HealthIssue({
    required this.name,
    required this.description,
    required this.type,
    required this.severity,
    required this.confidence,
    required this.symptoms,
    required this.treatments,
    this.cause,
    this.prevention,
  });

  factory HealthIssue.fromJson(Map<String, dynamic> json) => HealthIssue(
        name: json['name'] as String,
        description: json['description'] as String,
        type: IssueType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
        ),
        severity: IssueSeverity.values.firstWhere(
          (e) => e.toString().split('.').last == json['severity'],
        ),
        confidence: json['confidence'] as double,
        symptoms: (json['symptoms'] as List).cast<String>(),
        treatments: (json['treatments'] as List)
            .map((e) => TreatmentOption.fromJson(e))
            .toList(),
        cause: json['cause'] as String?,
        prevention: json['prevention'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type.toString().split('.').last,
        'severity': severity.toString().split('.').last,
        'confidence': confidence,
        'symptoms': symptoms,
        'treatments': treatments.map((e) => e.toJson()).toList(),
        'cause': cause,
        'prevention': prevention,
      };
}

class TreatmentOption {
  final String title;
  final String description;
  final List<String> steps;
  final TreatmentUrgency urgency;
  final String? estimatedTime;
  final List<String>? requiredMaterials;

  const TreatmentOption({
    required this.title,
    required this.description,
    required this.steps,
    required this.urgency,
    this.estimatedTime,
    this.requiredMaterials,
  });

  factory TreatmentOption.fromJson(Map<String, dynamic> json) =>
      TreatmentOption(
        title: json['title'] as String,
        description: json['description'] as String,
        steps: (json['steps'] as List).cast<String>(),
        urgency: TreatmentUrgency.values.firstWhere(
          (e) => e.toString().split('.').last == json['urgency'],
        ),
        estimatedTime: json['estimated_time'] as String?,
        requiredMaterials: (json['required_materials'] as List?)?.cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'steps': steps,
        'urgency': urgency.toString().split('.').last,
        'estimated_time': estimatedTime,
        'required_materials': requiredMaterials,
      };
}

enum DiagnosisStatus {
  processing,
  completed,
  failed,
  reviewing,
}

enum IssueType {
  disease,
  pest,
  nutrientDeficiency,
  wateringIssue,
  environmental,
  physicalDamage,
  fungal,
  bacterial,
  viral,
}

enum IssueSeverity {
  low,
  moderate,
  high,
  critical,
}

enum TreatmentUrgency {
  immediate,
  within24h,
  withinWeek,
  routine,
} 