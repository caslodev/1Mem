// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Counter.sol";
import "../src/FusionPlusSwap.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        Counter counter = new Counter();
        FusionPlusSwap fusionPlusSwap = new FusionPlusSwap();
        
        console.log("Counter deployed at:", address(counter));
        console.log("FusionPlusSwap deployed at:", address(fusionPlusSwap));
        console.log("Deployer address:", vm.addr(deployerPrivateKey));

        vm.stopBroadcast();
    }
} 