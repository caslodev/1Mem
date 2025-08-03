// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@hyperlane-xyz/core/interfaces/IMessageRecipient.sol";

contract Counter is IMessageRecipient {
    uint256 public counter;
    address public owner;

    event Incremented(uint256 newCounter);

    constructor() {
        owner = msg.sender;
    }

    // Called by Hyperlane ISM (Interchain Security Module)
    function handle(
        uint32 origin,
        bytes32 sender,
        bytes calldata message
    ) external override {
        // Decode message (no need to check content for simple increment)
        string memory command = abi.decode(message, (string));
        require(keccak256(bytes(command)) == keccak256(bytes("increment")), "Invalid command");

        counter += 1;
        emit Incremented(counter);
    }
}
