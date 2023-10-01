import 'package:freezed_annotation/freezed_annotation.dart';

import 'one_inch_token.dart';

part 'one_inch_quote_response.freezed.dart';
part 'one_inch_quote_response.g.dart';

@freezed
class OneInchQuoteResponse with _$OneInchQuoteResponse {
  OneInchQuoteResponse._();
  factory OneInchQuoteResponse({
    required OneInchToken fromToken,
    required OneInchToken toToken,
    required String toAmount,
    required int gas,
  }) = _OneInchQuoteResponse;

  factory OneInchQuoteResponse.fromJson(Map<String, dynamic> json) =>
      _$OneInchQuoteResponseFromJson(json);
}
