import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';
part 'plant.g.dart';

@freezed
class Plant with _$Plant {
  const factory Plant({
    required String id,
    required String name,
    @JsonKey(name: 'scientific_name') String? scientificName,
    @JsonKey(name: 'common_names') @Default([]) List<String> commonNames,
    String? species,
    @Default([]) List<String> images,
    String? description,
    @JsonKey(name: 'care_instructions') Map<String, dynamic>? careInstructions,
    @Default([]) List<String> tags,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(false) bool isFavorite,
    @JsonKey(name: 'profile_id') String? profileId,
    double? confidence,
    @JsonKey(name: 'health_status') Map<String, dynamic>? healthStatus,
    Map<String, dynamic>? location,
    @JsonKey(name: 'care_history') @Default([]) List<dynamic> careHistory,
  }) = _Plant;

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);
}

// Helper extension for easy access to care info
extension PlantCareHelpers on Plant {
  String get primaryCommonName => commonNames.isNotEmpty ? commonNames.first : name;
  String get displayName => primaryCommonName;
  String get primaryImage => images.isNotEmpty ? images.first : '';
  
  // Care instruction helpers
  String? get wateringFrequency => careInstructions?['watering']?['frequency'];
  String? get lightRequirement => careInstructions?['lighting']?['type'];
  String? get humidityLevel => careInstructions?['humidity']?['level'];
  String? get temperatureInfo => careInstructions?['temperature']?['notes'];
} 