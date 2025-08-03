// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/FusionPlusSwap.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Mock ERC20 token for testing
contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10**decimals());
    }
}

contract FusionPlusSwapTest is Test {
    FusionPlusSwap public fusionPlusSwap;
    MockToken public weth;
    MockToken public usdc;
    MockToken public usdt;
    
    address public user = address(0x123);
    address public executor = address(0x456);
    address public owner;

    function setUp() public {
        owner = address(this);
        
        // Deploy mock tokens
        weth = new MockToken("Wrapped Ether", "WETH");
        usdc = new MockToken("USD Coin", "USDC");
        usdt = new MockToken("Tether USD", "USDT");
        
        // Deploy FusionPlusSwap contract
        fusionPlusSwap = new FusionPlusSwap();
        
        // Add mock tokens as supported tokens
        fusionPlusSwap.setSupportedToken(address(weth), true);
        fusionPlusSwap.setSupportedToken(address(usdc), true);
        fusionPlusSwap.setSupportedToken(address(usdt), true);
        
        // Set executor
        fusionPlusSwap.setAuthorizedExecutor(executor, true);
        
        // Give tokens to user
        weth.transfer(user, 1000 * 10**18);
        usdc.transfer(user, 1000000 * 10**6);
        usdt.transfer(user, 1000000 * 10**6);
        
        vm.startPrank(user);
    }

    function testCreateSwapOrder() public {
        uint256 amount = 1 * 10**18; // 1 WETH
        uint256 expectedAmount = 1800 * 10**6; // 1800 USDC
        uint256 deadline = block.timestamp + 1 hours;
        bytes32 hashlock = keccak256(abi.encodePacked("secret123"));
        
        weth.approve(address(fusionPlusSwap), amount);
        
        vm.expectEmit(true, true, true, true);
        emit SwapOrderCreated(
            bytes32(0), // orderId will be different due to timestamp
            user,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline
        );
        
        fusionPlusSwap.createSwapOrder(
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock
        );
    }

    function testExecuteSwapOrder() public {
        uint256 amount = 1 * 10**18;
        uint256 expectedAmount = 1800 * 10**6;
        uint256 deadline = block.timestamp + 1 hours;
        bytes32 secret = keccak256(abi.encodePacked("secret123"));
        bytes32 hashlock = keccak256(abi.encodePacked(secret));
        
        weth.approve(address(fusionPlusSwap), amount);
        
        fusionPlusSwap.createSwapOrder(
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock
        );
        
        // Get order ID
        bytes32 orderId = keccak256(abi.encodePacked(
            user,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock,
            block.timestamp - 1 // Use previous timestamp
        ));
        
        // Transfer USDC to contract for the swap
        usdc.transfer(address(fusionPlusSwap), expectedAmount);
        
        vm.stopPrank();
        vm.startPrank(executor);
        
        vm.expectEmit(true, true, true, true);
        emit SwapOrderExecuted(orderId, user, expectedAmount);
        
        fusionPlusSwap.executeSwapOrder(orderId, secret);
        
        // Check that user received USDC
        assertEq(usdc.balanceOf(user), expectedAmount);
    }

    function testCancelSwapOrder() public {
        uint256 amount = 1 * 10**18;
        uint256 expectedAmount = 1800 * 10**6;
        uint256 deadline = block.timestamp + 1 hours;
        bytes32 hashlock = keccak256(abi.encodePacked("secret123"));
        
        weth.approve(address(fusionPlusSwap), amount);
        
        fusionPlusSwap.createSwapOrder(
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock
        );
        
        bytes32 orderId = keccak256(abi.encodePacked(
            user,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock,
            block.timestamp - 1
        ));
        
        // Fast forward past deadline
        vm.warp(deadline + 1);
        
        vm.expectEmit(true, true, true, true);
        emit SwapOrderCancelled(orderId, user);
        
        fusionPlusSwap.cancelSwapOrder(orderId);
        
        // Check that user got their WETH back
        assertEq(weth.balanceOf(user), 1000 * 10**18);
    }

    function testInitiateCrossChainSwap() public {
        uint256 amount = 1 * 10**18;
        uint256 expectedAmount = 1800 * 10**6;
        uint256 deadline = block.timestamp + 1 hours;
        uint32 destinationChain = 84532; // Base Sepolia
        
        weth.approve(address(fusionPlusSwap), amount);
        
        vm.expectEmit(true, true, true, true);
        emit CrossChainOrderInitiated(
            bytes32(0), // orderId will be different
            destinationChain,
            user,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline
        );
        
        fusionPlusSwap.initiateCrossChainSwap(
            destinationChain,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline
        );
    }

    function testCompleteCrossChainSwap() public {
        uint256 amount = 1 * 10**18;
        uint256 expectedAmount = 1800 * 10**6;
        uint256 deadline = block.timestamp + 1 hours;
        uint32 destinationChain = 84532;
        
        weth.approve(address(fusionPlusSwap), amount);
        
        fusionPlusSwap.initiateCrossChainSwap(
            destinationChain,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline
        );
        
        bytes32 orderId = keccak256(abi.encodePacked(
            user,
            destinationChain,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            keccak256(abi.encodePacked(keccak256(abi.encodePacked(
                user,
                destinationChain,
                address(weth),
                address(usdc),
                amount,
                expectedAmount,
                deadline,
                block.timestamp
            )))),
            block.timestamp - 1
        ));
        
        // Get the secret
        bytes32 secret = keccak256(abi.encodePacked(
            user,
            destinationChain,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            block.timestamp - 1
        ));
        
        // Transfer USDC to contract
        usdc.transfer(address(fusionPlusSwap), expectedAmount);
        
        vm.stopPrank();
        vm.startPrank(executor);
        
        vm.expectEmit(true, true, true, true);
        emit CrossChainOrderCompleted(orderId, secret);
        
        fusionPlusSwap.completeCrossChainSwap(orderId, secret);
        
        vm.stopPrank();
        vm.startPrank(user);
        
        // Check that user received USDC
        assertEq(usdc.balanceOf(user), expectedAmount);
    }

    function testFailInvalidAmount() public {
        uint256 amount = 0.0001 * 10**18; // Too small
        uint256 expectedAmount = 1800 * 10**6;
        uint256 deadline = block.timestamp + 1 hours;
        bytes32 hashlock = keccak256(abi.encodePacked("secret123"));
        
        weth.approve(address(fusionPlusSwap), amount);
        
        vm.expectRevert("Amount too small");
        fusionPlusSwap.createSwapOrder(
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock
        );
    }

    function testFailUnauthorizedExecutor() public {
        uint256 amount = 1 * 10**18;
        uint256 expectedAmount = 1800 * 10**6;
        uint256 deadline = block.timestamp + 1 hours;
        bytes32 secret = keccak256(abi.encodePacked("secret123"));
        bytes32 hashlock = keccak256(abi.encodePacked(secret));
        
        weth.approve(address(fusionPlusSwap), amount);
        
        fusionPlusSwap.createSwapOrder(
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock
        );
        
        bytes32 orderId = keccak256(abi.encodePacked(
            user,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock,
            block.timestamp - 1
        ));
        
        vm.stopPrank();
        vm.startPrank(address(0x999)); // Unauthorized address
        
        vm.expectRevert("Not authorized");
        fusionPlusSwap.executeSwapOrder(orderId, secret);
    }

    function testFailInvalidSecret() public {
        uint256 amount = 1 * 10**18;
        uint256 expectedAmount = 1800 * 10**6;
        uint256 deadline = block.timestamp + 1 hours;
        bytes32 hashlock = keccak256(abi.encodePacked("secret123"));
        
        weth.approve(address(fusionPlusSwap), amount);
        
        fusionPlusSwap.createSwapOrder(
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock
        );
        
        bytes32 orderId = keccak256(abi.encodePacked(
            user,
            address(weth),
            address(usdc),
            amount,
            expectedAmount,
            deadline,
            hashlock,
            block.timestamp - 1
        ));
        
        vm.stopPrank();
        vm.startPrank(executor);
        
        vm.expectRevert("Invalid secret");
        fusionPlusSwap.executeSwapOrder(orderId, keccak256(abi.encodePacked("wrongsecret")));
    }

    function testAdminFunctions() public {
        vm.stopPrank();
        
        // Test setting limits
        fusionPlusSwap.setLimits(0.01 ether, 100 ether);
        assertEq(fusionPlusSwap.minSwapAmount(), 0.01 ether);
        assertEq(fusionPlusSwap.maxSwapAmount(), 100 ether);
        
        // Test setting protocol fee
        fusionPlusSwap.setProtocolFee(10); // 0.1%
        assertEq(fusionPlusSwap.protocolFee(), 10);
        
        // Test setting default timeout
        fusionPlusSwap.setDefaultTimeout(2 hours);
        assertEq(fusionPlusSwap.defaultTimeout(), 2 hours);
        
        // Test setting supported token
        address newToken = address(0x789);
        fusionPlusSwap.setSupportedToken(newToken, true);
        assertTrue(fusionPlusSwap.supportedTokens(newToken));
        
        // Test setting authorized executor
        address newExecutor = address(0xABC);
        fusionPlusSwap.setAuthorizedExecutor(newExecutor, true);
        assertTrue(fusionPlusSwap.authorizedExecutors(newExecutor));
    }

    function testCalculateFee() public {
        uint256 amount = 1000 * 10**18; // 1000 WETH
        uint256 fee = fusionPlusSwap.calculateFee(amount);
        assertEq(fee, (amount * 5) / 10000); // 0.05% fee
    }
} 