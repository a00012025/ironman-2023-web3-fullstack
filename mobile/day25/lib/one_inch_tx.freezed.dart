// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'one_inch_tx.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OneInchTx _$OneInchTxFromJson(Map<String, dynamic> json) {
  return _OneInchTx.fromJson(json);
}

/// @nodoc
mixin _$OneInchTx {
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  int get gas => throw _privateConstructorUsedError;
  String get gasPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OneInchTxCopyWith<OneInchTx> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OneInchTxCopyWith<$Res> {
  factory $OneInchTxCopyWith(OneInchTx value, $Res Function(OneInchTx) then) =
      _$OneInchTxCopyWithImpl<$Res, OneInchTx>;
  @useResult
  $Res call(
      {String from,
      String to,
      String data,
      String value,
      int gas,
      String gasPrice});
}

/// @nodoc
class _$OneInchTxCopyWithImpl<$Res, $Val extends OneInchTx>
    implements $OneInchTxCopyWith<$Res> {
  _$OneInchTxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? data = null,
    Object? value = null,
    Object? gas = null,
    Object? gasPrice = null,
  }) {
    return _then(_value.copyWith(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      gas: null == gas
          ? _value.gas
          : gas // ignore: cast_nullable_to_non_nullable
              as int,
      gasPrice: null == gasPrice
          ? _value.gasPrice
          : gasPrice // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_OneInchTxCopyWith<$Res> implements $OneInchTxCopyWith<$Res> {
  factory _$$_OneInchTxCopyWith(
          _$_OneInchTx value, $Res Function(_$_OneInchTx) then) =
      __$$_OneInchTxCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String from,
      String to,
      String data,
      String value,
      int gas,
      String gasPrice});
}

/// @nodoc
class __$$_OneInchTxCopyWithImpl<$Res>
    extends _$OneInchTxCopyWithImpl<$Res, _$_OneInchTx>
    implements _$$_OneInchTxCopyWith<$Res> {
  __$$_OneInchTxCopyWithImpl(
      _$_OneInchTx _value, $Res Function(_$_OneInchTx) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? data = null,
    Object? value = null,
    Object? gas = null,
    Object? gasPrice = null,
  }) {
    return _then(_$_OneInchTx(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      gas: null == gas
          ? _value.gas
          : gas // ignore: cast_nullable_to_non_nullable
              as int,
      gasPrice: null == gasPrice
          ? _value.gasPrice
          : gasPrice // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_OneInchTx implements _OneInchTx {
  _$_OneInchTx(
      {required this.from,
      required this.to,
      required this.data,
      required this.value,
      required this.gas,
      required this.gasPrice});

  factory _$_OneInchTx.fromJson(Map<String, dynamic> json) =>
      _$$_OneInchTxFromJson(json);

  @override
  final String from;
  @override
  final String to;
  @override
  final String data;
  @override
  final String value;
  @override
  final int gas;
  @override
  final String gasPrice;

  @override
  String toString() {
    return 'OneInchTx(from: $from, to: $to, data: $data, value: $value, gas: $gas, gasPrice: $gasPrice)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OneInchTx &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.gas, gas) || other.gas == gas) &&
            (identical(other.gasPrice, gasPrice) ||
                other.gasPrice == gasPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, from, to, data, value, gas, gasPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OneInchTxCopyWith<_$_OneInchTx> get copyWith =>
      __$$_OneInchTxCopyWithImpl<_$_OneInchTx>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OneInchTxToJson(
      this,
    );
  }
}

abstract class _OneInchTx implements OneInchTx {
  factory _OneInchTx(
      {required final String from,
      required final String to,
      required final String data,
      required final String value,
      required final int gas,
      required final String gasPrice}) = _$_OneInchTx;

  factory _OneInchTx.fromJson(Map<String, dynamic> json) =
      _$_OneInchTx.fromJson;

  @override
  String get from;
  @override
  String get to;
  @override
  String get data;
  @override
  String get value;
  @override
  int get gas;
  @override
  String get gasPrice;
  @override
  @JsonKey(ignore: true)
  _$$_OneInchTxCopyWith<_$_OneInchTx> get copyWith =>
      throw _privateConstructorUsedError;
}
