import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bitcoin/flutter_bitcoin.dart' hide Transaction;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';

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

const uniContractAddress = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController mnemonicController = TextEditingController();
  String mnemonic = "";
  HDWallet? ethWallet;
  String? ethAddress;
  double? uniBalance;
  String? ethTxHash;

  void refreshMnemonic() {
    final newMnemonic = mnemonicController.text;
    if (bip39.validateMnemonic(newMnemonic)) {
      final seed = bip39.mnemonicToSeed(newMnemonic);
      final hdWallet = HDWallet.fromSeed(seed);
      setState(() {
        mnemonic = newMnemonic;
        ethWallet = hdWallet.derivePath("m/44'/60'/0'/0/0");
        final ethPriKey = EthPrivateKey.fromHex(ethWallet!.privKey!);
        ethAddress = ethPriKey.address.hex;
        readTokenBalance(uniContractAddress, ethAddress!).then((balance) {
          setState(() {
            uniBalance = balance;
          });
        });
      });
    } else {
      setState(() {
        ethWallet = null;
        ethAddress = null;
        uniBalance = null;
        ethTxHash = null;
      });
    }
  }

  void sendToken() {
    final ethPriKey = EthPrivateKey.fromHex(ethWallet!.privKey!);
    sendTokenTransaction(
      privateKey: ethPriKey,
      contractAddress: uniContractAddress,
      toAddress: "0xE2Dc3214f7096a94077E71A3E218243E289F1067",
      amount: BigInt.from(10000),
    ).then((txHash) {
      setState(() {
        ethTxHash = txHash;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refreshMnemonic();
  }

  @override
  Widget build(BuildContext context) {
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
              if (ethAddress != null) Text('Ethereum address: $ethAddress'),
              const SizedBox(height: 10),
              if (uniBalance != null) Text('UNI balance: $uniBalance'),
              if (ethTxHash != null) Text('Ethereum tx hash: $ethTxHash'),
              if (uniBalance != null)
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: sendToken,
                    child: const Text('Send Token Tx'),
                  ),
                )
            ],
          ],
        ),
      ),
    );
  }
}
