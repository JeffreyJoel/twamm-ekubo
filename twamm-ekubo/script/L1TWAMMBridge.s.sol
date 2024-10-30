// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.23;

import "forge-std/Script.sol";
import "../src/L1TWAMMBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract L1TWAMMBridgeInteraction is Script {
    L1TWAMMBridge public bridge;
    address public user;

    address token = address(0x0000000000000000000000000000000000455448);
    address starknetBridge = address(0xF6217de888fD6E6b2CbFBB2370973BE4c36a152D);
    address l2EkuboAddress = address(0x123);
    uint256 l2EndpointAddress = 0x6b8fcf379ffde86d47480e2ed78fdf870dac13bbb155b3c9e9c6af8bca0fa24;
    address starknetRegistry = address(0xdc1564B4E0b554b26b2CFd2635B84A0777035d11);

    function setUp() public {
        bridge = L1TWAMMBridge(0x5b7362d1786AEFa1366f5949e3a2B8Ccae1F66b4);
        user = msg.sender;
    }

    function run() external {
        vm.startBroadcast(tx.origin);

        uint256 amount = 0.001 ether;
        IERC20 tokenContract = IERC20(token);

        // Debug logs to understand initial state
        console.log("Initial USDC balance of user:", tokenContract.balanceOf(tx.origin));
        console.log("Initial ETH balance of user:", tx.origin.balance);
        console.log("Initial USDC balance of bridge:", tokenContract.balanceOf(address(bridge)));

        // First approve and transfer tokens
        tokenContract.approve(address(bridge), UINT256_MAX);
        tokenContract.approve(address(0x86dC0B32a5045FFa48D9a60B7e7Ca32F11faCd7B), UINT256_MAX);
        tokenContract.transfer(address(bridge), amount);

        // Debug logs after transfer
        console.log("USDC balance of user after transfer:", tokenContract.balanceOf(tx.origin));
        console.log("USDC balance of bridge after transfer:", tokenContract.balanceOf(address(bridge)));

        // Let's try with a specific payload structure
        uint256[] memory payload = new uint256[](0);
        // payload[0] = uint256(uint160(address(token))); // token address
        // payload[1] = uint256(uint160(tx.origin)); // from address
        // payload[2] = amount; // amount

        // Debug log the payload
        // console.log("Payload[0] (token):", payload[0]);
        // console.log("Payload[1] (from):", payload[1]);
        // console.log("Payload[2] (amount):", payload[2]);

        bridge.depositWithMessage{value: 0.001 ether}(amount, l2EndpointAddress, payload);

        vm.stopBroadcast();
    }
} 