%lang starknet

%builtins pedersen range_check ecdsa

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address

struct Poll:
  member yes : felt
  member no : felt
  member open : felt
end

@storage_var
func poll_mapping(id : felt) -> (array : Poll):
end

@storage_var
func poll_users(poll_id: felt, index: felt) -> (user_public_key: felt):
end

@storage_var
func poll_users_length(poll_id: felt) -> (length: felt):
end

func add_poll_users{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (poll_id: felt, user_public_key: felt) -> ():
    let (insertion_index) = poll_users_length.read(poll_id = poll_id)
    poll_users.write(
        poll_id = poll_id,
        index = insertion_index,
        value = user_public_key,
    )
    let new_length = insertion_index + 1
    poll_users_length.write(poll_id = poll_id, value = new_length)
    return ()
end