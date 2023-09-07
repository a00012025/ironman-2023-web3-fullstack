import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bitcoin/flutter_bitcoin.dart' hide Transaction;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart' as wallet;

import 'tx.dart';

void main() {
  dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController mnemonicController = TextEditingController();
  String mnemonic = "";
  HDWallet? btcWallet, ethWallet, tronWallet;
  String? btcTx, ethTx, ethTxHash;

  void refreshMnemonic() {
    final newMnemonic = mnemonicController.text;
    if (bip39.validateMnemonic(newMnemonic)) {
      final seed = bip39.mnemonicToSeed(newMnemonic);
      final hdWallet = HDWallet.fromSeed(seed);
      setState(() {
        mnemonic = newMnemonic;
        btcWallet = hdWallet.derivePath("m/44'/0'/0'/0/0");
        ethWallet = hdWallet.derivePath("m/44'/60'/0'/0/0");
        tronWallet = hdWallet.derivePath("m/44'/195'/0'/0/0");
        btcTx = sampleBitcoinTx(btcWallet!);
        sampleEthereumTx(ethWallet!).then((tx) {
          setState(() {
            ethTx = tx;
          });
        });
      });
    } else {
      setState(() {
        btcWallet = null;
        ethWallet = null;
        tronWallet = null;
        btcTx = null;
        ethTx = null;
        ethTxHash = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    final btcAddress = btcWallet?.address;

    final ethPriKey = ethWallet?.privKey == null
        ? null
        : EthPrivateKey.fromHex(ethWallet!.privKey!);
    final ethAddress = ethPriKey?.address.hex;

    String? tronAddress;
    if (tronWallet != null) {
      final tronPrivateKey =
          wallet.PrivateKey(BigInt.parse(tronWallet!.privKey!, radix: 16));
      final tronPubKey = wallet.tron.createPublicKey(tronPrivateKey);
      tronAddress = wallet.tron.createAddress(tronPubKey);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: mnemonicController,
                decoration: const InputDecoration(
                  labelText: 'Enter mnemonic',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (text) {
                  refreshMnemonic();
                },
              ),
            ),
            const SizedBox(height: 20),
            if (mnemonic.isNotEmpty) ...[
              if (btcAddress != null) Text('Bitcoin address: $btcAddress'),
              if (ethAddress != null) Text('Ethereum address: $ethAddress'),
              if (tronAddress != null) Text('Tron address: $tronAddress'),
              const SizedBox(height: 20),
              if (btcTx != null) Text('Bitcoin tx: $btcTx'),
              const SizedBox(height: 10),
              if (ethTx != null) Text('Ethereum tx: $ethTx'),
              if (ethTxHash != null) Text('Ethereum tx hash: $ethTxHash'),
              if (ethTx != null)
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final txHash = await sendRawTransaction(ethTx!);
                      setState(() {
                        ethTxHash = txHash;
                      });
                    },
                    child: const Text('Broadcast tx'),
                  ),
                )
            ],
          ],
        ),
      ),
    );
  }
}
