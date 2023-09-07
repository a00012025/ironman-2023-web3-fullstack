import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bitcoin/flutter_bitcoin.dart' hide Transaction;
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart' as wallet;

void main() {
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
  String mnemonic = "";
  HDWallet? btcWallet, ethWallet, tronWallet;

  void refreshMnemonic() {
    final newMnemonic = bip39.generateMnemonic(strength: 128);
    final seed = bip39.mnemonicToSeed(mnemonic);
    final hdWallet = HDWallet.fromSeed(seed);
    setState(() {
      mnemonic = newMnemonic;
      btcWallet = hdWallet.derivePath("m/44'/0'/0'/0/0");
      ethWallet = hdWallet.derivePath("m/44'/60'/0'/0/0");
      tronWallet = hdWallet.derivePath("m/44'/195'/0'/0/0");
    });
  }

  @override
  void initState() {
    super.initState();
    refreshMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    final btcAddress = btcWallet?.address;

    final ethPriKey = EthPrivateKey.fromHex(ethWallet?.privKey ?? "");
    final ethAddress = ethPriKey.address;

    final tronPrivateKey =
        wallet.PrivateKey(BigInt.parse(tronWallet?.privKey ?? "", radix: 16));
    final tronPubKey = wallet.tron.createPublicKey(tronPrivateKey);
    final tronAddress = wallet.tron.createAddress(tronPubKey);

    print(mnemonic);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('mnemonic: $mnemonic'),
            Text('Bitcoin address: $btcAddress'),
            Text('Ethereum address: $ethAddress'),
            Text('Tron address: $tronAddress'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshMnemonic,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
