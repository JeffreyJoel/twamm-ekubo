
#[starknet::contract]
mod Receive_Counter{
    use core::starknet::{
        ContractAddress, get_caller_address,
        storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePathEntry}
    };


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
    
    #[external(v0)]
    pub fn update_count(ref self: ContractState, message: Array<felt252>){

        let message_str = message[0];
        if(message.len() > 0){
            let current_count = self.count.read();
            self.count.write(current_count + 1);
            self.emit(CountUpdated { new_count: current_count + 1 });
            println!("{}: Message received", message_str);
        }
        else{
           println!("No message");
        }
    }
}