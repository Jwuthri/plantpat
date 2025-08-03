// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnosis_database.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DiagnosisRecord _$DiagnosisRecordFromJson(Map<String, dynamic> json) {
  return _DiagnosisRecord.fromJson(json);
}

/// @nodoc
mixin _$DiagnosisRecord {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_id')
  String? get profileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_id')
  String? get plantId => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_analysis')
  Map<String, dynamic> get aiAnalysis => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_feedback')
  Map<String, dynamic>? get userFeedback => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get error => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Plant information from join
  Map<String, dynamic>? get plants => throw _privateConstructorUsedError;

  /// Serializes this DiagnosisRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiagnosisRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosisRecordCopyWith<DiagnosisRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosisRecordCopyWith<$Res> {
  factory $DiagnosisRecordCopyWith(
          DiagnosisRecord value, $Res Function(DiagnosisRecord) then) =
      _$DiagnosisRecordCopyWithImpl<$Res, DiagnosisRecord>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'profile_id') String? profileId,
      @JsonKey(name: 'plant_id') String? plantId,
      List<String> images,
      @JsonKey(name: 'ai_analysis') Map<String, dynamic> aiAnalysis,
      @JsonKey(name: 'user_feedback') Map<String, dynamic>? userFeedback,
      String status,
      Map<String, dynamic>? error,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      Map<String, dynamic>? plants});
}

/// @nodoc
class _$DiagnosisRecordCopyWithImpl<$Res, $Val extends DiagnosisRecord>
    implements $DiagnosisRecordCopyWith<$Res> {
  _$DiagnosisRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiagnosisRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = freezed,
    Object? plantId = freezed,
    Object? images = null,
    Object? aiAnalysis = null,
    Object? userFeedback = freezed,
    Object? status = null,
    Object? error = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? plants = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      plantId: freezed == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aiAnalysis: null == aiAnalysis
          ? _value.aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      userFeedback: freezed == userFeedback
          ? _value.userFeedback
          : userFeedback // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plants: freezed == plants
          ? _value.plants
          : plants // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiagnosisRecordImplCopyWith<$Res>
    implements $DiagnosisRecordCopyWith<$Res> {
  factory _$$DiagnosisRecordImplCopyWith(_$DiagnosisRecordImpl value,
          $Res Function(_$DiagnosisRecordImpl) then) =
      __$$DiagnosisRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'profile_id') String? profileId,
      @JsonKey(name: 'plant_id') String? plantId,
      List<String> images,
      @JsonKey(name: 'ai_analysis') Map<String, dynamic> aiAnalysis,
      @JsonKey(name: 'user_feedback') Map<String, dynamic>? userFeedback,
      String status,
      Map<String, dynamic>? error,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      Map<String, dynamic>? plants});
}

