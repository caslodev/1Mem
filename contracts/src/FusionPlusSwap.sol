// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title FusionPlusSwap
 * @dev Smart contract for 1inch Fusion+ cross-chain swaps
 * This contract implements hashlock and timelock functionality for secure cross-chain transactions
 */
contract FusionPlusSwap is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    // Structs
    struct SwapOrder {
        address user;
        address fromToken;
        address toToken;
        uint256 fromAmount;
        uint256 toAmount;
        uint256 deadline;
        bytes32 hashlock;
        bool isExecuted;
        bool isCancelled;
    }

    struct CrossChainOrder {
        uint32 destinationChain;
        address user;
        address fromToken;
        address toToken;
        uint256 fromAmount;
        uint256 toAmount;
        uint256 deadline;
        bytes32 hashlock;
        bytes32 secret;
        bool isCompleted;
    }

    // Events
    event SwapOrderCreated(
        bytes32 indexed orderId,
        address indexed user,
        address fromToken,
        address toToken,
        uint256 fromAmount,
        uint256 toAmount,
        uint256 deadline
    );

    event SwapOrderExecuted(
        bytes32 indexed orderId,
        address indexed user,
        uint256 actualAmount
    );

    event SwapOrderCancelled(
        bytes32 indexed orderId,
        address indexed user
    );

    event CrossChainOrderInitiated(
        bytes32 indexed orderId,
        uint32 indexed destinationChain,
        address indexed user,
        address fromToken,
        address toToken,
        uint256 fromAmount,
        uint256 toAmount,
        uint256 deadline
    );

    event CrossChainOrderCompleted(
        bytes32 indexed orderId,
        bytes32 secret
    );

    // State variables
    mapping(bytes32 => SwapOrder) public swapOrders;
    mapping(bytes32 => CrossChainOrder) public crossChainOrders;
    mapping(address => bool) public authorizedExecutors;
    mapping(address => bool) public supportedTokens;
    
    uint256 public minSwapAmount = 0.001 ether;
    uint256 public maxSwapAmount = 1000 ether;
    uint256 public defaultTimeout = 1 hours;
    uint256 public protocolFee = 5; // 0.05% (5 basis points)
    uint256 public constant FEE_DENOMINATOR = 10000;

    // Modifiers
    modifier onlyAuthorizedExecutor() {
        require(authorizedExecutors[msg.sender] || msg.sender == owner(), "Not authorized");
        _;
    }

    modifier onlySupportedToken(address token) {
        require(supportedTokens[token], "Token not supported");
        _;
    }

    modifier validAmount(uint256 amount) {
        require(amount >= minSwapAmount, "Amount too small");
        require(amount <= maxSwapAmount, "Amount too large");
        _;
    }

    constructor() Ownable(msg.sender) {
        // Initialize with common tokens
        supportedTokens[0x4200000000000000000000000000000000000006] = true; // WETH on Base
        supportedTokens[0x036CbD53842c5426634e7929541eC2318f3dCF7c] = true; // USDC on Base
        supportedTokens[0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb] = true; // USDT on Base
    }

    /**
     * @dev Create a new swap order with hashlock
     * @param fromToken Address of the token to swap from
     * @param toToken Address of the token to swap to
     * @param fromAmount Amount of fromToken to swap
     * @param toAmount Minimum amount of toToken to receive
     * @param deadline Deadline for the swap order
     * @param hashlock Hashlock for the swap
     */
    function createSwapOrder(
        address fromToken,
        address toToken,
        uint256 fromAmount,
        uint256 toAmount,
        uint256 deadline,
        bytes32 hashlock
    ) external validAmount(fromAmount) onlySupportedToken(fromToken) onlySupportedToken(toToken) {
        require(deadline > block.timestamp, "Deadline must be in the future");
        require(fromToken != toToken, "Tokens must be different");
        require(hashlock != bytes32(0), "Invalid hashlock");

        bytes32 orderId = keccak256(abi.encodePacked(
            msg.sender,
            fromToken,
            toToken,
            fromAmount,
            toAmount,
            deadline,
            hashlock,
            block.timestamp
        ));

        require(swapOrders[orderId].user == address(0), "Order already exists");

        // Transfer tokens from user to contract
        IERC20(fromToken).safeTransferFrom(msg.sender, address(this), fromAmount);

        swapOrders[orderId] = SwapOrder({
            user: msg.sender,
            fromToken: fromToken,
            toToken: toToken,
            fromAmount: fromAmount,
            toAmount: toAmount,
            deadline: deadline,
            hashlock: hashlock,
            isExecuted: false,
            isCancelled: false
        });

        emit SwapOrderCreated(
            orderId,
            msg.sender,
            fromToken,
            toToken,
            fromAmount,
            toAmount,
            deadline
        );
    }

    /**
     * @dev Execute a swap order using the secret
     * @param orderId ID of the swap order
     * @param secret Secret that unlocks the hashlock
     */
    function executeSwapOrder(
        bytes32 orderId,
        bytes32 secret
    ) external onlyAuthorizedExecutor nonReentrant {
        SwapOrder storage order = swapOrders[orderId];
        require(order.user != address(0), "Order does not exist");
        require(!order.isExecuted, "Order already executed");
        require(!order.isCancelled, "Order cancelled");
        require(block.timestamp <= order.deadline, "Order expired");
        require(keccak256(abi.encodePacked(secret)) == order.hashlock, "Invalid secret");

        order.isExecuted = true;

        // Calculate protocol fee
        uint256 feeAmount = (order.fromAmount * protocolFee) / FEE_DENOMINATOR;
        uint256 swapAmount = order.fromAmount - feeAmount;

        // Transfer tokens to user
        IERC20(order.toToken).safeTransfer(order.user, order.toAmount);

        emit SwapOrderExecuted(orderId, order.user, order.toAmount);
    }

    /**
     * @dev Cancel a swap order if deadline has passed
     * @param orderId ID of the swap order
     */
    function cancelSwapOrder(bytes32 orderId) external nonReentrant {
        SwapOrder storage order = swapOrders[orderId];
        require(order.user == msg.sender, "Not order owner");
        require(!order.isExecuted, "Order already executed");
        require(!order.isCancelled, "Order already cancelled");
        require(block.timestamp > order.deadline, "Deadline not passed");

        order.isCancelled = true;

        // Return tokens to user
        IERC20(order.fromToken).safeTransfer(order.user, order.fromAmount);

        emit SwapOrderCancelled(orderId, order.user);
    }

    /**
     * @dev Initiate a cross-chain swap order
     * @param destinationChain Chain ID of the destination
     * @param fromToken Address of the token to swap from
     * @param toToken Address of the token to swap to
     * @param fromAmount Amount of fromToken to swap
     * @param toAmount Minimum amount of toToken to receive
     * @param deadline Deadline for the swap order
     */
    function initiateCrossChainSwap(
        uint32 destinationChain,
        address fromToken,
        address toToken,
        uint256 fromAmount,
        uint256 toAmount,
        uint256 deadline
    ) external validAmount(fromAmount) onlySupportedToken(fromToken) {
        require(deadline > block.timestamp, "Deadline must be in the future");
        require(fromToken != toToken, "Tokens must be different");

        // Generate hashlock and secret
        bytes32 secret = keccak256(abi.encodePacked(
            msg.sender,
            destinationChain,
            fromToken,
            toToken,
            fromAmount,
            toAmount,
            deadline,
            block.timestamp
        ));
        bytes32 hashlock = keccak256(abi.encodePacked(secret));

        bytes32 orderId = keccak256(abi.encodePacked(
            msg.sender,
            destinationChain,
            fromToken,
            toToken,
            fromAmount,
            toAmount,
            deadline,
            hashlock,
            block.timestamp
        ));

        // Transfer tokens from user to contract
        IERC20(fromToken).safeTransferFrom(msg.sender, address(this), fromAmount);

        crossChainOrders[orderId] = CrossChainOrder({
            destinationChain: destinationChain,
            user: msg.sender,
            fromToken: fromToken,
            toToken: toToken,
            fromAmount: fromAmount,
            toAmount: toAmount,
            deadline: deadline,
            hashlock: hashlock,
            secret: secret,
            isCompleted: false
        });

        emit CrossChainOrderInitiated(
            orderId,
            destinationChain,
            msg.sender,
            fromToken,
            toToken,
            fromAmount,
            toAmount,
            deadline
        );
    }

    /**
     * @dev Complete a cross-chain swap order
     * @param orderId ID of the cross-chain order
     * @param secret Secret that unlocks the hashlock
     */
    function completeCrossChainSwap(
        bytes32 orderId,
        bytes32 secret
    ) external onlyAuthorizedExecutor nonReentrant {
        CrossChainOrder storage order = crossChainOrders[orderId];
        require(order.user != address(0), "Order does not exist");
        require(!order.isCompleted, "Order already completed");
        require(block.timestamp <= order.deadline, "Order expired");
        require(keccak256(abi.encodePacked(secret)) == order.hashlock, "Invalid secret");

        order.isCompleted = true;

        // Transfer tokens to user
        IERC20(order.toToken).safeTransfer(order.user, order.toAmount);

        emit CrossChainOrderCompleted(orderId, secret);
    }

    // Admin functions
    function setAuthorizedExecutor(address executor, bool authorized) external onlyOwner {
        authorizedExecutors[executor] = authorized;
    }

    function setSupportedToken(address token, bool supported) external onlyOwner {
        supportedTokens[token] = supported;
    }

    function setLimits(uint256 minAmount, uint256 maxAmount) external onlyOwner {
        minSwapAmount = minAmount;
        maxSwapAmount = maxAmount;
    }

    function setProtocolFee(uint256 newFee) external onlyOwner {
        require(newFee <= 100, "Fee too high"); // Max 1%
        protocolFee = newFee;
    }

    function setDefaultTimeout(uint256 newTimeout) external onlyOwner {
        defaultTimeout = newTimeout;
    }

    function withdrawFees(address token, uint256 amount) external onlyOwner {
        IERC20(token).safeTransfer(owner(), amount);
    }

    // View functions
    function getSwapOrder(bytes32 orderId) external view returns (SwapOrder memory) {
        return swapOrders[orderId];
    }

    function getCrossChainOrder(bytes32 orderId) external view returns (CrossChainOrder memory) {
        return crossChainOrders[orderId];
    }

    function calculateFee(uint256 amount) external view returns (uint256) {
        return (amount * protocolFee) / FEE_DENOMINATOR;
    }
} 