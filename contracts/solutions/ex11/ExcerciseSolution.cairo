%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.token.erc20.library import ERC20
from starkware.cairo.common.math import assert_not_equal

@contract_interface
namespace DTK {
    func faucet() -> (success: felt) {
    }
}


@storage_var
func claims(account: felt) -> (total: Uint256) {
}

@view
func tokens_in_custody{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (total: Uint256) {
    return claims.read(account);
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