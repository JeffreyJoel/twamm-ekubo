// L1 Token Addresses
const L1_ETH_ADDRESS: felt252 = 0x0000000000000000000000000000000000455448;
const L1_STRK_ADDRESS: felt252 = 0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766;
const L1_USDC_ADDRESS: felt252 = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
const L1_USDT_ADDRESS: felt252 = 0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0;
const L1_WBTC_ADDRESS: felt252 = 0x92f3B59a79bFf5dc60c0d59eA13a44D082B2bdFC;
const L1_WSTETH_ADDRESS: felt252 = 0xB82381A3fBD3FaFA77B3a7bE693342618240067b;

// L2 Bridge Addresses
const L2_ETH_BRIDGE: felt252 = 0x04c5772d1914fe6ce891b64eb35bf3522aeae1315647314aac58b01137607f3f;
const L2_STRK_BRIDGE: felt252 = 0x0594c1582459ea03f77deaf9eb7e3917d6994a03c13405ba42867f83d85f085d;
const L2_USDC_BRIDGE: felt252 = 0x0028729b12ce1140cbc1e7cbc7245455d3c15fa0c7f5d2e9fc8e0441567f6b50;
const L2_USDT_BRIDGE: felt252 = 0x3913d184e537671dfeca3f67015bb845f2d12a26e5ec56bdc495913b20acb08;
const L2_WBTC_BRIDGE: felt252 = 0x025a3820179262679392e872d7daaa44986af7caae1f41b7eedee561ca35a169;
const L2_WSTETH_BRIDGE: felt252 = 0x0172393a285eeac98ea136a4be473986a58ddd0beaf158517bc32166d0328824;

const TOKEN_BRIDGE_MAPPING: [(felt252, felt252); 6] = [
    (L1_ETH_ADDRESS, L2_ETH_BRIDGE),
    (L1_STRK_ADDRESS, L2_STRK_BRIDGE),
    (L1_USDC_ADDRESS, L2_USDC_BRIDGE),
    (L1_USDT_ADDRESS, L2_USDT_BRIDGE),
    (L1_WBTC_ADDRESS, L2_WBTC_BRIDGE),
    (L1_WSTETH_ADDRESS, L2_WSTETH_BRIDGE)
];