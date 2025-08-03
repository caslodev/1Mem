import { ConnectButton } from "@rainbow-me/rainbowkit";
import { RainbowKitProvider } from "@rainbow-me/rainbowkit";
import { WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { http, createConfig } from "wagmi";
import { baseSepolia, polygonAmoy } from "wagmi/chains";
import {
  metaMaskWallet,
  walletConnectWallet,
} from "@rainbow-me/rainbowkit/wallets";
import { connectorsForWallets } from "@rainbow-me/rainbowkit";
import { SwapInterface } from "./components/SwapInterface";

// Configure chains & providers
const config = createConfig({
  chains: [baseSepolia, polygonAmoy],
  connectors: connectorsForWallets(
    [
      {
        groupName: "Recommended",
        wallets: [metaMaskWallet, walletConnectWallet],
      },
    ],
    {
      appName: "1inch",
      projectId: "YOUR_WALLET_CONNECT_PROJECT_ID",
    }
  ),
  transports: {
    [baseSepolia.id]: http(),
    [polygonAmoy.id]: http(),
  },
});

const queryClient = new QueryClient();

function App() {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider locale="en-US">
          <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 flex items-center justify-center p-8">
            <div className="text-center space-y-8">
              <div className="space-y-4">
                <h1 className="text-6xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                  Web3 DApp Demo
                </h1>

                <p className="text-xl text-gray-600 max-w-md mx-auto">
                  Connect your wallet to Base Sepolia and Polygon Amoy networks
                </p>
              </div>

              <div className="space-y-6">
                {/* RainbowKit Connect Button */}
                <div className="flex justify-center">
                  <ConnectButton />
                </div>

                {/* Swap Interface */}
                <SwapInterface />

                {/* Network Info */}
                <div className="p-6 bg-white/80 backdrop-blur-sm rounded-3xl shadow-lg border border-white/20">
                  <p className="text-gray-600 font-mono text-sm">
                    Supported Networks: Base Sepolia (84532) | Polygon Amoy
                    (8002)
                  </p>
                </div>
              </div>
            </div>
          </div>
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}

export default App;
