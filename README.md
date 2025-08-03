# 1inch Fusion+ Cross-Chain Swap DApp

A Web3 DApp built for ETHGlobal Unite hackathon that extends 1inch's Fusion+ protocol to enable cross-chain swaps between Ethereum and Base Sepolia/Polygon Amoy networks.

## 🏆 ETHGlobal Unite Hackathon Project

This project is built for the [ETHGlobal Unite hackathon](https://ethglobal.com/events/unite) and integrates with [1inch's Fusion+ protocol](https://1inch.io/fusion/) to enable cross-chain token swaps.

### 🎯 Project Goals

- **Extend 1inch Fusion+** to Base Sepolia and Polygon Amoy networks
- **Cross-chain swaps** between Ethereum and L2 networks
- **Hashlock and timelock functionality** for secure cross-chain transactions
- **Bidirectional swaps** (Ethereum ↔ Base Sepolia, Ethereum ↔ Polygon Amoy)

## ✨ Features

### Frontend (React + RainbowKit)

- **Wallet Connection** - MetaMask integration with RainbowKit
- **Network Support** - Base Sepolia (84532) and Polygon Amoy (8002)
- **1inch API Integration** - Real-time price quotes and swap execution
- **Cross-chain UI** - Seamless network switching and swap interface

### Smart Contracts (Foundry)

- **Counter Contract** - Hyperlane integration for cross-chain messaging
- **1inch Fusion+ Integration** - Hashlock and timelock functionality
- **Base Sepolia Deployment** - Ready for testnet deployment

### 1inch Integration

- **Fusion+ Protocol** - Cross-chain swap execution
- **1inch API** - Price aggregation and routing
- **Limit Order Protocol** - Advanced trading strategies

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- pnpm
- MetaMask wallet
- Base Sepolia testnet tokens

### Frontend Setup

```bash
# Install dependencies
pnpm install

# Start development server
pnpm dev:1inch
```

### Smart Contracts Setup

```bash
# Navigate to contracts directory
cd contracts

# Install Foundry dependencies
forge install

# Copy environment file
cp env.example .env

# Compile contracts
forge build

# Run tests
forge test
```

## 🏗️ Architecture

### Frontend Components

- **Wallet Connection** - RainbowKit ConnectButton
- **Network Switcher** - Easy switching between networks
- **Swap Interface** - 1inch API integration for quotes
- **Transaction History** - Cross-chain transaction tracking

### Smart Contract Integration

- **Counter.sol** - Hyperlane cross-chain messaging
- **1inch Fusion+** - Cross-chain swap execution
- **Base Sepolia** - Primary deployment network

## 🎨 Design System

### Custom Tailwind Tokens

- **Color Palette** - Primary, secondary, accent, success, warning, error
- **Typography** - Inter, Poppins, JetBrains Mono
- **Animations** - Fade-in, slide-up, bounce-gentle
- **Shadows** - Soft, medium, large, glow effects

## 🔗 1inch Integration

### Fusion+ Protocol

- **Hashlock Mechanism** - Secure cross-chain transactions
- **Timelock Functionality** - Time-based transaction execution
- **Bidirectional Swaps** - Ethereum ↔ L2 networks
- **Partial Fills** - Advanced order execution

### API Usage

- **Price Quotes** - Real-time token prices
- **Route Optimization** - Best swap paths
- **Transaction Execution** - Cross-chain swap completion
- **Order Management** - Limit order handling

## 📱 Supported Networks

### Base Sepolia (84532)

- **RPC URL**: https://sepolia.base.org
- **Block Explorer**: https://sepolia.basescan.org
- **Faucet**: https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet

### Polygon Amoy (8002)

- **RPC URL**: https://rpc-amoy.polygon.technology
- **Block Explorer**: https://www.oklink.com/amoy

## 🧪 Testing

### Frontend Tests

```bash
pnpm test
```

### Smart Contract Tests

```bash
cd contracts
forge test -vv
```

## 🚀 Deployment

### Frontend Deployment

```bash
pnpm build
pnpm preview
```

### Smart Contract Deployment

```bash
cd contracts
forge script script/Deploy.s.sol --rpc-url https://sepolia.base.org --broadcast --verify
```

## 📚 Resources

### 1inch Documentation

- [1inch Fusion+ Whitepaper](https://1inch.io/assets/1inch-fusion-plus.pdf)
- [1inch API Documentation](https://docs.1inch.io/)
- [1inch Hackathon Guide](https://hackathon.1inch.community)

### ETHGlobal Unite

- [Hackathon Page](https://ethglobal.com/events/unite)
- [1inch Prize Track](https://ethglobal.com/events/unite/prizes)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is built for ETHGlobal Unite hackathon and is open source under the MIT License.

---

Built with ❤️ for ETHGlobal Unite using 1inch Fusion+ protocol
