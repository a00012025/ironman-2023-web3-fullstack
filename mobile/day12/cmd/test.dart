// import 'package:bitcoin_flutter/bitcoin_flutter.dart';
// ignore_for_file: avoid_print

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bitcoin/flutter_bitcoin.dart' hide Transaction;
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart' as wallet;

main() {
  final mnemonic = bip39.generateMnemonic(strength: 128);
  print('mnemonic: $mnemonic');

  final seed = bip39.mnemonicToSeed(mnemonic);
  final hdWallet = HDWallet.fromSeed(seed);

  // derive bitcoin
  final btcWallet = hdWallet.derivePath("m/44'/0'/0'/0/0");
  print('bitcoin address: ${btcWallet.address}');

  // derive ethereum
  final ethWallet = hdWallet.derivePath("m/44'/60'/0'/0/0");
  final ethPriKey = EthPrivateKey.fromHex(ethWallet.privKey!);
  print('ethereum address: ${ethPriKey.address}');

  // derive tron
  final tronWallet = hdWallet.derivePath("m/44'/195'/0'/0/0");
  final tronPrivateKey =
      wallet.PrivateKey(BigInt.parse(tronWallet.privKey!, radix: 16));
  final tronPubKey = wallet.tron.createPublicKey(tronPrivateKey);
  final tronAddress = wallet.tron.createAddress(tronPubKey);
  print('tron address: $tronAddress');
}
