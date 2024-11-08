// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {OrderParams} from "../src/types/OrderParams.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IL1TWAMMBridge {
    function depositAndCreateOrder(OrderParams memory params) external payable;
    function deposit(uint256 amount, uint256 l2EndpointAddress) external payable;
    function initiateWithdrawal(uint256 tokenId) external payable;
}


contract DepositAndCreateOrder is Script {
    function run() public {
        // Configuration
        address strkToken = 0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766;
        address usdcSellToken = 0x833589FCd6EDB6e08b1D49dC5d1F3E818a548824;

        address bridgeAddress = 0x4E3d409Bf0583cD9D2Cdb58265B9C6f15556325d;
        uint256 l2EndpointAddress = uint256(0x59ed9a2f59b0d0d4123a21d02ee64d3c3e9119b34494b73c70714ed4efa263c);
        uint256 sellTokenAddress = 0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d;
        uint256 buyTokenAddress = 0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080;
        // Order parameters
        uint128 start = uint128((block.timestamp / 16) * 16); // Round down to nearest multiple of 16
        uint128 end = start + 64;
        uint128 amount = .01 ether;
        uint128 fee = 0.01 ether;

        vm.startBroadcast();

        // Approve token spending
        IERC20(strkToken).approve(bridgeAddress, type(uint256).max);

        // Create order parameters
        OrderParams memory params = OrderParams({
            sender: msg.sender,
            sellToken: sellTokenAddress,
            buyToken: buyTokenAddress,
            fee: 0,
            start: start,
            end: end,
            amount: amount,
            l2EndpointAddress: l2EndpointAddress
        });



        // Create order
        IERC20(strkToken).transfer(bridgeAddress, amount);
        //IL1TWAMMBridge(bridgeAddress).deposit{value: fee}(amount, l2EndpointAddress);
        //IL1TWAMMBridge(bridgeAddress).depositAndCreateOrder{value: fee}(params);
        IL1TWAMMBridge(bridgeAddress).initiateWithdrawal{value:fee}(0);

        vm.stopBroadcast();
    }
}