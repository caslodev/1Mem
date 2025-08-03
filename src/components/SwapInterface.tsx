import React, { useState, useEffect } from 'react';
import { Button, Heading, Text } from "react-aria-components";
import { useAccount, useNetwork, useSwitchNetwork } from 'wagmi';
import { oneInchAPI, CHAIN_IDS, TOKENS } from '../services/1inchApi';

interface SwapQuote {
  fromToken: {
    symbol: string;
    address: string;
    decimals: number;
  };
  toToken: {
    symbol: string;
    address: string;
    decimals: number;
  };
  fromTokenAmount: string;
  toTokenAmount: string;
  estimatedGas: string;
  protocols: any[];
}

export function SwapInterface() {
  const { address, isConnected } = useAccount();
  const { chain } = useNetwork();
  const { switchNetwork } = useSwitchNetwork();
  
  const [fromToken, setFromToken] = useState('WETH');
  const [toToken, setToToken] = useState('USDC');
  const [amount, setAmount] = useState('');
  const [quote, setQuote] = useState<SwapQuote | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const currentChainId = chain?.id || CHAIN_IDS.baseSepolia;

  // Get quote when parameters change
  useEffect(() => {
    if (amount && fromToken && toToken && isConnected) {
      getQuote();
    }
  }, [amount, fromToken, toToken, currentChainId]);

  const getQuote = async () => {
    if (!amount || !fromToken || !toToken) return;

    setLoading(true);
    setError('');

    try {
      const fromTokenAddress = TOKENS.baseSepolia[fromToken as keyof typeof TOKENS.baseSepolia];
      const toTokenAddress = TOKENS.baseSepolia[toToken as keyof typeof TOKENS.baseSepolia];
      
      const quoteData = await oneInchAPI.getQuote(
        fromTokenAddress,
        toTokenAddress,
        amount,
        currentChainId
      );

      setQuote({
        fromToken: {
          symbol: fromToken,
          address: fromTokenAddress,
          decimals: 18
        },
        toToken: {
          symbol: toToken,
          address: toTokenAddress,
          decimals: 6
        },
        fromTokenAmount: amount,
        toTokenAmount: quoteData.toTokenAmount,
        estimatedGas: quoteData.tx?.gas || '0',
        protocols: quoteData.protocols || []
      });
    } catch (err) {
      setError('Failed to get quote. Please try again.');
      console.error('Quote error:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleSwap = async () => {
    if (!quote || !address) return;

    setLoading(true);
    setError('');

    try {
      const swapData = await oneInchAPI.getSwap(
        quote.fromToken.address,
        quote.toToken.address,
        quote.fromTokenAmount,
        address,
        1, // 1% slippage
        currentChainId
      );

      // Here you would send the transaction using wagmi
      console.log('Swap transaction data:', swapData);
      
      // For demo purposes, we'll just show success
      alert('Swap transaction prepared! Check console for transaction data.');
    } catch (err) {
      setError('Failed to prepare swap. Please try again.');
      console.error('Swap error:', err);
    } finally {
      setLoading(false);
    }
  };

  const switchTokens = () => {
    setFromToken(toToken);
    setToToken(fromToken);
  };

  if (!isConnected) {
    return (
      <div className="p-6 bg-white/80 backdrop-blur-sm rounded-3xl shadow-large border border-white/20">
        <Text className="text-secondary-700 font-body">
          Please connect your wallet to start swapping
        </Text>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="p-6 bg-white/80 backdrop-blur-sm rounded-3xl shadow-large border border-white/20">
        <Heading level={2} className="text-2xl font-bold text-gray-900 mb-4">
          1inch Fusion+ Swap
        </Heading>

        {/* Network Info */}
        <div className="mb-4 p-3 bg-blue-50 rounded-lg">
          <Text className="text-sm text-blue-700">
            Current Network: {chain?.name} (Chain ID: {chain?.id})
          </Text>
        </div>

        {/* From Token */}
        <div className="space-y-2 mb-4">
          <Text className="text-sm font-medium text-gray-700">From</Text>
          <div className="flex gap-2">
            <select
              value={fromToken}
              onChange={(e) => setFromToken(e.target.value)}
              className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
            >
              <option value="WETH">WETH</option>
              <option value="USDC">USDC</option>
              <option value="USDT">USDT</option>
            </select>
            <input
              type="number"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="0.0"
              className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
            />
          </div>
        </div>

        {/* Switch Button */}
        <div className="flex justify-center mb-4">
          <Button
            onPress={switchTokens}
            className="p-2 bg-gray-100 rounded-full hover:bg-gray-200 transition-colors"
          >
            ↓
          </Button>
        </div>

        {/* To Token */}
        <div className="space-y-2 mb-4">
          <Text className="text-sm font-medium text-gray-700">To</Text>
          <div className="flex gap-2">
            <select
              value={toToken}
              onChange={(e) => setToToken(e.target.value)}
              className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
            >
              <option value="USDC">USDC</option>
              <option value="WETH">WETH</option>
              <option value="USDT">USDT</option>
            </select>
            <div className="flex-1 px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">
              {quote ? quote.toTokenAmount : '0.0'}
            </div>
          </div>
        </div>

        {/* Quote Info */}
        {quote && (
          <div className="p-4 bg-gray-50 rounded-lg mb-4">
            <Text className="text-sm text-gray-600">
              Estimated Gas: {quote.estimatedGas}
            </Text>
            <Text className="text-sm text-gray-600">
              Protocols: {quote.protocols.length} route(s)
            </Text>
          </div>
        )}

        {/* Error */}
        {error && (
          <div className="p-3 bg-red-50 border border-red-200 rounded-lg mb-4">
            <Text className="text-sm text-red-700">{error}</Text>
          </div>
        )}

        {/* Swap Button */}
        <Button
          onPress={handleSwap}
          disabled={!quote || loading}
          className="w-full px-6 py-3 bg-primary-600 text-white rounded-lg hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-primary-300 focus:ring-offset-2 transition-all duration-400 font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? 'Loading...' : 'Swap'}
        </Button>

        {/* Network Switcher */}
        <div className="flex gap-2 mt-4">
          <Button
            onPress={() => switchNetwork?.(CHAIN_IDS.baseSepolia)}
            className="flex-1 px-4 py-2 bg-secondary-600 text-white rounded-lg hover:bg-secondary-700 focus:outline-none focus:ring-2 focus:ring-secondary-300 focus:ring-offset-2 transition-all duration-400"
          >
            Switch to Base Sepolia
          </Button>
          
          <Button
            onPress={() => switchNetwork?.(CHAIN_IDS.polygonAmoy)}
            className="flex-1 px-4 py-2 bg-accent-600 text-white rounded-lg hover:bg-accent-700 focus:outline-none focus:ring-2 focus:ring-accent-300 focus:ring-offset-2 transition-all duration-400"
          >
            Switch to Polygon Amoy
          </Button>
        </div>
      </div>
    </div>
  );
} 