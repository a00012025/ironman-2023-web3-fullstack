import 'dart:typed_data';

import 'package:flutter_bitcoin/flutter_bitcoin.dart' hide Transaction;
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final alchemyApiKey = dotenv.get('ALCHEMY_API_KEY');
final web3Client =
    Web3Client('https://eth-sepolia.g.alchemy.com/v2/$alchemyApiKey', Client());

Future<String> signTransaction({
  required EthPrivateKey privateKey,
  required Transaction transaction,
}) async {
  try {
    final result = await web3Client.signTransaction(
      privateKey,
      transaction,
      chainId: 11155111,
    );
    return HEX.encode(result);
  } catch (e) {
    rethrow;
  }
}

Future<String> sendRawTransaction(String tx) async {
  try {
    final txHash =
        await web3Client.sendRawTransaction(Uint8List.fromList(HEX.decode(tx)));
    return txHash;
  } catch (e) {
    rethrow;
  }
}

String sampleBitcoinTx(HDWallet btcWallet) {
  final txb = TransactionBuilder();
  txb.setVersion(1);
  // previous transaction output, has 15000 satoshis
  txb.addInput(
      '61d520ccb74288c96bc1a2b20ea1c0d5a704776dd0164a396efec3ea7040349d', 0);
  // (in)15000 - (out)12000 = (fee)3000, this is the miner fee
  txb.addOutput('1cMh228HTCiwS8ZsaakH8A8wze1JR5ZsP', 12000);
  txb.sign(vin: 0, keyPair: ECPair.fromWIF(btcWallet.wif!));
  return txb.build().toHex();
}

Future<String> sampleEthereumTx(HDWallet ethWallet) async {
  final ethPriKey = EthPrivateKey.fromHex(ethWallet.privKey!);
  return await signTransaction(
    privateKey: ethPriKey,
    transaction: Transaction(
      from: ethPriKey.address,
      to: EthereumAddress.fromHex("0xE2Dc3214f7096a94077E71A3E218243E289F1067"),
      value: EtherAmount.fromBase10String(EtherUnit.gwei, "10000"),
    ),
  );
}