/// @nodoc
class __$$DiagnosisRecordImplCopyWithImpl<$Res>
    extends _$DiagnosisRecordCopyWithImpl<$Res, _$DiagnosisRecordImpl>
    implements _$$DiagnosisRecordImplCopyWith<$Res> {
  __$$DiagnosisRecordImplCopyWithImpl(
      _$DiagnosisRecordImpl _value, $Res Function(_$DiagnosisRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of DiagnosisRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = freezed,
    Object? plantId = freezed,
    Object? images = null,
    Object? aiAnalysis = null,
    Object? userFeedback = freezed,
    Object? status = null,
    Object? error = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? plants = freezed,
  }) {
    return _then(_$DiagnosisRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      plantId: freezed == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aiAnalysis: null == aiAnalysis
          ? _value._aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      userFeedback: freezed == userFeedback
          ? _value._userFeedback
          : userFeedback // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value._error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plants: freezed == plants
          ? _value._plants
          : plants // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagnosisRecordImpl implements _DiagnosisRecord {
  const _$DiagnosisRecordImpl(
      {required this.id,
      @JsonKey(name: 'profile_id') this.profileId,
      @JsonKey(name: 'plant_id') this.plantId,
      final List<String> images = const [],
      @JsonKey(name: 'ai_analysis')
      required final Map<String, dynamic> aiAnalysis,
      @JsonKey(name: 'user_feedback') final Map<String, dynamic>? userFeedback,
      this.status = 'completed',
      final Map<String, dynamic>? error,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      final Map<String, dynamic>? plants})
      : _images = images,
        _aiAnalysis = aiAnalysis,
        _userFeedback = userFeedback,
        _error = error,
        _plants = plants;

  factory _$DiagnosisRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagnosisRecordImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'profile_id')
  final String? profileId;
  @override
  @JsonKey(name: 'plant_id')
  final String? plantId;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final Map<String, dynamic> _aiAnalysis;
  @override
  @JsonKey(name: 'ai_analysis')
  Map<String, dynamic> get aiAnalysis {
    if (_aiAnalysis is EqualUnmodifiableMapView) return _aiAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_aiAnalysis);
  }

  final Map<String, dynamic>? _userFeedback;
  @override
  @JsonKey(name: 'user_feedback')
  Map<String, dynamic>? get userFeedback {
    final value = _userFeedback;
    if (value == null) return null;
    if (_userFeedback is EqualUnmodifiableMapView) return _userFeedback;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String status;
  final Map<String, dynamic>? _error;
  @override
  Map<String, dynamic>? get error {
    final value = _error;
    if (value == null) return null;
    if (_error is EqualUnmodifiableMapView) return _error;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// Plant information from join
  final Map<String, dynamic>? _plants;
// Plant information from join
  @override
  Map<String, dynamic>? get plants {
    final value = _plants;
    if (value == null) return null;
    if (_plants is EqualUnmodifiableMapView) return _plants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DiagnosisRecord(id: $id, profileId: $profileId, plantId: $plantId, images: $images, aiAnalysis: $aiAnalysis, userFeedback: $userFeedback, status: $status, error: $error, createdAt: $createdAt, updatedAt: $updatedAt, plants: $plants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosisRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._aiAnalysis, _aiAnalysis) &&
            const DeepCollectionEquality()
                .equals(other._userFeedback, _userFeedback) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._error, _error) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._plants, _plants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      profileId,
      plantId,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_aiAnalysis),
      const DeepCollectionEquality().hash(_userFeedback),
      status,
      const DeepCollectionEquality().hash(_error),
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_plants));

  /// Create a copy of DiagnosisRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosisRecordImplCopyWith<_$DiagnosisRecordImpl> get copyWith =>
      __$$DiagnosisRecordImplCopyWithImpl<_$DiagnosisRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagnosisRecordImplToJson(
      this,
    );
  }
}

abstract class _DiagnosisRecord implements DiagnosisRecord {
  const factory _DiagnosisRecord(
      {required final String id,
      @JsonKey(name: 'profile_id') final String? profileId,
      @JsonKey(name: 'plant_id') final String? plantId,
      final List<String> images,
      @JsonKey(name: 'ai_analysis')
      required final Map<String, dynamic> aiAnalysis,
      @JsonKey(name: 'user_feedback') final Map<String, dynamic>? userFeedback,
      final String status,
      final Map<String, dynamic>? error,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final Map<String, dynamic>? plants}) = _$DiagnosisRecordImpl;

  factory _DiagnosisRecord.fromJson(Map<String, dynamic> json) =
      _$DiagnosisRecordImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'profile_id')
  String? get profileId;
  @override
  @JsonKey(name: 'plant_id')
  String? get plantId;
  @override
  List<String> get images;
  @override
  @JsonKey(name: 'ai_analysis')
  Map<String, dynamic> get aiAnalysis;
  @override
  @JsonKey(name: 'user_feedback')
  Map<String, dynamic>? get userFeedback;
  @override
  String get status;
  @override
  Map<String, dynamic>? get error;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt; // Plant information from join
  @override
  Map<String, dynamic>? get plants;

  /// Create a copy of DiagnosisRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosisRecordImplCopyWith<_$DiagnosisRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
