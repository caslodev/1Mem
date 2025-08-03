# ETHGlobal Unite Hackathon Submission

## Project: 1inch Fusion+ Cross-Chain Swap Extension

### 🏆 Hackathon Information

- **Event**: [ETHGlobal Unite](https://ethglobal.com/events/unite)
- **Prize Track**: [1inch Fusion+ Extension](https://ethglobal.com/events/unite/prizes)
- **Total Prize Pool**: $500,000
- **Submission Category**: Extend Fusion+ to Base Sepolia and Polygon Amoy

### 🎯 Project Overview

This project extends 1inch's Fusion+ protocol to enable cross-chain swaps between Ethereum and Base Sepolia/Polygon Amoy networks. The implementation includes both frontend DApp and smart contracts that demonstrate the core Fusion+ features: hashlock mechanism, timelock functionality, and bidirectional cross-chain swaps.

### ✨ Key Features Implemented

#### 1. 1inch Fusion+ Protocol Extension

- **Hashlock Mechanism**: Cryptographic hashlocks ensure secure cross-chain transactions
- **Timelock Functionality**: Time-based execution and cancellation of orders
- **Bidirectional Swaps**: Support for swaps in both directions (Ethereum ↔ Base Sepolia, Ethereum ↔ Polygon Amoy)
- **Protocol Fees**: Sustainable fee structure for protocol maintenance

#### 2. Smart Contract Implementation

- **FusionPlusSwap.sol**: Main contract implementing Fusion+ functionality
- **Counter.sol**: Hyperlane integration for cross-chain messaging
- **Security Features**: Reentrancy protection, access control, input validation

#### 3. Frontend DApp

- **1inch API Integration**: Real-time price quotes and swap execution
- **RainbowKit Integration**: Seamless wallet connection and network switching
- **Cross-chain UI**: Intuitive interface for managing cross-chain swaps
- **Network Support**: Base Sepolia (84532) and Polygon Amoy (8002)

### 🏗️ Technical Architecture

#### Frontend Stack

- **React 19** with TypeScript
- **Vite** for fast development and building
- **Tailwind CSS** with custom design tokens
- **RainbowKit** for wallet connection
- **Wagmi** for Ethereum interactions
- **1inch API** for price aggregation and routing

#### Smart Contract Stack

- **Foundry** for development and testing
- **Solidity 0.8.20** with OpenZeppelin contracts
- **Hyperlane** for cross-chain messaging
- **Base Sepolia** as primary deployment network

### 🔗 1inch Integration Details

#### Fusion+ Protocol Implementation

1. **Hashlock Creation**: Cryptographic hashlocks generated for each swap order
2. **Secret Management**: Secure secret generation and validation
3. **Timelock Enforcement**: Automatic order cancellation after deadline
4. **Cross-chain Coordination**: Bidirectional swap execution across networks

#### API Usage

- **Price Quotes**: Real-time token price aggregation
- **Route Optimization**: Best swap path calculation
- **Transaction Execution**: Cross-chain swap completion
- **Order Management**: Limit order handling and tracking

### 📱 Supported Networks

#### Base Sepolia (84532)

- **RPC URL**: https://sepolia.base.org
- **Block Explorer**: https://sepolia.basescan.org
- **Supported Tokens**: WETH, USDC, USDT
- **Faucet**: https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet

#### Polygon Amoy (8002)

- **RPC URL**: https://rpc-amoy.polygon.technology
- **Block Explorer**: https://www.oklink.com/amoy
- **Supported Tokens**: WETH, USDC, USDT

### 🚀 How to Run

#### Prerequisites

- Node.js 18+
- pnpm
- MetaMask wallet
- Base Sepolia testnet tokens
- 1inch API key

#### Frontend Setup

```bash
# Install dependencies
pnpm install

# Copy environment file
cp env.example .env

# Configure environment variables
# - VITE_1INCH_API_KEY: Your 1inch API key
# - VITE_WALLET_CONNECT_PROJECT_ID: Your WalletConnect project ID

# Start development server
pnpm dev:1inch
```

#### Smart Contracts Setup

```bash
# Navigate to contracts directory
cd contracts

# Install Foundry dependencies
forge install

# Copy environment file
cp env.example .env

# Configure environment variables
# - PRIVATE_KEY: Your wallet private key
# - BASESCAN_API_KEY: BaseScan API key

# Compile contracts
forge build

# Run tests
forge test -vv

# Deploy to Base Sepolia
forge script script/Deploy.s.sol --rpc-url https://sepolia.base.org --broadcast --verify
```

### 🧪 Testing

#### Frontend Tests

```bash
pnpm test
```

#### Smart Contract Tests

```bash
cd contracts
forge test -vv
```

The test suite includes:

- Hashlock mechanism validation
- Timelock functionality testing
- Cross-chain swap execution
- Security vulnerability checks
- Admin function testing

### 📊 Demo Features

#### 1. Wallet Connection

- MetaMask integration via RainbowKit
- Network switching between Base Sepolia and Polygon Amoy
- Account balance display

#### 2. 1inch Swap Interface

- Real-time price quotes from 1inch API
- Token selection (WETH, USDC, USDT)
- Amount input with validation
- Swap execution with transaction confirmation

#### 3. Cross-chain Functionality

- Network switching buttons
- Cross-chain order creation
- Hashlock generation and management
- Timelock enforcement

#### 4. Smart Contract Integration

- FusionPlusSwap contract deployment
- Order creation and execution
- Fee calculation and collection
- Event emission and tracking

### 🔒 Security Features

#### Smart Contract Security

- **Reentrancy Protection**: Prevents reentrancy attacks
- **Access Control**: Owner and authorized executor restrictions
- **Input Validation**: Comprehensive parameter validation
- **Timelock Enforcement**: Automatic order cancellation
- **Hashlock Verification**: Cryptographic secret validation

#### Frontend Security

- **Environment Variables**: Secure API key management
- **Input Sanitization**: User input validation
- **Error Handling**: Graceful error management
- **Transaction Confirmation**: User confirmation for all transactions

### 🎨 Design System

#### Custom Tailwind Tokens

- **Color Palette**: Primary, secondary, accent, success, warning, error
- **Typography**: Inter, Poppins, JetBrains Mono
- **Animations**: Fade-in, slide-up, bounce-gentle
- **Shadows**: Soft, medium, large, glow effects

#### UI Components

- **Swap Interface**: Intuitive token swap interface
- **Network Switcher**: Easy network switching
- **Wallet Connection**: Seamless wallet integration
- **Transaction History**: Cross-chain transaction tracking

### 📈 Future Enhancements

#### Planned Features

1. **Partial Fills**: Support for partial order execution
2. **Advanced Routing**: Multi-hop swap optimization
3. **Liquidity Pools**: Integration with DEX liquidity pools
4. **Mobile Support**: Responsive mobile interface
5. **Analytics Dashboard**: Transaction analytics and insights

#### Technical Improvements

1. **Gas Optimization**: Further gas cost reduction
2. **Batch Processing**: Multiple order execution
3. **Oracle Integration**: Price feed integration
4. **Governance**: DAO governance implementation

### 🤝 Team Information

- **Developer**: Built for ETHGlobal Unite hackathon
- **Experience**: Full-stack Web3 development
- **Technologies**: React, TypeScript, Solidity, Foundry
- **Focus**: DeFi protocols and cross-chain solutions

### 📚 Resources

#### Documentation

- [1inch Fusion+ Whitepaper](https://1inch.io/assets/1inch-fusion-plus.pdf)
- [1inch API Documentation](https://docs.1inch.io/)
- [1inch Hackathon Guide](https://hackathon.1inch.community)

#### Hackathon Links

- [ETHGlobal Unite](https://ethglobal.com/events/unite)
- [1inch Prize Track](https://ethglobal.com/events/unite/prizes)

### 🏆 Prize Track Alignment

This project directly addresses the 1inch Fusion+ extension challenge by:

1. **Extending Fusion+ to Base Sepolia**: Full implementation of hashlock and timelock functionality
2. **Bidirectional Swaps**: Support for swaps in both directions
3. **Hashlock Preservation**: Cryptographic security maintained across networks
4. **Timelock Functionality**: Time-based execution and cancellation
5. **Onchain Execution**: Complete smart contract implementation
6. **UI Implementation**: User-friendly interface for cross-chain swaps

### 📝 Submission Checklist

- [x] 1inch API integration for price quotes and routing
- [x] Fusion+ protocol implementation with hashlock mechanism
- [x] Timelock functionality for order management
- [x] Bidirectional cross-chain swap support
- [x] Smart contract deployment on Base Sepolia
- [x] Frontend DApp with wallet integration
- [x] Comprehensive test suite
- [x] Documentation and deployment instructions
- [x] Security audit considerations
- [x] Demo-ready functionality

---

**Built with ❤️ for ETHGlobal Unite using 1inch Fusion+ protocol**
