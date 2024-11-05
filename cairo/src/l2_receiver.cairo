use starknet::{ContractAddress, get_contract_address, contract_address_const};
use starknet::storage::{
    Map, StoragePointerWriteAccess, StorageMapReadAccess, StoragePointerReadAccess, StoragePath,
    StoragePathEntry, StorageMapWriteAccess
};
use starknet::EthAddress;
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


#[starknet::contract]
pub mod ReceiveCounter {
    use core::starknet::{
        ContractAddress, get_caller_address,
        storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePathEntry}
    };
    use ekubo::extensions::interfaces::twamm::{OrderKey, OrderInfo};
    use super::EthAddress;

    // storage
    #[storage]
    struct Storage {
        count: u32
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

    struct Message {
        operation_type: u8,
        order_key: OrderKey,
        id: u64,
        sale_rate_delta: u128,
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
            let mut current_count = self.count.read();
            self.count.write(current_count + 1);
            true
        }


    }
    // #[external(v0)]
    // fn update_count(ref self: ContractState) {
    //     // Call the on_receive function and use its return value
    //     let received = self.on_receive(l2_token, amount, depositor, message);
    //     if received {
    //         let mut current_count = self.count.read();
    //         self.count.write(current_count + 1);
    //     }
    // }
    
 
    #[external(v0)]
    pub fn get_count(self: @ContractState) -> u32 {
        self.count.read()
    }
}
//https://sepolia.starkscan.co/contract/0x820ab2bc3e99e3522daabb53c0da6da0e3e584da48c013d1f4cb762d1f936b

