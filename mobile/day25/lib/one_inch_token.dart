import 'package:freezed_annotation/freezed_annotation.dart';

part 'one_inch_token.freezed.dart';
part 'one_inch_token.g.dart';

@freezed
class OneInchToken with _$OneInchToken {
  const OneInchToken._();

  factory OneInchToken({
    @Default('') String symbol,
    @Default('') String name,
    @Default('') String address,
    required int decimals,
    @Default('') String logoURI,
    @Default(false) bool eip2612,
    @Default(false) bool wrappedNative,
  }) = _OneInchToken;

  factory OneInchToken.fromJson(Map<String, dynamic> json) =>
      _$OneInchTokenFromJson(json);
}
