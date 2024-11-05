// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {L1TWAMMBridge} from "../src/L1TWAMMBridge.sol";

contract DeployL1TWAMMBridge is Script {
    function run() public returns (L1TWAMMBridge) {
     
        address token = address(0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766);
        address starknetBridge = address(0xcE5485Cfb26914C5dcE00B9BAF0580364daFC7a4);
        address l2EkuboAddress = address(0x123);
        uint256 l2EndpointAddress = 0x1e4af2a6be9977dca8a2c46da65abb698fb09c20013b2f616bab21c6a08d79a;
        address starknetRegistry = address(0xdc1564B4E0b554b26b2CFd2635B84A0777035d11);

        vm.startBroadcast();

        L1TWAMMBridge bridge = new L1TWAMMBridge(
            token,
            starknetBridge,
            l2EkuboAddress,
            l2EndpointAddress,
            starknetRegistry
        );

        vm.stopBroadcast();

        return bridge;
    }
} 