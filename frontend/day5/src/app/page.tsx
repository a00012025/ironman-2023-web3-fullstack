"use client";

import {
  WagmiConfig,
  createConfig,
  useAccount,
  useConnect,
  useDisconnect,
  configureChains,
  mainnet,
  sepolia,
  useBalance,
  useSwitchNetwork,
  useNetwork,
  useContractRead,
  useContractWrite,
} from "wagmi";
import { formatUnits } from "viem";
import { InjectedConnector } from "wagmi/connectors/injected";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [mainnet, sepolia],
  [
    alchemyProvider({ apiKey: process.env.NEXT_PUBLIC_ALCHEMY_KEY! }),
    publicProvider(),
  ]
);

const config = createConfig({
  autoConnect: true,
  publicClient: publicClient,
});

const abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "decimals",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transfer",
    outputs: [
      {
        internalType: "bool",
        name: "success",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const UNI_CONTRACT_ADDRESS = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";
const NULL_ADDRESS = "0x0000000000000000000000000000000000000000";

function Profile() {
  const { address, isConnected } = useAccount();
  const { connect } = useConnect({
    connector: new InjectedConnector(),
  });
  const { disconnect } = useDisconnect();
  const balance = useBalance({ address });

  const { chain } = useNetwork();
  const { switchNetwork } = useSwitchNetwork();

  // read UNI balance
  const { data: balanceData } = useContractRead({
    address: UNI_CONTRACT_ADDRESS,
    abi,
    functionName: "balanceOf",
    args: [address || NULL_ADDRESS],
  });
  const { data: decimals } = useContractRead({
    address: UNI_CONTRACT_ADDRESS,
    abi,
    functionName: "decimals",
  });
  const uniBalance =
    balanceData && decimals ? formatUnits(balanceData, decimals) : undefined;

  // send UNI tx
  const {
    data: txData,
    isLoading,
    isSuccess,
    write: sendUniTx,
  } = useContractWrite({
    address: UNI_CONTRACT_ADDRESS,
    abi,
    functionName: "transfer",
    args: ["0xE2Dc3214f7096a94077E71A3E218243E289F1067", 100000n],
  });

  if (isConnected)
    return (
      <div>
        <div>Connected to {address}</div>
        <div>Balance: {balance.data?.formatted}</div>
        <button onClick={() => disconnect()}>Disconnect</button>

        <div>Chains:</div>
        {chain && <div>Connected to {chain.name}</div>}
        {chains.map((x) => (
          <div key={x.id}>
            <button
              disabled={!switchNetwork || x.id === chain?.id}
              onClick={() => switchNetwork?.(x.id)}
            >
              {x.name} {x.id === chain?.id && "(current)"}
            </button>
          </div>
        ))}

        {/* {balanceData !== undefined && <div>UNI Balance: {balanceData.toString()}</div>} */}
        {uniBalance && (
          <>
            <div>UNI Balance: {uniBalance}</div>
            <button onClick={() => sendUniTx()}>Send UNI</button>
            {isLoading && <div>Check Your Wallet...</div>}
            {isSuccess && <div>Transaction Hash: {txData?.hash}</div>}
          </>
        )}
      </div>
    );
  return <button onClick={() => connect()}>Connect Wallet</button>;
}

export default function App() {
  return (
    <WagmiConfig config={config}>
      <main className="flex min-h-screen flex-col items-center justify-between p-24">
        <Profile />
      </main>
    </WagmiConfig>
  );
}
