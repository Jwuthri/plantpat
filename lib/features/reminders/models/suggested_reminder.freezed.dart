// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggested_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SuggestedReminder _$SuggestedReminderFromJson(Map<String, dynamic> json) {
  return _SuggestedReminder.fromJson(json);
}

/// @nodoc
mixin _$SuggestedReminder {
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  int get daysInterval => throw _privateConstructorUsedError;
  bool get recurring => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;

  /// Serializes this SuggestedReminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestedReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestedReminderCopyWith<SuggestedReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedReminderCopyWith<$Res> {
  factory $SuggestedReminderCopyWith(
          SuggestedReminder value, $Res Function(SuggestedReminder) then) =
      _$SuggestedReminderCopyWithImpl<$Res, SuggestedReminder>;
  @useResult
  $Res call(
      {String type,
      String title,
      String description,
      String frequency,
      int daysInterval,
      bool recurring,
      String priority});
}

/// @nodoc
class _$SuggestedReminderCopyWithImpl<$Res, $Val extends SuggestedReminder>
    implements $SuggestedReminderCopyWith<$Res> {
  _$SuggestedReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestedReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? frequency = null,
    Object? daysInterval = null,
    Object? recurring = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      daysInterval: null == daysInterval
          ? _value.daysInterval
          : daysInterval // ignore: cast_nullable_to_non_nullable
              as int,
      recurring: null == recurring
          ? _value.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestedReminderImplCopyWith<$Res>
    implements $SuggestedReminderCopyWith<$Res> {
  factory _$$SuggestedReminderImplCopyWith(_$SuggestedReminderImpl value,
          $Res Function(_$SuggestedReminderImpl) then) =
      __$$SuggestedReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String title,
      String description,
      String frequency,
      int daysInterval,
      bool recurring,
      String priority});
}

/// @nodoc
class __$$SuggestedReminderImplCopyWithImpl<$Res>
    extends _$SuggestedReminderCopyWithImpl<$Res, _$SuggestedReminderImpl>
    implements _$$SuggestedReminderImplCopyWith<$Res> {
  __$$SuggestedReminderImplCopyWithImpl(_$SuggestedReminderImpl _value,
      $Res Function(_$SuggestedReminderImpl) _then)
      : super(_value, _then);

  /// Create a copy of SuggestedReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? frequency = null,
    Object? daysInterval = null,
    Object? recurring = null,
    Object? priority = null,
  }) {
    return _then(_$SuggestedReminderImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      daysInterval: null == daysInterval
          ? _value.daysInterval
          : daysInterval // ignore: cast_nullable_to_non_nullable
              as int,
      recurring: null == recurring
          ? _value.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedReminderImpl implements _SuggestedReminder {
  const _$SuggestedReminderImpl(
      {required this.type,
      required this.title,
      required this.description,
      required this.frequency,
      required this.daysInterval,
      required this.recurring,
      required this.priority});

  factory _$SuggestedReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestedReminderImplFromJson(json);

  @override
  final String type;
  @override
  final String title;
  @override
  final String description;
  @override
  final String frequency;
  @override
  final int daysInterval;
  @override
  final bool recurring;
  @override
  final String priority;

  @override
  String toString() {
    return 'SuggestedReminder(type: $type, title: $title, description: $description, frequency: $frequency, daysInterval: $daysInterval, recurring: $recurring, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedReminderImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.daysInterval, daysInterval) ||
                other.daysInterval == daysInterval) &&
            (identical(other.recurring, recurring) ||
                other.recurring == recurring) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, title, description,
      frequency, daysInterval, recurring, priority);

  /// Create a copy of SuggestedReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedReminderImplCopyWith<_$SuggestedReminderImpl> get copyWith =>
      __$$SuggestedReminderImplCopyWithImpl<_$SuggestedReminderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedReminderImplToJson(
      this,
    );
  }
}

abstract class _SuggestedReminder implements SuggestedReminder {
  const factory _SuggestedReminder(
      {required final String type,
      required final String title,
      required final String description,
      required final String frequency,
      required final int daysInterval,
      required final bool recurring,
      required final String priority}) = _$SuggestedReminderImpl;

  factory _SuggestedReminder.fromJson(Map<String, dynamic> json) =
      _$SuggestedReminderImpl.fromJson;

  @override
  String get type;
  @override
  String get title;
  @override
  String get description;
  @override
  String get frequency;
  @override
  int get daysInterval;
  @override
  bool get recurring;
  @override
  String get priority;

