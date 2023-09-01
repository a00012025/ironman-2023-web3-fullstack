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
} from "wagmi";
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

function Profile() {
  const { address, isConnected } = useAccount();
  const { connect } = useConnect({
    connector: new InjectedConnector(),
  });
  const { disconnect } = useDisconnect();
  const balance = useBalance({ address });

  const { chain } = useNetwork();
  const { error, switchNetwork } = useSwitchNetwork();

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
