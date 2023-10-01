import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'one_inch_quote_response.dart';
import 'one_inch_tx.dart';

final Dio dio = Dio();

Future<void> main(List<String> args) async {
  final oneinchApiKey = Platform.environment['ONEINCH_API_KEY'];
  if (oneinchApiKey == null) {
    print('ONEINCH_API_KEY is not set');
    exit(1);
  }

  dio.options.baseUrl = 'https://api.1inch.dev/swap';
  dio.options.headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${oneinchApiKey}',
  };

  final quote = await getQuote(1,
      fromToken: '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
      toToken: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
      amount: BigInt.from(1000000000000000));
  print(JsonEncoder.withIndent('  ').convert(quote));

  final swapData = await getSwapData(1,
      fromTokenAddress: '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
      toTokenAddress: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
      amount: BigInt.from(1000000000000000),
      fromAddress: '0x2089035369B33403DdcaBa6258c34e0B3FfbbBd9');
  print(JsonEncoder.withIndent('  ').convert(swapData));
}

@override
Future<OneInchQuoteResponse> getQuote(
  int chainId, {
  required String fromToken,
  required String toToken,
  required BigInt amount,
}) async {
  final params = {
    'src': fromToken,
    'dst': toToken,
    'amount': amount.toString(),
    'includeTokensInfo': true,
    'includeProtocols': true,
    'includeGas': true,
  };
  final response =
      await dio.get('/v5.2/$chainId/quote', queryParameters: params);
  final quote = OneInchQuoteResponse.fromJson(response.data);
  return quote;
}

@override
Future<OneInchTx> getSwapData(
  int chainId, {
  required String fromTokenAddress,
  required String toTokenAddress,
  required BigInt amount,
  required String fromAddress,
  int slippage = 1,
  String? permit,
}) async {
  final queryData = {
    'fromTokenAddress': fromTokenAddress,
    'toTokenAddress': toTokenAddress,
    'amount': amount.toString(),
    'fromAddress': fromAddress,
    'slippage': slippage,
    'fee': "0",
  };
  if (permit != null) {
    queryData['permit'] = permit;
  }
  final response = await dio.get(
    '/v5.2/$chainId/swap',
    queryParameters: queryData,
  );
  final swapResponse = OneInchTx.fromJson(response.data['tx']);
  return swapResponse;
}
