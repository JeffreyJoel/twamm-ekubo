// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {L1TWAMMBridge} from "../src/L1TWAMMBridge.sol";

contract DeployL1TWAMMBridge is Script {
    function run() public returns (L1TWAMMBridge) {
     
        address token = address(0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766);
        address starknetBridge = address(0xF6217de888fD6E6b2CbFBB2370973BE4c36a152D);
        address l2EkuboAddress = address(0x123);
        uint256 l2EndpointAddress = 0x6b8fcf379ffde86d47480e2ed78fdf870dac13bbb155b3c9e9c6af8bca0fa24;
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