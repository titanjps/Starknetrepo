# Import the Starknet library (replace 'starknet' with the actual library name).
import starknet

# Replace with your contract address and private key.
contract_address = '0x123abc'
private_key = 'your_private_key'

# Replace with the target address where you want to transfer the funds.
target_address = '0x456def'

# Function to check and perform the transfer.
async def auto_withdraw():
    try:
        # Get the balance of the contract address.
        balance = await starknet.get_balance(contract_address)

        # If there's a non-zero balance, initiate the transfer.
        if balance > 0:
            transfer_result = await starknet.transfer(
                from_address=contract_address,
                to_address=target_address,
                amount=balance,
                private_key=private_key
            )

            print(f"Transfer successful. Transaction hash: {transfer_result['transaction_hash']}")
        else:
            print('No funds to transfer.')
    except Exception as e:
        print(f'Error: {str(e)}')

# Set up an interval to run the auto_withdraw function every 5 minutes (adjust as needed).
import time

while True:
    auto_withdraw()
    time.sleep(5 * 60)  # Sleep for 5 minutes
