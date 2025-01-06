// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import "forge-std/console.sol";
import {OrderParams} from "../src/types/OrderParams.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {IStarknetMessaging} from "../src/interfaces/IStarknetMessaging.sol";

interface IL1TWAMMBridge {
    function depositAndCreateOrder(OrderParams memory params) external payable;
    function deposit(
        uint256 amount,
        uint256 l2EndpointAddress
    ) external payable;
    function initiateWithdrawal(
        uint256 amount,
        address l1_token
    ) external payable;
    function _sendMessage(
        uint256 contractAddress,
        uint256 selector,
        uint256[] memory payload
    ) external payable;
    function setL2EndpointAddress(uint256 _l2EndpointAddress) external;
    function initiateCancelDepositRequest(
        address l1_token,
        uint256 amount,
        uint256 nonce
    ) external;
}

interface IStarknetGateBridge {
    function depositWithMessage(
        address token,
        uint256 amount,
        uint256 l2Recipient,
        uint256[] calldata message
    ) external payable;
}

contract DepositAndCreateOrder is Script {
    function run() public {
        // Configuration
        address strkToken = 0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766; //stark on l1 sepolia
        address usdcBuyToken = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238; //usdc on l1 sepolia
        // IStarknetMessaging snMessaging = IStarknetMessaging(0xE2Bb56ee936fd6433DC0F6e7e3b8365C906AA057);
        address bridgeAddress = 0xA5fF09d43E9f0572BC072b169d4a975768fe05BB;
        uint256 l2EndpointAddress = uint256(
            0x1faf6acdf200ef465ed828e948e626c1b063707810b4702e3197b8ac9eb132a
        );
        uint256 sellTokenAddress = 0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d; //stark on l2
        uint256 buyTokenAddress = 0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080; //usdc on l2
        // Order parameters
        uint128 currentTimestamp = uint128(block.timestamp);
        uint128 difference = 16 - (currentTimestamp % 16); // gets the difference between the current timestamp and the next 16 second interval
        uint128 start = currentTimestamp + difference;
        uint128 end = start + 128;

        uint128 amount = 0.0007 * 10 ** 18;
        uint128 fee = 0.0005 ether;
        // uint256 gasPrice = block.basefee * 1;

        vm.startBroadcast();

        // Approve token spending
        IERC20(strkToken).approve(bridgeAddress, type(uint256).max);

        OrderParams memory params = OrderParams({
            sender: msg.sender,
            sellToken: sellTokenAddress,
            buyToken: buyTokenAddress,
            fee: 170141183460469235273462165868118016,
            start: start,
            end: end,
            amount: amount
        });

        // IL1TWAMMBridge(bridgeAddress).initiateCancelDepositRequest{gas: gasPrice}(0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766, amount, 10631);
        IL1TWAMMBridge(bridgeAddress).depositAndCreateOrder{value: fee}(params);

        // IStarknetGateBridge(bridgeAddress)
        //     .depositWithMessage{value: fee}(
        //     strkToken,
        //     amount,
        //     l2EndpointAddress,
        //     withdrawal_message
        // );
        // IL1TWAMMBridge(bridgeAddress).initiateWithdrawal{value: fee}(amount, 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238);
        // IL1TWAMMBridge(bridgeAddress).setL2EndpointAddress(l2EndpointAddress);
        vm.stopBroadcast();
    }
}