  /// Create a copy of SuggestedReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestedReminderImplCopyWith<_$SuggestedReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestedRemindersResponse _$SuggestedRemindersResponseFromJson(
    Map<String, dynamic> json) {
  return _SuggestedRemindersResponse.fromJson(json);
}

/// @nodoc
mixin _$SuggestedRemindersResponse {
  List<SuggestedReminder> get suggestedReminders =>
      throw _privateConstructorUsedError;

  /// Serializes this SuggestedRemindersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestedRemindersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestedRemindersResponseCopyWith<SuggestedRemindersResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedRemindersResponseCopyWith<$Res> {
  factory $SuggestedRemindersResponseCopyWith(SuggestedRemindersResponse value,
          $Res Function(SuggestedRemindersResponse) then) =
      _$SuggestedRemindersResponseCopyWithImpl<$Res,
          SuggestedRemindersResponse>;
  @useResult
  $Res call({List<SuggestedReminder> suggestedReminders});
}

/// @nodoc
class _$SuggestedRemindersResponseCopyWithImpl<$Res,
        $Val extends SuggestedRemindersResponse>
    implements $SuggestedRemindersResponseCopyWith<$Res> {
  _$SuggestedRemindersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestedRemindersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedReminders = null,
  }) {
    return _then(_value.copyWith(
      suggestedReminders: null == suggestedReminders
          ? _value.suggestedReminders
          : suggestedReminders // ignore: cast_nullable_to_non_nullable
              as List<SuggestedReminder>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestedRemindersResponseImplCopyWith<$Res>
    implements $SuggestedRemindersResponseCopyWith<$Res> {
  factory _$$SuggestedRemindersResponseImplCopyWith(
          _$SuggestedRemindersResponseImpl value,
          $Res Function(_$SuggestedRemindersResponseImpl) then) =
      __$$SuggestedRemindersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SuggestedReminder> suggestedReminders});
}

/// @nodoc
class __$$SuggestedRemindersResponseImplCopyWithImpl<$Res>
    extends _$SuggestedRemindersResponseCopyWithImpl<$Res,
        _$SuggestedRemindersResponseImpl>
    implements _$$SuggestedRemindersResponseImplCopyWith<$Res> {
  __$$SuggestedRemindersResponseImplCopyWithImpl(
      _$SuggestedRemindersResponseImpl _value,
      $Res Function(_$SuggestedRemindersResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SuggestedRemindersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedReminders = null,
  }) {
    return _then(_$SuggestedRemindersResponseImpl(
      suggestedReminders: null == suggestedReminders
          ? _value._suggestedReminders
          : suggestedReminders // ignore: cast_nullable_to_non_nullable
              as List<SuggestedReminder>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedRemindersResponseImpl implements _SuggestedRemindersResponse {
  const _$SuggestedRemindersResponseImpl(
      {required final List<SuggestedReminder> suggestedReminders})
      : _suggestedReminders = suggestedReminders;

  factory _$SuggestedRemindersResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SuggestedRemindersResponseImplFromJson(json);

  final List<SuggestedReminder> _suggestedReminders;
  @override
  List<SuggestedReminder> get suggestedReminders {
    if (_suggestedReminders is EqualUnmodifiableListView)
      return _suggestedReminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedReminders);
  }

  @override
  String toString() {
    return 'SuggestedRemindersResponse(suggestedReminders: $suggestedReminders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedRemindersResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._suggestedReminders, _suggestedReminders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_suggestedReminders));

  /// Create a copy of SuggestedRemindersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedRemindersResponseImplCopyWith<_$SuggestedRemindersResponseImpl>
      get copyWith => __$$SuggestedRemindersResponseImplCopyWithImpl<
          _$SuggestedRemindersResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedRemindersResponseImplToJson(
      this,
    );
  }
}

abstract class _SuggestedRemindersResponse
    implements SuggestedRemindersResponse {
  const factory _SuggestedRemindersResponse(
          {required final List<SuggestedReminder> suggestedReminders}) =
      _$SuggestedRemindersResponseImpl;

  factory _SuggestedRemindersResponse.fromJson(Map<String, dynamic> json) =
      _$SuggestedRemindersResponseImpl.fromJson;

  @override
  List<SuggestedReminder> get suggestedReminders;

  /// Create a copy of SuggestedRemindersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestedRemindersResponseImplCopyWith<_$SuggestedRemindersResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
