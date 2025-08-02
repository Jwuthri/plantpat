// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantImpl _$$PlantImplFromJson(Map<String, dynamic> json) => _$PlantImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      scientificName: json['scientificName'] as String,
      commonName: json['commonName'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      careInfo:
          PlantCareInfo.fromJson(json['careInfo'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isFavorite: json['isFavorite'] as bool? ?? false,
      userNotes: json['userNotes'] as String?,
      lastWatered: json['lastWatered'] == null
          ? null
          : DateTime.parse(json['lastWatered'] as String),
      lastFertilized: json['lastFertilized'] == null
          ? null
          : DateTime.parse(json['lastFertilized'] as String),
      nextWateringDate: json['nextWateringDate'] == null
          ? null
          : DateTime.parse(json['nextWateringDate'] as String),
      nextFertilizingDate: json['nextFertilizingDate'] == null
          ? null
          : DateTime.parse(json['nextFertilizingDate'] as String),
    );

Map<String, dynamic> _$$PlantImplToJson(_$PlantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scientificName': instance.scientificName,
      'commonName': instance.commonName,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'careInfo': instance.careInfo,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isActive': instance.isActive,
      'isFavorite': instance.isFavorite,
      'userNotes': instance.userNotes,
      'lastWatered': instance.lastWatered?.toIso8601String(),
      'lastFertilized': instance.lastFertilized?.toIso8601String(),
      'nextWateringDate': instance.nextWateringDate?.toIso8601String(),
      'nextFertilizingDate': instance.nextFertilizingDate?.toIso8601String(),
    };

_$PlantCareInfoImpl _$$PlantCareInfoImplFromJson(Map<String, dynamic> json) =>
    _$PlantCareInfoImpl(
      lightRequirement: json['lightRequirement'] as String,
      wateringFrequency: json['wateringFrequency'] as String,
      soilType: json['soilType'] as String,
      humidity: json['humidity'] as String,
      temperature: json['temperature'] as String,
      fertilizingSchedule: (json['fertilizingSchedule'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      commonProblems: (json['commonProblems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      careInstructions: (json['careInstructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      repottingInfo: json['repottingInfo'] as String?,
      pruningInfo: json['pruningInfo'] as String?,
      toxicityWarnings: (json['toxicityWarnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PlantCareInfoImplToJson(_$PlantCareInfoImpl instance) =>
    <String, dynamic>{
      'lightRequirement': instance.lightRequirement,
      'wateringFrequency': instance.wateringFrequency,
      'soilType': instance.soilType,
      'humidity': instance.humidity,
      'temperature': instance.temperature,
      'fertilizingSchedule': instance.fertilizingSchedule,
      'commonProblems': instance.commonProblems,
      'careInstructions': instance.careInstructions,
      'repottingInfo': instance.repottingInfo,
      'pruningInfo': instance.pruningInfo,
      'toxicityWarnings': instance.toxicityWarnings,
    };
