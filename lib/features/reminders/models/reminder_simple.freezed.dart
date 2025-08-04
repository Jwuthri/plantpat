// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_simple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReminderSimple _$ReminderSimpleFromJson(Map<String, dynamic> json) {
  return _ReminderSimple.fromJson(json);
}

/// @nodoc
mixin _$ReminderSimple {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_id')
  String get profileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_id')
  String get plantId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime get dueDate => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get recurring => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurring_interval')
  String? get recurringInterval => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Plant information from join
  Map<String, dynamic>? get plants => throw _privateConstructorUsedError;

  /// Serializes this ReminderSimple to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReminderSimple
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderSimpleCopyWith<ReminderSimple> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderSimpleCopyWith<$Res> {
  factory $ReminderSimpleCopyWith(
          ReminderSimple value, $Res Function(ReminderSimple) then) =
      _$ReminderSimpleCopyWithImpl<$Res, ReminderSimple>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'profile_id') String profileId,
      @JsonKey(name: 'plant_id') String plantId,
      String type,
      String title,
      String? description,
      @JsonKey(name: 'due_date') DateTime dueDate,
      bool completed,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      bool recurring,
      @JsonKey(name: 'recurring_interval') String? recurringInterval,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      Map<String, dynamic>? plants});
}

/// @nodoc
class _$ReminderSimpleCopyWithImpl<$Res, $Val extends ReminderSimple>
    implements $ReminderSimpleCopyWith<$Res> {
  _$ReminderSimpleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderSimple
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? plantId = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = null,
    Object? completed = null,
    Object? completedAt = freezed,
    Object? recurring = null,
    Object? recurringInterval = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? plants = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurring: null == recurring
          ? _value.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringInterval: freezed == recurringInterval
          ? _value.recurringInterval
          : recurringInterval // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      plants: freezed == plants
          ? _value.plants
          : plants // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReminderSimpleImplCopyWith<$Res>
    implements $ReminderSimpleCopyWith<$Res> {
  factory _$$ReminderSimpleImplCopyWith(_$ReminderSimpleImpl value,
          $Res Function(_$ReminderSimpleImpl) then) =
      __$$ReminderSimpleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'profile_id') String profileId,
      @JsonKey(name: 'plant_id') String plantId,
      String type,
      String title,
      String? description,
      @JsonKey(name: 'due_date') DateTime dueDate,
      bool completed,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      bool recurring,
      @JsonKey(name: 'recurring_interval') String? recurringInterval,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      Map<String, dynamic>? plants});
}

/// @nodoc
class __$$ReminderSimpleImplCopyWithImpl<$Res>
    extends _$ReminderSimpleCopyWithImpl<$Res, _$ReminderSimpleImpl>
    implements _$$ReminderSimpleImplCopyWith<$Res> {
  __$$ReminderSimpleImplCopyWithImpl(
      _$ReminderSimpleImpl _value, $Res Function(_$ReminderSimpleImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReminderSimple
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? plantId = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = null,
    Object? completed = null,
    Object? completedAt = freezed,
    Object? recurring = null,
    Object? recurringInterval = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? plants = freezed,
  }) {
    return _then(_$ReminderSimpleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurring: null == recurring
          ? _value.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringInterval: freezed == recurringInterval
          ? _value.recurringInterval
          : recurringInterval // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      plants: freezed == plants
          ? _value._plants
          : plants // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReminderSimpleImpl implements _ReminderSimple {
  const _$ReminderSimpleImpl(
      {required this.id,
      @JsonKey(name: 'profile_id') required this.profileId,
      @JsonKey(name: 'plant_id') required this.plantId,
      required this.type,
      required this.title,
      this.description,
      @JsonKey(name: 'due_date') required this.dueDate,
      this.completed = false,
      @JsonKey(name: 'completed_at') this.completedAt,
      this.recurring = false,
      @JsonKey(name: 'recurring_interval') this.recurringInterval,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      final Map<String, dynamic>? plants})
      : _plants = plants;

  factory _$ReminderSimpleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderSimpleImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'profile_id')
  final String profileId;
  @override
  @JsonKey(name: 'plant_id')
  final String plantId;
  @override
  final String type;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'due_date')
  final DateTime dueDate;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool recurring;
  @override
  @JsonKey(name: 'recurring_interval')
  final String? recurringInterval;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
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
    return 'ReminderSimple(id: $id, profileId: $profileId, plantId: $plantId, type: $type, title: $title, description: $description, dueDate: $dueDate, completed: $completed, completedAt: $completedAt, recurring: $recurring, recurringInterval: $recurringInterval, createdAt: $createdAt, updatedAt: $updatedAt, plants: $plants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderSimpleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.recurring, recurring) ||
                other.recurring == recurring) &&
            (identical(other.recurringInterval, recurringInterval) ||
                other.recurringInterval == recurringInterval) &&
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
      type,
      title,
      description,
      dueDate,
      completed,
      completedAt,
      recurring,
      recurringInterval,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_plants));

  /// Create a copy of ReminderSimple
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderSimpleImplCopyWith<_$ReminderSimpleImpl> get copyWith =>
      __$$ReminderSimpleImplCopyWithImpl<_$ReminderSimpleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderSimpleImplToJson(
      this,
    );
  }
}

abstract class _ReminderSimple implements ReminderSimple {
  const factory _ReminderSimple(
      {required final String id,
      @JsonKey(name: 'profile_id') required final String profileId,
      @JsonKey(name: 'plant_id') required final String plantId,
      required final String type,
      required final String title,
      final String? description,
      @JsonKey(name: 'due_date') required final DateTime dueDate,
      final bool completed,
      @JsonKey(name: 'completed_at') final DateTime? completedAt,
      final bool recurring,
      @JsonKey(name: 'recurring_interval') final String? recurringInterval,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final Map<String, dynamic>? plants}) = _$ReminderSimpleImpl;

  factory _ReminderSimple.fromJson(Map<String, dynamic> json) =
      _$ReminderSimpleImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'profile_id')
  String get profileId;
  @override
  @JsonKey(name: 'plant_id')
  String get plantId;
  @override
  String get type;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'due_date')
  DateTime get dueDate;
  @override
  bool get completed;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  bool get recurring;
  @override
  @JsonKey(name: 'recurring_interval')
  String? get recurringInterval;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Plant information from join
  @override
  Map<String, dynamic>? get plants;

  /// Create a copy of ReminderSimple
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderSimpleImplCopyWith<_$ReminderSimpleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
