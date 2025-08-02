// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Plant _$PlantFromJson(Map<String, dynamic> json) {
  return _Plant.fromJson(json);
}

/// @nodoc
mixin _$Plant {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'scientific_name')
  String? get scientificName => throw _privateConstructorUsedError;
  @JsonKey(name: 'common_names')
  List<String> get commonNames => throw _privateConstructorUsedError;
  String? get species => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'care_instructions')
  Map<String, dynamic>? get careInstructions =>
      throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_id')
  String? get profileId => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_status')
  Map<String, dynamic>? get healthStatus => throw _privateConstructorUsedError;
  Map<String, dynamic>? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'care_history')
  List<dynamic> get careHistory => throw _privateConstructorUsedError;

  /// Serializes this Plant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlantCopyWith<Plant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantCopyWith<$Res> {
  factory $PlantCopyWith(Plant value, $Res Function(Plant) then) =
      _$PlantCopyWithImpl<$Res, Plant>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'scientific_name') String? scientificName,
      @JsonKey(name: 'common_names') List<String> commonNames,
      String? species,
      List<String> images,
      String? description,
      @JsonKey(name: 'care_instructions')
      Map<String, dynamic>? careInstructions,
      List<String> tags,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_active') bool isActive,
      bool isFavorite,
      @JsonKey(name: 'profile_id') String? profileId,
      double? confidence,
      @JsonKey(name: 'health_status') Map<String, dynamic>? healthStatus,
      Map<String, dynamic>? location,
      @JsonKey(name: 'care_history') List<dynamic> careHistory});
}

/// @nodoc
class _$PlantCopyWithImpl<$Res, $Val extends Plant>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scientificName = freezed,
    Object? commonNames = null,
    Object? species = freezed,
    Object? images = null,
    Object? description = freezed,
    Object? careInstructions = freezed,
    Object? tags = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? isFavorite = null,
    Object? profileId = freezed,
    Object? confidence = freezed,
    Object? healthStatus = freezed,
    Object? location = freezed,
    Object? careHistory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
      commonNames: null == commonNames
          ? _value.commonNames
          : commonNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      species: freezed == species
          ? _value.species
          : species // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      careInstructions: freezed == careInstructions
          ? _value.careInstructions
          : careInstructions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      healthStatus: freezed == healthStatus
          ? _value.healthStatus
          : healthStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      careHistory: null == careHistory
          ? _value.careHistory
          : careHistory // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantImplCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$$PlantImplCopyWith(
          _$PlantImpl value, $Res Function(_$PlantImpl) then) =
      __$$PlantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'scientific_name') String? scientificName,
      @JsonKey(name: 'common_names') List<String> commonNames,
      String? species,
      List<String> images,
      String? description,
      @JsonKey(name: 'care_instructions')
      Map<String, dynamic>? careInstructions,
      List<String> tags,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_active') bool isActive,
      bool isFavorite,
      @JsonKey(name: 'profile_id') String? profileId,
      double? confidence,
      @JsonKey(name: 'health_status') Map<String, dynamic>? healthStatus,
      Map<String, dynamic>? location,
      @JsonKey(name: 'care_history') List<dynamic> careHistory});
}

