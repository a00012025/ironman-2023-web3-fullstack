"use client";

import { useAccount, useContractRead, useContractWrite } from "wagmi";
import { formatUnits } from "viem";
import { ConnectButton } from "@rainbow-me/rainbowkit";

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
  const { address } = useAccount();

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

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      }}
    >
      <ConnectButton />
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
}

export default function App() {
  return (
    <main>
      <Profile />
    </main>
  );
}
