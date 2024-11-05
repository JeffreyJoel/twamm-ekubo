use starknet::{ContractAddress, get_contract_address, contract_address_const};
use starknet::storage::{
    Map, StoragePointerWriteAccess, StorageMapReadAccess, StoragePointerReadAccess, StoragePath,
    StoragePathEntry, StorageMapWriteAccess
};
use starknet::EthAddress;
use ekubo::extensions::interfaces::twamm::{OrderKey, OrderInfo};

// use array::SpanTrait;

#[starknet::interface]
trait IMsgReceiver<TContractState> {
    fn on_receive(
        ref self: TContractState,
        l2_token: ContractAddress,
        amount: u256,
        depositor: EthAddress,
        message: Span<felt252>
    ) -> bool;
}

#[starknet::interface]
pub trait ITokenBridge<TContractState> {
    fn get_version(self: @TContractState) -> felt252;
    fn get_identity(self: @TContractState) -> felt252;
    fn get_l1_token(self: @TContractState, l2_token: ContractAddress) -> EthAddress;
    fn get_l2_token(self: @TContractState, l1_token: EthAddress) -> ContractAddress;
    fn get_remaining_withdrawal_quota(self: @TContractState, l1_token: EthAddress) -> u256;
    fn initiate_withdraw(ref self: TContractState, l1_recipient: EthAddress, amount: u256);
    fn initiate_token_withdraw(
        ref self: TContractState, l1_token: EthAddress, l1_recipient: EthAddress, amount: u256
    );
}

#[starknet::contract]
pub mod ReceiveCounter {
    use core::starknet::{
        ContractAddress, get_caller_address,
        storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePathEntry, StorageBaseAddress}
    };
    use ekubo::extensions::interfaces::twamm::{OrderKey, OrderInfo};
    use super::EthAddress;
    use super::{ITokenBridge, ITokenBridgeDispatcher, ITokenBridgeDispatcherTrait};

    // storage
    #[storage]
    struct Storage {
        count: u32
    }
    #[derive(Drop, Serde)] 
    struct Message {
        operation_type: u8,
        order_key: OrderKey,
        id: u64,
        sale_rate_delta: u128,
    }

    //event
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        CountUpdated:CountUpdated,
    }

    #[derive(Drop, starknet::Event)]
    pub struct CountUpdated {
        pub new_count: u32
    }
    
    #[abi(embed_v0)]
    impl L2TWAMMBridge of super::IMsgReceiver<ContractState> {
        fn on_receive(
        ref self: ContractState,
        l2_token: ContractAddress,
        amount: u256,
        depositor: EthAddress,
        message: Span<felt252>
        ) -> bool {
            let mut message_span = message;
            // let mut current_count = self.count.read();
            // let lower_amount_bits: u128 = (amount & 0xffffffffffffffffffffffffffffffff_u256).try_into().unwrap();
            let first_element = *message[0];
            if first_element == 0 {     
                let mut current_count = self.count.read();
                self.count.write(current_count + 1);
            }
            true
        }
    }
    #[external(v0)]
    pub fn get_count(self: @ContractState) -> u32 {
        self.count.read()
    }

    #[external(v0)]
    fn execute_withdrawal(
        ref self: ContractState, depositor: EthAddress, amount: u256, message: Message
    ) -> bool {
        // let order_key = message.order_key;
        // let id = message.id;

        // let user = self.get_depositor_from_id(id);

        // let amount_sold = self.withdraw_proceeds_from_sale_to_self(id, order_key);
        // assert(amount_sold != 0, ERROR_NO_TOKENS_SOLD);
        // let new_amount = amount - amount_sold;
        // self.sender_to_amount.write(depositor, new_amount);
        // let bridge_address = self.get_l2_bridge_by_l2_token(order_key.buy_token);
        let token_bridge = ITokenBridgeDispatcher {
            contract_address: 0x0594c1582459ea03f77deaf9eb7e3917d6994a03c13405ba42867f83d85f085d.try_into().unwrap()
        };
        let l1_token: EthAddress = 0xCa14007Eff0dB1f8135f4C25B34De49AB0d42766.try_into().unwrap();

        token_bridge.initiate_token_withdraw(l1_token, depositor, amount);
        true
    }
}
//https://sepolia.starkscan.co/contract/0x820ab2bc3e99e3522daabb53c0da6da0e3e584da48c013d1f4cb762d1f936b