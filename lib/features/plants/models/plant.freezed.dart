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
  String get scientificName => throw _privateConstructorUsedError;
  String get commonName => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  PlantCareInfo get careInfo => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  String? get userNotes => throw _privateConstructorUsedError;
  DateTime? get lastWatered => throw _privateConstructorUsedError;
  DateTime? get lastFertilized => throw _privateConstructorUsedError;
  DateTime? get nextWateringDate => throw _privateConstructorUsedError;
  DateTime? get nextFertilizingDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      String scientificName,
      String commonName,
      String category,
      String imageUrl,
      String description,
      PlantCareInfo careInfo,
      List<String> tags,
      DateTime createdAt,
      DateTime updatedAt,
      bool isDeleted,
      bool isFavorite,
      String? userNotes,
      DateTime? lastWatered,
      DateTime? lastFertilized,
      DateTime? nextWateringDate,
      DateTime? nextFertilizingDate});

  $PlantCareInfoCopyWith<$Res> get careInfo;
}

/// @nodoc
class _$PlantCopyWithImpl<$Res, $Val extends Plant>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scientificName = null,
    Object? commonName = null,
    Object? category = null,
    Object? imageUrl = null,
    Object? description = null,
    Object? careInfo = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? isFavorite = null,
    Object? userNotes = freezed,
    Object? lastWatered = freezed,
    Object? lastFertilized = freezed,
    Object? nextWateringDate = freezed,
    Object? nextFertilizingDate = freezed,
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
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      careInfo: null == careInfo
          ? _value.careInfo
          : careInfo // ignore: cast_nullable_to_non_nullable
              as PlantCareInfo,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      userNotes: freezed == userNotes
          ? _value.userNotes
          : userNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastWatered: freezed == lastWatered
          ? _value.lastWatered
          : lastWatered // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastFertilized: freezed == lastFertilized
          ? _value.lastFertilized
          : lastFertilized // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextWateringDate: freezed == nextWateringDate
          ? _value.nextWateringDate
          : nextWateringDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextFertilizingDate: freezed == nextFertilizingDate
          ? _value.nextFertilizingDate
          : nextFertilizingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantCareInfoCopyWith<$Res> get careInfo {
    return $PlantCareInfoCopyWith<$Res>(_value.careInfo, (value) {
      return _then(_value.copyWith(careInfo: value) as $Val);
    });
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
      String scientificName,
      String commonName,
      String category,
      String imageUrl,
      String description,
      PlantCareInfo careInfo,
      List<String> tags,
      DateTime createdAt,
      DateTime updatedAt,
      bool isDeleted,
      bool isFavorite,
      String? userNotes,
      DateTime? lastWatered,
      DateTime? lastFertilized,
      DateTime? nextWateringDate,
      DateTime? nextFertilizingDate});

  @override
  $PlantCareInfoCopyWith<$Res> get careInfo;
}

