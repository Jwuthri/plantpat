// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantImpl _$$PlantImplFromJson(Map<String, dynamic> json) => _$PlantImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      scientificName: json['scientific_name'] as String?,
      commonNames: (json['common_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      species: json['species'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      careInstructions: json['care_instructions'] as Map<String, dynamic>?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      isFavorite: json['isFavorite'] as bool? ?? false,
      profileId: json['profile_id'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      healthStatus: json['health_status'] as Map<String, dynamic>?,
      location: json['location'] as Map<String, dynamic>?,
      careHistory: json['care_history'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$$PlantImplToJson(_$PlantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scientific_name': instance.scientificName,
      'common_names': instance.commonNames,
      'species': instance.species,
      'images': instance.images,
      'description': instance.description,
      'care_instructions': instance.careInstructions,
      'tags': instance.tags,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_active': instance.isActive,
      'isFavorite': instance.isFavorite,
      'profile_id': instance.profileId,
      'confidence': instance.confidence,
      'health_status': instance.healthStatus,
      'location': instance.location,
      'care_history': instance.careHistory,
    };
