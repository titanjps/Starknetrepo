%lang starknet

%builtins {
    pedersen x_pedersen
    field_mul x_scalar_mul
}

%include "starkware_utils.cairo"

%{
# Constants
const TOKEN_NAME = "MyNFT";
const TOKEN_SYMBOL = "NFT";
const TOTAL_SUPPLY = 1000;  # Total number of NFTs.

# Storage layout.
storage:
    owner: (felt) -> felt;
    token_uri: (felt) -> felt;

# Event definitions.
event Transfer(token_id : felt, from_index : felt, to_index : felt)
    is_valid_transfer(from_owner : felt, to_owner : felt, token_id : felt);

# Internal function to check if transfer is valid.
func is_valid_transfer(from_owner : felt, to_owner : felt, token_id : felt) -> (is_valid : felt):
    is_valid := from_owner == tx_sender() and from_owner != to_owner;

# Initializes the contract.
public function init():
    # Mint all tokens to the contract deployer initially.
    for i in felt(0) to felt(TOTAL_SUPPLY - 1):
        owner(i) := tx_sender();
        token_uri(i) := 0;

# Returns the name of the token.
public function name() -> (result : felt):
    result := to_nbits(TOKEN_NAME);

# Returns the symbol of the token.
public function symbol() -> (result : felt):
    result := to_nbits(TOKEN_SYMBOL);

# Returns the total supply of the token.
public function totalSupply() -> (result : felt):
    result := TOTAL_SUPPLY;

# Returns the owner of the specified token.
public function ownerOf(token_id : felt) -> (result : felt):
    result := owner(token_id);

# Returns the URI of the specified token.
public function tokenURI(token_id : felt) -> (result : felt):
    result := token_uri(token_id);

# Transfers ownership of a given token to another address.
public function transfer(to : felt, token_id : felt):
    # Ensure the transfer is valid.
    is_valid_transfer(owner(token_id), to, token_id)
        is_valid_transfer(owner(token_id), to, token_id)
    {
        owner(token_id) := to;
        # Emit Transfer event.
        Transfer(token_id, tx_sender(), to);
    }
