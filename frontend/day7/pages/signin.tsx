"use client";

import { useAccount, useSignMessage } from "wagmi";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useEffect, useState } from "react";
import * as siwe from "siwe";

function createSiweMessage(address: string): string {
  const siweMessage = new siwe.SiweMessage({
    domain: "localhost:3000",
    address,
    statement: "Welcome to myawesomedapp. Please login to continue.",
    uri: "http://localhost:3000/signin",
    version: "1",
    chainId: 1,
    nonce: "07EwlNV39F7FRRqpu",
  });
  return siweMessage.prepareMessage();
}

function SignIn() {
  const { address } = useAccount();
  const [message, setMessage] = useState("");
  useEffect(() => {
    if (address) {
      const timestamp = Math.floor(new Date().getTime() / 1000);
      // set msg based on current wallet address and timestamp, with unique application string
      setMessage(
        `Welcome to myawesomedapp.com. Please login to continue. Challenge: ${address?.toLowerCase()}:${timestamp}`
      );
    }
  }, [address]);

  const {
    data: signature,
    isError,
    error,
    signMessage,
  } = useSignMessage({ message });

  const [siweMessage, setSiweMessage] = useState("");
  useEffect(() => {
    if (address) {
      setSiweMessage(createSiweMessage(address));
    }
  }, [address]);
  const { data: siweSignature, signMessage: signSiweMessage } = useSignMessage({
    message: siweMessage,
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
      <button onClick={() => signMessage()}>Sign Message</button>
      <button onClick={() => signSiweMessage()}>Sign SIWE Message</button>
      <div>Message: {message}</div>
      <div>Signature: {signature}</div>
      {isError && <div>Error: {error?.message}</div>}
      <div>SIWE Message: {siweMessage}</div>
      <div>SIWE Signature: {siweSignature}</div>
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
