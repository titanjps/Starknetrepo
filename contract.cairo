%lang starknet

%builtins {
    pedersen x_pedersen
    field_mul x_scalar_mul
}

%include "starkware_utils.cairo"

%{
# Constants
const TOKEN_NAME = "MyToken";
const TOKEN_SYMBOL = "MTK";
const DECIMALS = 18;
const TOTAL_SUPPLY = 1000000000000000000000000;  # 1,000,000 MTK with 18 decimals.

# Storage layout.
storage:
    total_supply : felt;
    balances: (felt, felt) -> felt;
    allowed: ((felt, felt), felt) -> felt;

# Event definitions.
event Transfer(from_index : felt, to_index : felt, amount : felt)
    is_valid_transfer(from_balance : felt, to_balance : felt, amount : felt);

event Approval(owner_index : felt, spender_index : felt, amount : felt);

# Internal function to check if transfer is valid.
func is_valid_transfer(from_balance : felt, to_balance : felt, amount : felt) -> (is_valid : felt):
    is_valid := from_balance >= amount and to_balance + amount >= to_balance;

# Internal function to check if approval is valid.
func is_valid_approval(owner_balance : felt, spender_allowance : felt, amount : felt) -> (is_valid : felt):
    is_valid := owner_balance >= amount and spender_allowance + amount >= spender_allowance;
%}

# Initializes the contract.
public function init():
    total_supply := TOTAL_SUPPLY;
    balances(0, 0) := TOTAL_SUPPLY;

# Returns the name of the token.
public function name() -> (result : felt):
    result := to_nbits(TOKEN_NAME);

# Returns the symbol of the token.
public function symbol() -> (result : felt):
    result := to_nbits(TOKEN_SYMBOL);

# Returns the number of decimals the token uses.
public function decimals() -> (result : felt):
    result := DECIMALS;

# Returns the total supply of the token.
public function totalSupply() -> (result : felt):
    result := total_supply;

# Returns the balance of the given address.
public function balanceOf(owner : felt) -> (result : felt):
    result := balances(owner, 0);

# Transfers tokens from the sender to the specified recipient.
public function transfer(to : felt, amount : felt):
    # Ensure the transfer is valid.
    is_valid_transfer(balances(sender, 0), balances(to, 0), amount)
        is_valid_transfer(balances(sender, 0), balances(to, 0), amount)
    {
        balances(sender, 0) := balances(sender, 0) - amount;
        balances(to, 0) := balances(to, 0) + amount;
        # Emit Transfer event.
        Transfer(sender, to, amount);
    }

# Allows spender to withdraw from the sender's account, multiple times, up to the amount.
# If this function is called again, it overwrites the current allowance with `amount`.
public function approve(spender : felt, amount : felt):
    allowed((sender, spender), 0) := amount;
    # Emit Approval event.
    Approval(sender, spender, amount);

# Returns the amount that spender is allowed to withdraw from owner.
public function allowance(owner : felt, spender : felt) -> (result : felt):
    result := allowed((owner, spender), 0);

# Transfers tokens from one address to another using the allowance mechanism.
public function transferFrom(from : felt, to : felt, amount : felt):
    # Ensure the transfer is valid and spender has sufficient allowance.
    is_valid_transfer(balances(from, 0), balances(to, 0), amount)
        is_valid_approval(balances(from, 0), allowed((from, sender), 0), amount)
    {
        balances(from, 0) := balances(from, 0) - amount;
        balances(to, 0) := balances(to, 0) + amount;
        allowed((from, sender), 0) := allowed((from, sender), 0) - amount;
        # Emit Transfer event.
        Transfer(from, to, amount);
    }