/// @nodoc
class __$$PlantImplCopyWithImpl<$Res>
    extends _$PlantCopyWithImpl<$Res, _$PlantImpl>
    implements _$$PlantImplCopyWith<$Res> {
  __$$PlantImplCopyWithImpl(
      _$PlantImpl _value, $Res Function(_$PlantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scientificName = freezed,
    Object? commonNames = null,
    Object? species = freezed,
    Object? images = null,
    Object? description = freezed,
    Object? careInstructions = freezed,
    Object? tags = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? isFavorite = null,
    Object? profileId = freezed,
    Object? confidence = freezed,
    Object? healthStatus = freezed,
    Object? location = freezed,
    Object? careHistory = null,
  }) {
    return _then(_$PlantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
      commonNames: null == commonNames
          ? _value._commonNames
          : commonNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      species: freezed == species
          ? _value.species
          : species // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      careInstructions: freezed == careInstructions
          ? _value._careInstructions
          : careInstructions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      healthStatus: freezed == healthStatus
          ? _value._healthStatus
          : healthStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      location: freezed == location
          ? _value._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      careHistory: null == careHistory
          ? _value._careHistory
          : careHistory // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantImpl implements _Plant {
  const _$PlantImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'scientific_name') this.scientificName,
      @JsonKey(name: 'common_names') final List<String> commonNames = const [],
      this.species,
      final List<String> images = const [],
      this.description,
      @JsonKey(name: 'care_instructions')
      final Map<String, dynamic>? careInstructions,
      final List<String> tags = const [],
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'is_active') this.isActive = true,
      this.isFavorite = false,
      @JsonKey(name: 'profile_id') this.profileId,
      this.confidence,
      @JsonKey(name: 'health_status') final Map<String, dynamic>? healthStatus,
      final Map<String, dynamic>? location,
      @JsonKey(name: 'care_history')
      final List<dynamic> careHistory = const []})
      : _commonNames = commonNames,
        _images = images,
        _careInstructions = careInstructions,
        _tags = tags,
        _healthStatus = healthStatus,
        _location = location,
        _careHistory = careHistory;

  factory _$PlantImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'scientific_name')
  final String? scientificName;
  final List<String> _commonNames;
  @override
  @JsonKey(name: 'common_names')
  List<String> get commonNames {
    if (_commonNames is EqualUnmodifiableListView) return _commonNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonNames);
  }

  @override
  final String? species;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? description;
  final Map<String, dynamic>? _careInstructions;
  @override
  @JsonKey(name: 'care_instructions')
  Map<String, dynamic>? get careInstructions {
    final value = _careInstructions;
    if (value == null) return null;
    if (_careInstructions is EqualUnmodifiableMapView) return _careInstructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey(name: 'profile_id')
  final String? profileId;
  @override
  final double? confidence;
  final Map<String, dynamic>? _healthStatus;
  @override
  @JsonKey(name: 'health_status')
  Map<String, dynamic>? get healthStatus {
    final value = _healthStatus;
    if (value == null) return null;
    if (_healthStatus is EqualUnmodifiableMapView) return _healthStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _location;
  @override
  Map<String, dynamic>? get location {
    final value = _location;
    if (value == null) return null;
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<dynamic> _careHistory;
  @override
  @JsonKey(name: 'care_history')
  List<dynamic> get careHistory {
    if (_careHistory is EqualUnmodifiableListView) return _careHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_careHistory);
  }

  @override
  String toString() {
    return 'Plant(id: $id, name: $name, scientificName: $scientificName, commonNames: $commonNames, species: $species, images: $images, description: $description, careInstructions: $careInstructions, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, isFavorite: $isFavorite, profileId: $profileId, confidence: $confidence, healthStatus: $healthStatus, location: $location, careHistory: $careHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            const DeepCollectionEquality()
                .equals(other._commonNames, _commonNames) &&
            (identical(other.species, species) || other.species == species) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._careInstructions, _careInstructions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality()
                .equals(other._healthStatus, _healthStatus) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            const DeepCollectionEquality()
                .equals(other._careHistory, _careHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      scientificName,
      const DeepCollectionEquality().hash(_commonNames),
      species,
      const DeepCollectionEquality().hash(_images),
      description,
      const DeepCollectionEquality().hash(_careInstructions),
      const DeepCollectionEquality().hash(_tags),
      createdAt,
      updatedAt,
      isActive,
      isFavorite,
      profileId,
      confidence,
      const DeepCollectionEquality().hash(_healthStatus),
      const DeepCollectionEquality().hash(_location),
      const DeepCollectionEquality().hash(_careHistory));

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantImplCopyWith<_$PlantImpl> get copyWith =>
      __$$PlantImplCopyWithImpl<_$PlantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantImplToJson(
      this,
    );
  }
}

abstract class _Plant implements Plant {
  const factory _Plant(
      {required final String id,
      required final String name,
      @JsonKey(name: 'scientific_name') final String? scientificName,
      @JsonKey(name: 'common_names') final List<String> commonNames,
      final String? species,
      final List<String> images,
      final String? description,
      @JsonKey(name: 'care_instructions')
      final Map<String, dynamic>? careInstructions,
      final List<String> tags,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'is_active') final bool isActive,
      final bool isFavorite,
      @JsonKey(name: 'profile_id') final String? profileId,
      final double? confidence,
      @JsonKey(name: 'health_status') final Map<String, dynamic>? healthStatus,
      final Map<String, dynamic>? location,
      @JsonKey(name: 'care_history')
      final List<dynamic> careHistory}) = _$PlantImpl;

  factory _Plant.fromJson(Map<String, dynamic> json) = _$PlantImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'scientific_name')
  String? get scientificName;
  @override
  @JsonKey(name: 'common_names')
  List<String> get commonNames;
  @override
  String? get species;
  @override
  List<String> get images;
  @override
  String? get description;
  @override
  @JsonKey(name: 'care_instructions')
  Map<String, dynamic>? get careInstructions;
  @override
  List<String> get tags;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  bool get isFavorite;
  @override
  @JsonKey(name: 'profile_id')
  String? get profileId;
  @override
  double? get confidence;
  @override
  @JsonKey(name: 'health_status')
  Map<String, dynamic>? get healthStatus;
  @override
  Map<String, dynamic>? get location;
  @override
  @JsonKey(name: 'care_history')
  List<dynamic> get careHistory;

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlantImplCopyWith<_$PlantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
