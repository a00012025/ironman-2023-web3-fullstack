// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_inch_tx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OneInchTx _$$_OneInchTxFromJson(Map<String, dynamic> json) => _$_OneInchTx(
      from: json['from'] as String,
      to: json['to'] as String,
      data: json['data'] as String,
      value: json['value'] as String,
      gas: json['gas'] as int,
      gasPrice: json['gasPrice'] as String,
    );

Map<String, dynamic> _$$_OneInchTxToJson(_$_OneInchTx instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'data': instance.data,
      'value': instance.value,
      'gas': instance.gas,
      'gasPrice': instance.gasPrice,
    };
