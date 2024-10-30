// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.23;

import "forge-std/Script.sol";
import "../src/L1TWAMMBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract L1TWAMMBridgeInteraction is Script {
    L1TWAMMBridge public bridge;
    address public user;

    address token = address(0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766);
    address starknetBridge = address(0xcE5485Cfb26914C5dcE00B9BAF0580364daFC7a4);
    address l2EkuboAddress = address(0x123);
    uint256 l2EndpointAddress = 0x6b8fcf379ffde86d47480e2ed78fdf870dac13bbb155b3c9e9c6af8bca0fa24;
    address starknetRegistry = address(0xdc1564B4E0b554b26b2CFd2635B84A0777035d11);

    function setUp() public {
        bridge = L1TWAMMBridge(0xBbf163D8ecB9Fd517C8cc2DB13bc34c6BcdF5B71);
        user = msg.sender;
    }

    function run() external {
        vm.startBroadcast(tx.origin);

        uint256 amount = 1 * 10 **18;
        IERC20 tokenContract = IERC20(token);

        // Debug logs to understand initial state
        console.log("Initial Stark balance of user:", tokenContract.balanceOf(tx.origin));
        console.log("Initial ETH balance of user:", tx.origin.balance);
        console.log("Initial Stark balance of bridge:", tokenContract.balanceOf(address(bridge)));

        // First approve and transfer tokens
        tokenContract.approve(address(bridge), UINT256_MAX);
        tokenContract.approve(address(starknetBridge), UINT256_MAX);
        tokenContract.transfer(address(bridge), amount);

        // Debug logs after transfer
        console.log("Stark balance of user after transfer:", tokenContract.balanceOf(tx.origin));
        console.log("Stark balance of bridge after transfer:", tokenContract.balanceOf(address(bridge)));

        // Let's try with a specific payload structure
        uint256[] memory payload = new uint256[](1);
        payload[0] = uint256(uint160(address(token))); // token address
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