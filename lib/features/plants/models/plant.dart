import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';
part 'plant.g.dart';

@freezed
class Plant with _$Plant {
  const factory Plant({
    required String id,
    required String name,
    required String scientificName,
    required String commonName,
    required String category, // houseplant, outdoor, herb, flower, etc.
    required String imageUrl,
    required String description,
    required PlantCareInfo careInfo,
    required List<String> tags,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isActive,
    @Default(false) bool isFavorite,
    String? userNotes,
    DateTime? lastWatered,
    DateTime? lastFertilized,
    DateTime? nextWateringDate,
    DateTime? nextFertilizingDate,
  }) = _Plant;

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);
}

@freezed
class PlantCareInfo with _$PlantCareInfo {
  const factory PlantCareInfo({
    required String lightRequirement, // low, medium, high, bright indirect
    required String wateringFrequency, // daily, weekly, bi-weekly, monthly
    required String soilType, // well-draining, moist, dry, sandy, etc.
    required String humidity, // low, medium, high
    required String temperature, // cool, moderate, warm
    required List<String> fertilizingSchedule,
    required List<String> commonProblems,
    required List<String> careInstructions,
    String? repottingInfo,
    String? pruningInfo,
    List<String>? toxicityWarnings,
  }) = _PlantCareInfo;

  factory PlantCareInfo.fromJson(Map<String, dynamic> json) => 
      _$PlantCareInfoFromJson(json);
} 