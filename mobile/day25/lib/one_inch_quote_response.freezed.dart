// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'one_inch_quote_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OneInchQuoteResponse _$OneInchQuoteResponseFromJson(Map<String, dynamic> json) {
  return _OneInchQuoteResponse.fromJson(json);
}

/// @nodoc
mixin _$OneInchQuoteResponse {
  OneInchToken get fromToken => throw _privateConstructorUsedError;
  OneInchToken get toToken => throw _privateConstructorUsedError;
  String get toAmount => throw _privateConstructorUsedError;
  int get gas => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OneInchQuoteResponseCopyWith<OneInchQuoteResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OneInchQuoteResponseCopyWith<$Res> {
  factory $OneInchQuoteResponseCopyWith(OneInchQuoteResponse value,
          $Res Function(OneInchQuoteResponse) then) =
      _$OneInchQuoteResponseCopyWithImpl<$Res, OneInchQuoteResponse>;
  @useResult
  $Res call(
      {OneInchToken fromToken, OneInchToken toToken, String toAmount, int gas});

  $OneInchTokenCopyWith<$Res> get fromToken;
  $OneInchTokenCopyWith<$Res> get toToken;
}

/// @nodoc
class _$OneInchQuoteResponseCopyWithImpl<$Res,
        $Val extends OneInchQuoteResponse>
    implements $OneInchQuoteResponseCopyWith<$Res> {
  _$OneInchQuoteResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromToken = null,
    Object? toToken = null,
    Object? toAmount = null,
    Object? gas = null,
  }) {
    return _then(_value.copyWith(
      fromToken: null == fromToken
          ? _value.fromToken
          : fromToken // ignore: cast_nullable_to_non_nullable
              as OneInchToken,
      toToken: null == toToken
          ? _value.toToken
          : toToken // ignore: cast_nullable_to_non_nullable
              as OneInchToken,
      toAmount: null == toAmount
          ? _value.toAmount
          : toAmount // ignore: cast_nullable_to_non_nullable
              as String,
      gas: null == gas
          ? _value.gas
          : gas // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OneInchTokenCopyWith<$Res> get fromToken {
    return $OneInchTokenCopyWith<$Res>(_value.fromToken, (value) {
      return _then(_value.copyWith(fromToken: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OneInchTokenCopyWith<$Res> get toToken {
    return $OneInchTokenCopyWith<$Res>(_value.toToken, (value) {
      return _then(_value.copyWith(toToken: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OneInchQuoteResponseImplCopyWith<$Res>
    implements $OneInchQuoteResponseCopyWith<$Res> {
  factory _$$OneInchQuoteResponseImplCopyWith(_$OneInchQuoteResponseImpl value,
          $Res Function(_$OneInchQuoteResponseImpl) then) =
      __$$OneInchQuoteResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OneInchToken fromToken, OneInchToken toToken, String toAmount, int gas});

  @override
  $OneInchTokenCopyWith<$Res> get fromToken;
  @override
  $OneInchTokenCopyWith<$Res> get toToken;
}

/// @nodoc
class __$$OneInchQuoteResponseImplCopyWithImpl<$Res>
    extends _$OneInchQuoteResponseCopyWithImpl<$Res, _$OneInchQuoteResponseImpl>
    implements _$$OneInchQuoteResponseImplCopyWith<$Res> {
  __$$OneInchQuoteResponseImplCopyWithImpl(_$OneInchQuoteResponseImpl _value,
      $Res Function(_$OneInchQuoteResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromToken = null,
    Object? toToken = null,
    Object? toAmount = null,
    Object? gas = null,
  }) {
    return _then(_$OneInchQuoteResponseImpl(
      fromToken: null == fromToken
          ? _value.fromToken
          : fromToken // ignore: cast_nullable_to_non_nullable
              as OneInchToken,
      toToken: null == toToken
          ? _value.toToken
          : toToken // ignore: cast_nullable_to_non_nullable
              as OneInchToken,
      toAmount: null == toAmount
          ? _value.toAmount
          : toAmount // ignore: cast_nullable_to_non_nullable
              as String,
      gas: null == gas
          ? _value.gas
          : gas // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OneInchQuoteResponseImpl extends _OneInchQuoteResponse {
  _$OneInchQuoteResponseImpl(
      {required this.fromToken,
      required this.toToken,
      required this.toAmount,
      required this.gas})
      : super._();

  factory _$OneInchQuoteResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OneInchQuoteResponseImplFromJson(json);

  @override
  final OneInchToken fromToken;
  @override
  final OneInchToken toToken;
  @override
  final String toAmount;
  @override
  final int gas;

  @override
  String toString() {
    return 'OneInchQuoteResponse(fromToken: $fromToken, toToken: $toToken, toAmount: $toAmount, gas: $gas)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OneInchQuoteResponseImpl &&
            (identical(other.fromToken, fromToken) ||
                other.fromToken == fromToken) &&
            (identical(other.toToken, toToken) || other.toToken == toToken) &&
            (identical(other.toAmount, toAmount) ||
                other.toAmount == toAmount) &&
            (identical(other.gas, gas) || other.gas == gas));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fromToken, toToken, toAmount, gas);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OneInchQuoteResponseImplCopyWith<_$OneInchQuoteResponseImpl>
      get copyWith =>
          __$$OneInchQuoteResponseImplCopyWithImpl<_$OneInchQuoteResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OneInchQuoteResponseImplToJson(
      this,
    );
  }
}

abstract class _OneInchQuoteResponse extends OneInchQuoteResponse {
  factory _OneInchQuoteResponse(
      {required final OneInchToken fromToken,
      required final OneInchToken toToken,
      required final String toAmount,
      required final int gas}) = _$OneInchQuoteResponseImpl;
  _OneInchQuoteResponse._() : super._();

  factory _OneInchQuoteResponse.fromJson(Map<String, dynamic> json) =
      _$OneInchQuoteResponseImpl.fromJson;

  @override
  OneInchToken get fromToken;
  @override
  OneInchToken get toToken;
  @override
  String get toAmount;
  @override
  int get gas;
  @override
  @JsonKey(ignore: true)
  _$$OneInchQuoteResponseImplCopyWith<_$OneInchQuoteResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
