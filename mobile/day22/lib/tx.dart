import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final alchemyApiKey = dotenv.get('ALCHEMY_API_KEY');
final rpcUrl = 'https://eth-sepolia.g.alchemy.com/v2/$alchemyApiKey';
final web3Client = Web3Client(rpcUrl, Client());

Future<String> signTransaction({
  required EthPrivateKey privateKey,
  required Transaction transaction,
}) async {
  try {
    var result = await web3Client.signTransaction(
      privateKey,
      transaction,
      chainId: 11155111,
    );
    if (transaction.isEIP1559) {
      result = prependTransactionType(0x02, result);
    }
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

const abi = [
  {
    "inputs": [
      {"internalType": "address", "name": "account", "type": "address"}
    ],
    "name": "balanceOf",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "decimals",
    "outputs": [
      {"internalType": "uint8", "name": "", "type": "uint8"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "recipient", "type": "address"},
      {"internalType": "uint256", "name": "amount", "type": "uint256"}
    ],
    "name": "transfer",
    "outputs": [
      {"internalType": "bool", "name": "", "type": "bool"}
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
];

Future<double> readTokenBalance(
    String contractAddress, String walletAddress) async {
  try {
    final contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abi), 'ERC20'),
      EthereumAddress.fromHex(contractAddress),
    );
    final balanceFunction = contract.function('balanceOf');
    final balance = await web3Client.call(
      contract: contract,
      function: balanceFunction,
      params: [EthereumAddress.fromHex(walletAddress)],
    );
    final rawBalance = BigInt.parse(balance.first.toString());
    final decimanls = await web3Client.call(
      contract: contract,
      function: contract.function('decimals'),
      params: [],
    );
    final decimals = int.parse(decimanls.first.toString());
    return rawBalance / BigInt.from(10).pow(decimals);
  } catch (e) {
    rethrow;
  }
}

Future<EtherAmount> getMaxPriorityFee() async {
  try {
    final response = await post(
      Uri.parse(rpcUrl),
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "eth_maxPriorityFeePerGas",
        "params": [],
        "id": 1,
      }),
    );
    final json = jsonDecode(response.body);
    final result = json['result'];
    return EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(result));
  } catch (e) {
    rethrow;
  }
}

class TransactionWithHash {
  final String hash;
  final Transaction transaction;

  TransactionWithHash({
    required this.hash,
    required this.transaction,
  });
}

Future<TransactionWithHash> sendTokenTransaction({
  required EthPrivateKey privateKey,
  required String contractAddress,
  required String toAddress,
  required BigInt amount,
}) async {
  try {
    final contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abi), 'ERC20'),
      EthereumAddress.fromHex(contractAddress),
    );
    final transferFunction = contract.function('transfer');
    final nonce = await web3Client.getTransactionCount(
      EthereumAddress.fromHex(privateKey.address.hex),
      atBlock: const BlockNum.pending(),
    );

    var maxFeePerGas = await web3Client.getGasPrice();
    maxFeePerGas = EtherAmount.inWei(maxFeePerGas.getInWei - BigInt.from(1));
    var maxPriorityFeePerGas = EtherAmount.zero();

    final transferTx = Transaction.callContract(
      contract: contract,
      function: transferFunction,
      parameters: [EthereumAddress.fromHex(toAddress), amount],
      maxFeePerGas: maxFeePerGas,
      maxPriorityFeePerGas: maxPriorityFeePerGas,
      nonce: nonce,
    );
    final tx = await signTransaction(
      privateKey: privateKey,
      transaction: transferTx,
    );
    print('tx: $tx , nonce: $nonce');
    final txHash = await sendRawTransaction(tx);
    print('txHash: $txHash');
    return TransactionWithHash(hash: txHash, transaction: transferTx);
  } catch (e) {
    rethrow;
  }
}

Future<TransactionWithHash> sendCancelTransaction({
  required EthPrivateKey privateKey,
  required int nonce,
  required EtherAmount lastGasPrice,
}) async {
  try {
    // 20% up
    final newGasPrice =
        lastGasPrice.getInWei * BigInt.from(6) ~/ BigInt.from(5);
    final cancelTx = Transaction(
      from: privateKey.address,
      to: privateKey.address,
      maxFeePerGas: EtherAmount.inWei(newGasPrice),
      maxPriorityFeePerGas: EtherAmount.inWei(newGasPrice),
      maxGas: 21000,
      value: EtherAmount.zero(),
      nonce: nonce,
    );
    final tx = await signTransaction(
      privateKey: privateKey,
      transaction: cancelTx,
    );
    print('tx: $tx , nonce: $nonce');
    final txHash = await sendRawTransaction(tx);
    print('txHash: $txHash');
    return TransactionWithHash(hash: txHash, transaction: cancelTx);
  } catch (e) {
    rethrow;
  }
}
