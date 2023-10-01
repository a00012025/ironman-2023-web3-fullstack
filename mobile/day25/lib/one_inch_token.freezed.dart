// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'one_inch_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OneInchToken _$OneInchTokenFromJson(Map<String, dynamic> json) {
  return _OneInchToken.fromJson(json);
}

/// @nodoc
mixin _$OneInchToken {
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get decimals => throw _privateConstructorUsedError;
  String get logoURI => throw _privateConstructorUsedError;
  bool get eip2612 => throw _privateConstructorUsedError;
  bool get wrappedNative => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OneInchTokenCopyWith<OneInchToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OneInchTokenCopyWith<$Res> {
  factory $OneInchTokenCopyWith(
          OneInchToken value, $Res Function(OneInchToken) then) =
      _$OneInchTokenCopyWithImpl<$Res, OneInchToken>;
  @useResult
  $Res call(
      {String symbol,
      String name,
      String address,
      int decimals,
      String logoURI,
      bool eip2612,
      bool wrappedNative});
}

/// @nodoc
class _$OneInchTokenCopyWithImpl<$Res, $Val extends OneInchToken>
    implements $OneInchTokenCopyWith<$Res> {
  _$OneInchTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? name = null,
    Object? address = null,
    Object? decimals = null,
    Object? logoURI = null,
    Object? eip2612 = null,
    Object? wrappedNative = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      decimals: null == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int,
      logoURI: null == logoURI
          ? _value.logoURI
          : logoURI // ignore: cast_nullable_to_non_nullable
              as String,
      eip2612: null == eip2612
          ? _value.eip2612
          : eip2612 // ignore: cast_nullable_to_non_nullable
              as bool,
      wrappedNative: null == wrappedNative
          ? _value.wrappedNative
          : wrappedNative // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OneInchTokenImplCopyWith<$Res>
    implements $OneInchTokenCopyWith<$Res> {
  factory _$$OneInchTokenImplCopyWith(
          _$OneInchTokenImpl value, $Res Function(_$OneInchTokenImpl) then) =
      __$$OneInchTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbol,
      String name,
      String address,
      int decimals,
      String logoURI,
      bool eip2612,
      bool wrappedNative});
}

/// @nodoc
class __$$OneInchTokenImplCopyWithImpl<$Res>
    extends _$OneInchTokenCopyWithImpl<$Res, _$OneInchTokenImpl>
    implements _$$OneInchTokenImplCopyWith<$Res> {
  __$$OneInchTokenImplCopyWithImpl(
      _$OneInchTokenImpl _value, $Res Function(_$OneInchTokenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? name = null,
    Object? address = null,
    Object? decimals = null,
    Object? logoURI = null,
    Object? eip2612 = null,
    Object? wrappedNative = null,
  }) {
    return _then(_$OneInchTokenImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      decimals: null == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int,
      logoURI: null == logoURI
          ? _value.logoURI
          : logoURI // ignore: cast_nullable_to_non_nullable
              as String,
      eip2612: null == eip2612
          ? _value.eip2612
          : eip2612 // ignore: cast_nullable_to_non_nullable
              as bool,
      wrappedNative: null == wrappedNative
          ? _value.wrappedNative
          : wrappedNative // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OneInchTokenImpl extends _OneInchToken {
  _$OneInchTokenImpl(
      {this.symbol = '',
      this.name = '',
      this.address = '',
      required this.decimals,
      this.logoURI = '',
      this.eip2612 = false,
      this.wrappedNative = false})
      : super._();

  factory _$OneInchTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$OneInchTokenImplFromJson(json);

  @override
  @JsonKey()
  final String symbol;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String address;
  @override
  final int decimals;
  @override
  @JsonKey()
  final String logoURI;
  @override
  @JsonKey()
  final bool eip2612;
  @override
  @JsonKey()
  final bool wrappedNative;

  @override
  String toString() {
    return 'OneInchToken(symbol: $symbol, name: $name, address: $address, decimals: $decimals, logoURI: $logoURI, eip2612: $eip2612, wrappedNative: $wrappedNative)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OneInchTokenImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.decimals, decimals) ||
                other.decimals == decimals) &&
            (identical(other.logoURI, logoURI) || other.logoURI == logoURI) &&
            (identical(other.eip2612, eip2612) || other.eip2612 == eip2612) &&
            (identical(other.wrappedNative, wrappedNative) ||
                other.wrappedNative == wrappedNative));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, name, address, decimals,
      logoURI, eip2612, wrappedNative);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OneInchTokenImplCopyWith<_$OneInchTokenImpl> get copyWith =>
      __$$OneInchTokenImplCopyWithImpl<_$OneInchTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OneInchTokenImplToJson(
      this,
    );
  }
}

abstract class _OneInchToken extends OneInchToken {
  factory _OneInchToken(
      {final String symbol,
      final String name,
      final String address,
      required final int decimals,
      final String logoURI,
      final bool eip2612,
      final bool wrappedNative}) = _$OneInchTokenImpl;
  _OneInchToken._() : super._();

  factory _OneInchToken.fromJson(Map<String, dynamic> json) =
      _$OneInchTokenImpl.fromJson;

  @override
  String get symbol;
  @override
  String get name;
  @override
  String get address;
  @override
  int get decimals;
  @override
  String get logoURI;
  @override
  bool get eip2612;
  @override
  bool get wrappedNative;
  @override
  @JsonKey(ignore: true)
  _$$OneInchTokenImplCopyWith<_$OneInchTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
