# 1inch Fusion+ Smart Contracts

Smart contracts for ETHGlobal Unite hackathon that extend 1inch's Fusion+ protocol to enable cross-chain swaps between Ethereum and Base Sepolia/Polygon Amoy networks.

## Features

### FusionPlusSwap Contract
- **1inch Fusion+ Integration** - Hashlock and timelock functionality for secure cross-chain swaps
- **Cross-chain swaps** - Bidirectional swaps between Ethereum and L2 networks
- **Hashlock mechanism** - Secure transaction execution using cryptographic hashlocks
- **Timelock functionality** - Time-based transaction execution and cancellation
- **Partial fills** - Support for partial order execution
- **Protocol fees** - Configurable protocol fees for sustainability

### Counter Contract
- **Counter functionality** - Increment counter via Hyperlane messages
- **Hyperlane integration** - Receives messages from other chains
- **Event emission** - Emits events when counter is incremented
- **Access control** - Owner-based access control

## Setup

1. **Install dependencies:**

   ```bash
   forge install
   ```

2. **Copy environment file:**

   ```bash
   cp env.example .env
   ```

3. **Configure environment variables:**
   - `PRIVATE_KEY`: Your wallet private key (without 0x prefix)
   - `BASESCAN_API_KEY`: BaseScan API key for contract verification

## Testing

Run the test suite:

```bash
forge test
```

Run tests with verbose output:

```bash
forge test -vv
```

## Compilation

Compile the contracts:

```bash
forge build
```

## Deployment

Deploy to Base Sepolia:

```bash
forge script script/Deploy.s.sol --rpc-url https://sepolia.base.org --broadcast --verify
```

## Contract Details

### FusionPlusSwap.sol
- **Network**: Base Sepolia (Chain ID: 84532)
- **Protocol**: 1inch Fusion+ Extension
- **Key Functions**:
  - `createSwapOrder()` - Create a new swap order with hashlock
  - `executeSwapOrder()` - Execute swap order using secret
  - `cancelSwapOrder()` - Cancel expired swap orders
  - `initiateCrossChainSwap()` - Start cross-chain swap process
  - `completeCrossChainSwap()` - Complete cross-chain swap
- **Security Features**:
  - Hashlock mechanism for secure execution
  - Timelock functionality for time-based operations
  - Reentrancy protection
  - Access control for authorized executors

### Counter.sol
- **Network**: Base Sepolia (Chain ID: 84532)
- **Interface**: IMessageRecipient (Hyperlane)
- **Functions**:
  - `handle(uint32 origin, bytes32 sender, bytes calldata message)` - Receives Hyperlane messages
  - `counter()` - View current counter value
  - `owner()` - View contract owner

### 1inch Fusion+ Integration
The FusionPlusSwap contract extends 1inch's Fusion+ protocol with:
- **Hashlock Mechanism** - Cryptographic hashlocks ensure secure cross-chain transactions
- **Timelock Functionality** - Time-based execution and cancellation of orders
- **Bidirectional Swaps** - Support for swaps in both directions (Ethereum ↔ L2)
- **Protocol Fees** - Sustainable fee structure for protocol maintenance

### Hyperlane Integration
The Counter contract implements the `IMessageRecipient` interface to receive cross-chain messages from Hyperlane. When a message with the command "increment" is received, the counter is incremented.

## Verification

After deployment, verify the contract on BaseScan:

```bash
forge verify-contract <CONTRACT_ADDRESS> src/Counter.sol:Counter --chain-id 84532 --etherscan-api-key <BASESCAN_API_KEY>
```

## Network Configuration

### Base Sepolia

- **RPC URL**: https://sepolia.base.org
- **Chain ID**: 84532
- **Block Explorer**: https://sepolia.basescan.org
- **Faucet**: https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet
