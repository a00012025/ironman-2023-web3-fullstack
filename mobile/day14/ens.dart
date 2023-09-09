import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:ens_dart/ens_dart.dart';
import 'package:web3dart/web3dart.dart';

Future<List<String>> getENSNames(String wallet) async {
  final query = '''
    query {
      domains(where: {owner_in: ["${wallet.toLowerCase()}"]}) {
          name
      }
    }
  ''';

  final response = await Client().post(
    Uri.parse('https://api.thegraph.com/subgraphs/name/ensdomains/ens'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "query": query,
    }),
  );

  if (response.statusCode >= 400) {
    throw Exception(response.body);
  }

  final parsedData = jsonDecode(response.body);
  final responseData = parsedData['data'];

  var ensNames = <String>[];
  if (responseData['domains'] != null) {
    for (final v in responseData['domains']) {
      ensNames.add(v['name']);
    }
  }
  return ensNames;
}

bool skipReverseRegistrar(String ensName) {
  return ensName.endsWith(".addr.reverse");
}

void main() async {
  final alchemyApiKey = Platform.environment['ALCHEMY_API_KEY'];
  if (alchemyApiKey == null) {
    print('ALCHEMY_API_KEY is not set');
    exit(1);
  }
  final rpcUrl = 'https://eth-mainnet.g.alchemy.com/v2/$alchemyApiKey';
  final web3Client = Web3Client(rpcUrl, Client());
  final ens = Ens(client: web3Client);

  final resolvedAddress = await ens.withName("vitalik.eth").getAddress();
  print('resolvedAddress: $resolvedAddress');

  final reverseEnsName = await ens
      .withAddress("0xd8da6bf26964af9d7eed9e03e53415d37aa96045")
      .getName();
  print('reverseEnsName: $reverseEnsName');

  final allEnsNames =
      await getENSNames("0xd8da6bf26964af9d7eed9e03e53415d37aa96045");
  print('allEnsNames: $allEnsNames');
}
