// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_inch_quote_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OneInchQuoteResponseImpl _$$OneInchQuoteResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$OneInchQuoteResponseImpl(
      fromToken:
          OneInchToken.fromJson(json['fromToken'] as Map<String, dynamic>),
      toToken: OneInchToken.fromJson(json['toToken'] as Map<String, dynamic>),
      toAmount: json['toAmount'] as String,
      gas: json['gas'] as int,
    );

Map<String, dynamic> _$$OneInchQuoteResponseImplToJson(
        _$OneInchQuoteResponseImpl instance) =>
    <String, dynamic>{
      'fromToken': instance.fromToken,
      'toToken': instance.toToken,
      'toAmount': instance.toAmount,
      'gas': instance.gas,
    };
