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

Future<String> sendTokenTransaction({
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
    final transferTx = Transaction.callContract(
      contract: contract,
      function: transferFunction,
      parameters: [EthereumAddress.fromHex(toAddress), amount],
      maxFeePerGas: await web3Client.getGasPrice(),
      maxPriorityFeePerGas: await getMaxPriorityFee(),
    );
    final tx = await signTransaction(
      privateKey: privateKey,
      transaction: transferTx,
    );
    print('tx: $tx');
    final txHash = await sendRawTransaction(tx);
    print('txHash: $txHash');
    return txHash;
  } catch (e) {
    rethrow;
  }
}
