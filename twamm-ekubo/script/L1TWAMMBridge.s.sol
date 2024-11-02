// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.23;

import "forge-std/Script.sol";
import {L1TWAMMBridge} from "../src/L1TWAMMBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IStarknetTokenBridge {
    function depositWithMessage(address token, uint256 amount, uint256 l2Recipient, uint256[] calldata message)
        external
        payable;
    function deposit(address token, uint256 amount, uint256 l2Recipient) external payable;
    function sendMessageToL2(uint256 l2Recipient, uint256 selector, uint256[] calldata payload) external payable;
    function depositMessagePayload(
        address token,
        uint256 amount,
        uint256 l2Recipient,
        bool withMessage,
        uint256[] memory message
    ) external view returns (uint256[] memory);
    function isServicingToken(address token) external view returns (bool);
}

contract L1TWAMMBridgeInteraction is Script {
    L1TWAMMBridge public bridge;
    address public user;

    address token = address(0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766);
    IStarknetTokenBridge starknetBridge = IStarknetTokenBridge(0xcE5485Cfb26914C5dcE00B9BAF0580364daFC7a4);
    address l2EkuboAddress = address(0x123);
    uint256 l2EndpointAddress = 0x3bbd256734abe14157da0af3a16436d046e1bf2b77bb97567b88d5d530fb7ee;
    address starknetRegistry = address(0xdc1564B4E0b554b26b2CFd2635B84A0777035d11);

    uint128 public start = uint128((block.timestamp + 16) - (block.timestamp % 16)); //switched to this because the first one was failing
    uint128 public end = start + 64;

    function setUp() public {
        bridge = L1TWAMMBridge(0x1F7F7f1F9f03ebd10169421713fC91881425AA0A);
        user = msg.sender;
    }

    function run() external {
        vm.startBroadcast();

        uint256 amount = 0.5 * 10 ** 6;
        uint256 lower128Bits = amount & ((1 << 128) - 1); // or amount & (2**128 - 1)
        uint256 upper128Bits = amount >> 128;

        IERC20 tokenContract = IERC20(token);

        // Debug logs to understand initial state
        console.log("Initial Stark balance of user:", tokenContract.balanceOf(tx.origin));
        console.log("Initial ETH balance of user:", tx.origin.balance);
        console.log("Initial Stark balance of bridge:", tokenContract.balanceOf(address(bridge)));

        // First approve the bridge to spend tokens
        tokenContract.approve(address(bridge), amount);

        uint256[] memory payload = new uint256[](5);
        payload[0] = uint256(uint160(address(token))); // token address
        payload[1] = uint256(uint160(tx.origin)); // from address
        payload[2] = uint256(l2EndpointAddress); // l2 endpoint address
        payload[3] = lower128Bits;
        payload[4] = upper128Bits;

        bridge.depositAndCreateOrder{value: 0.01 ether}(amount, l2EndpointAddress, start, end, token, token, 0.01 ether);
        // bool isServicingToken = starknetBridge.isServicingToken(token);
        // console.log("Is servicing token:", isServicingToken);

        // address bridge = starknetRegistry.getBridge(token);
        // console.log("Bridge:", bridge);

        // bridge.depositWithMessage{value: 0.01 ether}(amount, l2EndpointAddress, payload);

        vm.stopBroadcast();
    }
}
