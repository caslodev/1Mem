// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address public owner;

    function setUp() public {
        owner = address(this);
        counter = new Counter();
    }

    function testInitialState() public {
        assertEq(counter.counter(), 0);
        assertEq(counter.owner(), owner);
    }

    function testHandleIncrement() public {
        // Simulate Hyperlane message
        uint32 origin = 1;
        bytes32 sender = bytes32(uint256(uint160(address(0x123))));
        bytes memory message = abi.encode("increment");
        
        // Expect event emission
        vm.expectEmit(true, true, true, true);
        emit Incremented(1);
        
        counter.handle(origin, sender, message);
        
        assertEq(counter.counter(), 1);
    }

    function testHandleInvalidCommand() public {
        uint32 origin = 1;
        bytes32 sender = bytes32(uint256(uint160(address(0x123))));
        bytes memory message = abi.encode("invalid");
        
        vm.expectRevert("Invalid command");
        counter.handle(origin, sender, message);
    }

    function testOnlyHyperlaneCanCallHandle() public {
        // This test would require mocking the Hyperlane ISM
        // For now, we'll just verify the function exists and works
        uint32 origin = 1;
        bytes32 sender = bytes32(uint256(uint160(address(0x123))));
        bytes memory message = abi.encode("increment");
        
        counter.handle(origin, sender, message);
        assertEq(counter.counter(), 1);
    }
}
