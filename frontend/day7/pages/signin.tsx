"use client";

import { useAccount, useSignMessage } from "wagmi";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useEffect, useState } from "react";

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
      <div>Message: {message}</div>
      <div>Signature: {signature}</div>
      {isError && <div>Error: {error?.message}</div>}
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
