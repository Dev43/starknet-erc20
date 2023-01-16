%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (Uint256, uint256_add)
from starkware.starknet.common.syscalls import get_caller_address
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.math import assert_not_equal

@contract_interface
namespace DTK {
    func faucet() -> (success: felt) {
    }
}

@contract_interface
namespace TokenFaucet {
    func faucet_for_with_amount(for: felt, amount: Uint256) -> (success: felt) {
    }
}

@contract_interface
namespace IERC20 {
    func transferFrom(sender: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }
    func balanceOf(account: felt) -> (balance: Uint256) {
    }

}


// We call the get tokens function to have tokens in our contract
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
token_addr: felt
) {
    get_tokens_from_contract_for(address=0x14ece8a1dcdcc5a56f01a987046f2bd8ddfb56bc358da050864ae6da5f71394);
    token.write(token_addr);
    return ();
}


@storage_var
func claims(account: felt) -> (total: Uint256) {
}

@storage_var
func token() -> (token: felt) {
}

@view
func tokens_in_custody{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (total: Uint256) {
    return claims.read(account);
}

@view
func deposit_tracker_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (token: felt) {
    return token.read();
}

func get_tokens_from_contract_for{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address:felt) -> (claimed_amount: Uint256){

    let (is_ok) = DTK.faucet(contract_address=0x066aa72ce2916bbfc654fd18f9c9aaed29a4a678274639a010468a948a5e2a96);

    with_attr error_message("Could not call the faucet") {
        assert is_ok = 1;
    }

    let amount =  Uint256(100 * 1000000000000000000, 0);
    claims.write(address, amount);
    // we claim tokens on behalf of someone
    return (amount,);
}

@external
func get_tokens_from_contract{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (claimed_amount: Uint256){
    let (caller) = get_caller_address();

    let (is_ok) = DTK.faucet(contract_address=0x066aa72ce2916bbfc654fd18f9c9aaed29a4a678274639a010468a948a5e2a96);

    with_attr error_message("Could not call the faucet") {
        assert is_ok = 1;
    }

    let amount =  Uint256(100 * 1000000000000000000, 0);

    claims.write(caller,amount);
    // we claim tokens on behalf of someone
    return (amount,);
}

@external
func withdraw_all_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (amount: Uint256) {
      let (me) = get_contract_address();
      let (caller) = get_caller_address();
      let (am) = claims.read(caller);
      let (is_ok) = IERC20.transferFrom(contract_address=0x066aa72ce2916bbfc654fd18f9c9aaed29a4a678274639a010468a948a5e2a96, sender=me, recipient=caller, amount=am);
      with_attr error_message("problem transferring the tokens") {
        assert is_ok = 1;
      }
      return (am,);
}

// @external
// func deposit_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//   amount: Uint256
// ) -> (total: Uint256) {
//     let (caller) = get_caller_address();
//     let (me) = get_contract_address();

//     IERC20.transferFrom(contract_address=0x066aa72ce2916bbfc654fd18f9c9aaed29a4a678274639a010468a948a5e2a96, sender=caller, recipient=me, amount=amount);
//     let (current) = claims.read(caller);  
//     let (new_total,_) = uint256_add(current, amount);
//     claims.write(caller, new_total);
//     return (new_total,);
// }

@external
func deposit_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
  amount: Uint256
) -> (total: Uint256) {
    let (caller) = get_caller_address();
    let (me) = get_contract_address();

    IERC20.transferFrom(contract_address=0x066aa72ce2916bbfc654fd18f9c9aaed29a4a678274639a010468a948a5e2a96, sender=caller, recipient=me, amount=amount);

    let (token_addr) = token.read();
    TokenFaucet.faucet_for_with_amount(contract_address=token_addr, for=caller, amount=amount);
    let (new_total) = IERC20.balanceOf(contract_address=token_addr, account=caller);
    return (new_total,);
}