"use client";

import { useAccount, useContractRead, useSignTypedData } from "wagmi";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useEffect, useState } from "react";
import { encodeFunctionData } from "viem";

const recipientContractABI = [
  // transferWithFee(address,uint256)
  {
    inputs: [
      { internalType: "address", name: "recipient", type: "address" },
      { internalType: "uint256", name: "amount", type: "uint256" },
    ],
    name: "transferWithFee",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const forwarderABI = [
  // execute(ForwardRequest,bytes)
  {
    inputs: [
      {
        components: [
          { internalType: "address", name: "from", type: "address" },
          { internalType: "address", name: "to", type: "address" },
          { internalType: "uint256", name: "value", type: "uint256" },
          { internalType: "uint256", name: "gas", type: "uint256" },
          { internalType: "uint256", name: "nonce", type: "uint256" },
          { internalType: "bytes", name: "data", type: "bytes" },
        ],
        internalType: "struct WRLD_Forwarder_Polygon.ForwardRequest",
        name: "req",
        type: "tuple",
      },
      { internalType: "bytes", name: "signature", type: "bytes" },
    ],
    name: "execute",
    outputs: [
      { internalType: "bool", name: "", type: "bool" },
      { internalType: "bytes", name: "", type: "bytes" },
    ],
    stateMutability: "payable",
    type: "function",
  },
  // getNonce(address)
  {
    inputs: [{ internalType: "address", name: "from", type: "address" }],
    name: "getNonce",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  // verify
  {
    inputs: [
      {
        components: [
          { internalType: "address", name: "from", type: "address" },
          { internalType: "address", name: "to", type: "address" },
          { internalType: "uint256", name: "value", type: "uint256" },
          { internalType: "uint256", name: "gas", type: "uint256" },
          { internalType: "uint256", name: "nonce", type: "uint256" },
          { internalType: "bytes", name: "data", type: "bytes" },
        ],
        internalType: "struct WRLD_Forwarder_Polygon.ForwardRequest",
        name: "req",
        type: "tuple",
      },
      { internalType: "bytes", name: "signature", type: "bytes" },
    ],
    name: "verify",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "view",
    type: "function",
  },
] as const;

const NULL_ADDRESS = "0x0000000000000000000000000000000000000000";
const FORWARDER_CONTRACT_ADDRESS = "0x7fe3aedfc76d7c6dd84b617081a9346de81236dc";
const TOKEN_CONTRACT_ADDRESS = "0xd5d86fc8d5c0ea1ac1ac5dfab6e529c9967a45e9";

function SignIn() {
  const { address } = useAccount();

  // read forwarder nonce
  const { data: forwarderNonce } = useContractRead({
    address: FORWARDER_CONTRACT_ADDRESS,
    abi: forwarderABI,
    functionName: "getNonce",
    args: [address || NULL_ADDRESS],
    chainId: 137,
  });

  // encode transferWithFee function data
  const gas = 100000n;
  const data = encodeFunctionData({
    abi: recipientContractABI,
    functionName: "transferWithFee",
    args: ["0xE2Dc3214f7096a94077E71A3E218243E289F1067", 10000n],
  });

  // sign typed data
  const {
    data: signature,
    isError,
    error,
    signTypedData,
  } = useSignTypedData({
    domain: {
      name: "WRLD_Forwarder_Polygon",
      version: "1.0.0",
      chainId: 137,
      verifyingContract: FORWARDER_CONTRACT_ADDRESS,
    } as const,
    primaryType: "ForwardRequest",
    types: {
      ForwardRequest: [
        { name: "from", type: "address" },
        { name: "to", type: "address" },
        { name: "value", type: "uint256" },
        { name: "gas", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "data", type: "bytes" },
      ],
    },
    message: {
      from: address || NULL_ADDRESS,
      to: TOKEN_CONTRACT_ADDRESS,
      value: 0n,
      gas,
      nonce: forwarderNonce || 0n,
      data,
    },
  });

  // verify typed data
  const { data: isVerified } = useContractRead({
    address: FORWARDER_CONTRACT_ADDRESS,
    abi: forwarderABI,
    functionName: "verify",
    args: [
      {
        from: address || NULL_ADDRESS,
        to: TOKEN_CONTRACT_ADDRESS,
        value: 0n,
        gas,
        nonce: forwarderNonce || 0n,
        data,
      },
      signature || "0x",
    ],
    chainId: 137,
    enabled: !!address && !!forwarderNonce && !!signature,
  });

  return (
    <div
      style={{
        padding: 50,
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        gap: 10,
        overflowWrap: "anywhere",
      }}
    >
      <ConnectButton />
      <button
        onClick={() => {
          if (forwarderNonce !== undefined) {
            signTypedData();
          }
        }}
      >
        Sign Meta Transaction
      </button>
      <div>Forwarder Nonce: {(forwarderNonce || 0n).toLocaleString()}</div>
      <div>Signature: {signature}</div>
      {isError && <div>Error: {error?.message}</div>}
      {isVerified && <div>Signature verified!</div>}
    </div>
  );
}

export default function App() {
  return (
    <main>
      <SignIn />
    </main>
  );
}