/// @nodoc
class __$$PlantImplCopyWithImpl<$Res>
    extends _$PlantCopyWithImpl<$Res, _$PlantImpl>
    implements _$$PlantImplCopyWith<$Res> {
  __$$PlantImplCopyWithImpl(
      _$PlantImpl _value, $Res Function(_$PlantImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scientificName = null,
    Object? commonName = null,
    Object? category = null,
    Object? imageUrl = null,
    Object? description = null,
    Object? careInfo = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? isFavorite = null,
    Object? userNotes = freezed,
    Object? lastWatered = freezed,
    Object? lastFertilized = freezed,
    Object? nextWateringDate = freezed,
    Object? nextFertilizingDate = freezed,
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
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      careInfo: null == careInfo
          ? _value.careInfo
          : careInfo // ignore: cast_nullable_to_non_nullable
              as PlantCareInfo,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      userNotes: freezed == userNotes
          ? _value.userNotes
          : userNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastWatered: freezed == lastWatered
          ? _value.lastWatered
          : lastWatered // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastFertilized: freezed == lastFertilized
          ? _value.lastFertilized
          : lastFertilized // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextWateringDate: freezed == nextWateringDate
          ? _value.nextWateringDate
          : nextWateringDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextFertilizingDate: freezed == nextFertilizingDate
          ? _value.nextFertilizingDate
          : nextFertilizingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantImpl implements _Plant {
  const _$PlantImpl(
      {required this.id,
      required this.name,
      required this.scientificName,
      required this.commonName,
      required this.category,
      required this.imageUrl,
      required this.description,
      required this.careInfo,
      required final List<String> tags,
      required this.createdAt,
      required this.updatedAt,
      this.isDeleted = false,
      this.isFavorite = false,
      this.userNotes,
      this.lastWatered,
      this.lastFertilized,
      this.nextWateringDate,
      this.nextFertilizingDate})
      : _tags = tags;

  factory _$PlantImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String scientificName;
  @override
  final String commonName;
  @override
  final String category;
  @override
  final String imageUrl;
  @override
  final String description;
  @override
  final PlantCareInfo careInfo;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final String? userNotes;
  @override
  final DateTime? lastWatered;
  @override
  final DateTime? lastFertilized;
  @override
  final DateTime? nextWateringDate;
  @override
  final DateTime? nextFertilizingDate;

  @override
  String toString() {
    return 'Plant(id: $id, name: $name, scientificName: $scientificName, commonName: $commonName, category: $category, imageUrl: $imageUrl, description: $description, careInfo: $careInfo, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, isFavorite: $isFavorite, userNotes: $userNotes, lastWatered: $lastWatered, lastFertilized: $lastFertilized, nextWateringDate: $nextWateringDate, nextFertilizingDate: $nextFertilizingDate)';
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
            (identical(other.commonName, commonName) ||
                other.commonName == commonName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.careInfo, careInfo) ||
                other.careInfo == careInfo) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.userNotes, userNotes) ||
                other.userNotes == userNotes) &&
            (identical(other.lastWatered, lastWatered) ||
                other.lastWatered == lastWatered) &&
            (identical(other.lastFertilized, lastFertilized) ||
                other.lastFertilized == lastFertilized) &&
            (identical(other.nextWateringDate, nextWateringDate) ||
                other.nextWateringDate == nextWateringDate) &&
            (identical(other.nextFertilizingDate, nextFertilizingDate) ||
                other.nextFertilizingDate == nextFertilizingDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      scientificName,
      commonName,
      category,
      imageUrl,
      description,
      careInfo,
      const DeepCollectionEquality().hash(_tags),
      createdAt,
      updatedAt,
      isDeleted,
      isFavorite,
      userNotes,
      lastWatered,
      lastFertilized,
      nextWateringDate,
      nextFertilizingDate);

  @JsonKey(ignore: true)
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
      required final String scientificName,
      required final String commonName,
      required final String category,
      required final String imageUrl,
      required final String description,
      required final PlantCareInfo careInfo,
      required final List<String> tags,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isDeleted,
      final bool isFavorite,
      final String? userNotes,
      final DateTime? lastWatered,
      final DateTime? lastFertilized,
      final DateTime? nextWateringDate,
      final DateTime? nextFertilizingDate}) = _$PlantImpl;

  factory _Plant.fromJson(Map<String, dynamic> json) = _$PlantImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get scientificName;
  @override
  String get commonName;
  @override
  String get category;
  @override
  String get imageUrl;
  @override
  String get description;
  @override
  PlantCareInfo get careInfo;
  @override
  List<String> get tags;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  bool get isFavorite;
  @override
  String? get userNotes;
  @override
  DateTime? get lastWatered;
  @override
  DateTime? get lastFertilized;
  @override
  DateTime? get nextWateringDate;
  @override
  DateTime? get nextFertilizingDate;
  @override
  @JsonKey(ignore: true)
  _$$PlantImplCopyWith<_$PlantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlantCareInfo _$PlantCareInfoFromJson(Map<String, dynamic> json) {
  return _PlantCareInfo.fromJson(json);
}

