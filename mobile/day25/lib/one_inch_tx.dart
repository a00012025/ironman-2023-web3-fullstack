import 'package:freezed_annotation/freezed_annotation.dart';

part 'one_inch_tx.freezed.dart';
part 'one_inch_tx.g.dart';

@freezed
class OneInchTx with _$OneInchTx {
  factory OneInchTx({
    required String from,
    required String to,
    required String data,
    required String value,
    required int gas,
    required String gasPrice,
  }) = _OneInchTx;

  factory OneInchTx.fromJson(Map<String, dynamic> json) =>
      _$OneInchTxFromJson(json);
}
