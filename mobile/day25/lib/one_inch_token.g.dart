// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_inch_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OneInchTokenImpl _$$OneInchTokenImplFromJson(Map<String, dynamic> json) =>
    _$OneInchTokenImpl(
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      decimals: json['decimals'] as int,
      logoURI: json['logoURI'] as String? ?? '',
      eip2612: json['eip2612'] as bool? ?? false,
      wrappedNative: json['wrappedNative'] as bool? ?? false,
    );

Map<String, dynamic> _$$OneInchTokenImplToJson(_$OneInchTokenImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'address': instance.address,
      'decimals': instance.decimals,
      'logoURI': instance.logoURI,
      'eip2612': instance.eip2612,
      'wrappedNative': instance.wrappedNative,
    };