/// @nodoc
mixin _$PlantCareInfo {
  String get lightRequirement => throw _privateConstructorUsedError;
  String get wateringFrequency => throw _privateConstructorUsedError;
  String get soilType => throw _privateConstructorUsedError;
  String get humidity => throw _privateConstructorUsedError;
  String get temperature => throw _privateConstructorUsedError;
  List<String> get fertilizingSchedule => throw _privateConstructorUsedError;
  List<String> get commonProblems => throw _privateConstructorUsedError;
  List<String> get careInstructions => throw _privateConstructorUsedError;
  String? get repottingInfo => throw _privateConstructorUsedError;
  String? get pruningInfo => throw _privateConstructorUsedError;
  List<String>? get toxicityWarnings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantCareInfoCopyWith<PlantCareInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantCareInfoCopyWith<$Res> {
  factory $PlantCareInfoCopyWith(
          PlantCareInfo value, $Res Function(PlantCareInfo) then) =
      _$PlantCareInfoCopyWithImpl<$Res, PlantCareInfo>;
  @useResult
  $Res call(
      {String lightRequirement,
      String wateringFrequency,
      String soilType,
      String humidity,
      String temperature,
      List<String> fertilizingSchedule,
      List<String> commonProblems,
      List<String> careInstructions,
      String? repottingInfo,
      String? pruningInfo,
      List<String>? toxicityWarnings});
}

/// @nodoc
class _$PlantCareInfoCopyWithImpl<$Res, $Val extends PlantCareInfo>
    implements $PlantCareInfoCopyWith<$Res> {
  _$PlantCareInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lightRequirement = null,
    Object? wateringFrequency = null,
    Object? soilType = null,
    Object? humidity = null,
    Object? temperature = null,
    Object? fertilizingSchedule = null,
    Object? commonProblems = null,
    Object? careInstructions = null,
    Object? repottingInfo = freezed,
    Object? pruningInfo = freezed,
    Object? toxicityWarnings = freezed,
  }) {
    return _then(_value.copyWith(
      lightRequirement: null == lightRequirement
          ? _value.lightRequirement
          : lightRequirement // ignore: cast_nullable_to_non_nullable
              as String,
      wateringFrequency: null == wateringFrequency
          ? _value.wateringFrequency
          : wateringFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      soilType: null == soilType
          ? _value.soilType
          : soilType // ignore: cast_nullable_to_non_nullable
              as String,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as String,
      fertilizingSchedule: null == fertilizingSchedule
          ? _value.fertilizingSchedule
          : fertilizingSchedule // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commonProblems: null == commonProblems
          ? _value.commonProblems
          : commonProblems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      careInstructions: null == careInstructions
          ? _value.careInstructions
          : careInstructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      repottingInfo: freezed == repottingInfo
          ? _value.repottingInfo
          : repottingInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      pruningInfo: freezed == pruningInfo
          ? _value.pruningInfo
          : pruningInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      toxicityWarnings: freezed == toxicityWarnings
          ? _value.toxicityWarnings
          : toxicityWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantCareInfoImplCopyWith<$Res>
    implements $PlantCareInfoCopyWith<$Res> {
  factory _$$PlantCareInfoImplCopyWith(
          _$PlantCareInfoImpl value, $Res Function(_$PlantCareInfoImpl) then) =
      __$$PlantCareInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lightRequirement,
      String wateringFrequency,
      String soilType,
      String humidity,
      String temperature,
      List<String> fertilizingSchedule,
      List<String> commonProblems,
      List<String> careInstructions,
      String? repottingInfo,
      String? pruningInfo,
      List<String>? toxicityWarnings});
}

/// @nodoc
class __$$PlantCareInfoImplCopyWithImpl<$Res>
    extends _$PlantCareInfoCopyWithImpl<$Res, _$PlantCareInfoImpl>
    implements _$$PlantCareInfoImplCopyWith<$Res> {
  __$$PlantCareInfoImplCopyWithImpl(
      _$PlantCareInfoImpl _value, $Res Function(_$PlantCareInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lightRequirement = null,
    Object? wateringFrequency = null,
    Object? soilType = null,
    Object? humidity = null,
    Object? temperature = null,
    Object? fertilizingSchedule = null,
    Object? commonProblems = null,
    Object? careInstructions = null,
    Object? repottingInfo = freezed,
    Object? pruningInfo = freezed,
    Object? toxicityWarnings = freezed,
  }) {
    return _then(_$PlantCareInfoImpl(
      lightRequirement: null == lightRequirement
          ? _value.lightRequirement
          : lightRequirement // ignore: cast_nullable_to_non_nullable
              as String,
      wateringFrequency: null == wateringFrequency
          ? _value.wateringFrequency
          : wateringFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      soilType: null == soilType
          ? _value.soilType
          : soilType // ignore: cast_nullable_to_non_nullable
              as String,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as String,
      fertilizingSchedule: null == fertilizingSchedule
          ? _value._fertilizingSchedule
          : fertilizingSchedule // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commonProblems: null == commonProblems
          ? _value._commonProblems
          : commonProblems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      careInstructions: null == careInstructions
          ? _value._careInstructions
          : careInstructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      repottingInfo: freezed == repottingInfo
          ? _value.repottingInfo
          : repottingInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      pruningInfo: freezed == pruningInfo
          ? _value.pruningInfo
          : pruningInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      toxicityWarnings: freezed == toxicityWarnings
          ? _value._toxicityWarnings
          : toxicityWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantCareInfoImpl implements _PlantCareInfo {
  const _$PlantCareInfoImpl(
      {required this.lightRequirement,
      required this.wateringFrequency,
      required this.soilType,
      required this.humidity,
      required this.temperature,
      required final List<String> fertilizingSchedule,
      required final List<String> commonProblems,
      required final List<String> careInstructions,
      this.repottingInfo,
      this.pruningInfo,
      final List<String>? toxicityWarnings})
      : _fertilizingSchedule = fertilizingSchedule,
        _commonProblems = commonProblems,
        _careInstructions = careInstructions,
        _toxicityWarnings = toxicityWarnings;

  factory _$PlantCareInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantCareInfoImplFromJson(json);

  @override
  final String lightRequirement;
  @override
  final String wateringFrequency;
  @override
  final String soilType;
  @override
  final String humidity;
  @override
  final String temperature;
  final List<String> _fertilizingSchedule;
  @override
  List<String> get fertilizingSchedule {
    if (_fertilizingSchedule is EqualUnmodifiableListView)
      return _fertilizingSchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fertilizingSchedule);
  }

  final List<String> _commonProblems;
  @override
  List<String> get commonProblems {
    if (_commonProblems is EqualUnmodifiableListView) return _commonProblems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonProblems);
  }

  final List<String> _careInstructions;
  @override
  List<String> get careInstructions {
    if (_careInstructions is EqualUnmodifiableListView)
      return _careInstructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_careInstructions);
  }

  @override
  final String? repottingInfo;
  @override
  final String? pruningInfo;
  final List<String>? _toxicityWarnings;
  @override
  List<String>? get toxicityWarnings {
    final value = _toxicityWarnings;
    if (value == null) return null;
    if (_toxicityWarnings is EqualUnmodifiableListView)
      return _toxicityWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PlantCareInfo(lightRequirement: $lightRequirement, wateringFrequency: $wateringFrequency, soilType: $soilType, humidity: $humidity, temperature: $temperature, fertilizingSchedule: $fertilizingSchedule, commonProblems: $commonProblems, careInstructions: $careInstructions, repottingInfo: $repottingInfo, pruningInfo: $pruningInfo, toxicityWarnings: $toxicityWarnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantCareInfoImpl &&
            (identical(other.lightRequirement, lightRequirement) ||
                other.lightRequirement == lightRequirement) &&
            (identical(other.wateringFrequency, wateringFrequency) ||
                other.wateringFrequency == wateringFrequency) &&
            (identical(other.soilType, soilType) ||
                other.soilType == soilType) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            const DeepCollectionEquality()
                .equals(other._fertilizingSchedule, _fertilizingSchedule) &&
            const DeepCollectionEquality()
                .equals(other._commonProblems, _commonProblems) &&
            const DeepCollectionEquality()
                .equals(other._careInstructions, _careInstructions) &&
            (identical(other.repottingInfo, repottingInfo) ||
                other.repottingInfo == repottingInfo) &&
            (identical(other.pruningInfo, pruningInfo) ||
                other.pruningInfo == pruningInfo) &&
            const DeepCollectionEquality()
                .equals(other._toxicityWarnings, _toxicityWarnings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lightRequirement,
      wateringFrequency,
      soilType,
      humidity,
      temperature,
      const DeepCollectionEquality().hash(_fertilizingSchedule),
      const DeepCollectionEquality().hash(_commonProblems),
      const DeepCollectionEquality().hash(_careInstructions),
      repottingInfo,
      pruningInfo,
      const DeepCollectionEquality().hash(_toxicityWarnings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantCareInfoImplCopyWith<_$PlantCareInfoImpl> get copyWith =>
      __$$PlantCareInfoImplCopyWithImpl<_$PlantCareInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantCareInfoImplToJson(
      this,
    );
  }
}

abstract class _PlantCareInfo implements PlantCareInfo {
  const factory _PlantCareInfo(
      {required final String lightRequirement,
      required final String wateringFrequency,
      required final String soilType,
      required final String humidity,
      required final String temperature,
      required final List<String> fertilizingSchedule,
      required final List<String> commonProblems,
      required final List<String> careInstructions,
      final String? repottingInfo,
      final String? pruningInfo,
      final List<String>? toxicityWarnings}) = _$PlantCareInfoImpl;

  factory _PlantCareInfo.fromJson(Map<String, dynamic> json) =
      _$PlantCareInfoImpl.fromJson;

  @override
  String get lightRequirement;
  @override
  String get wateringFrequency;
  @override
  String get soilType;
  @override
  String get humidity;
  @override
  String get temperature;
  @override
  List<String> get fertilizingSchedule;
  @override
  List<String> get commonProblems;
  @override
  List<String> get careInstructions;
  @override
  String? get repottingInfo;
  @override
  String? get pruningInfo;
  @override
  List<String>? get toxicityWarnings;
  @override
  @JsonKey(ignore: true)
  _$$PlantCareInfoImplCopyWith<_$PlantCareInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
} 