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
} from "wagmi";
import { InjectedConnector } from "wagmi/connectors/injected";
import { publicProvider } from "wagmi/providers/public";

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [mainnet, sepolia],
  [publicProvider()]
);

const config = createConfig({
  autoConnect: true,
  publicClient: publicClient,
});

function Profile() {
  const { address, isConnected } = useAccount();
  const { connect } = useConnect({
    connector: new InjectedConnector(),
  });
  const { disconnect } = useDisconnect();

  if (isConnected)
    return (
      <div>
        <div>Connected to {address}</div>
        <button onClick={() => disconnect()}>Disconnect</button>
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
