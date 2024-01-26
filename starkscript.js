// Import the Starknet library (replace 'starknet' with the actual library name).
const starknet = require('starknet');

// Replace with your contract address and private key.
const contractAddress = '0x123abc';
const privateKey = 'your_private_key';

// Replace with the target address where you want to transfer the funds.
const targetAddress = '0x456def';

// Function to check and perform the transfer.
async function autoWithdraw() {
    try {
        // Get the balance of the contract address.
        const balance = await starknet.getBalance(contractAddress);

        // If there's a non-zero balance, initiate the transfer.
        if (balance > 0) {
            const transferResult = await starknet.transfer({
                from: contractAddress,
                to: targetAddress,
                amount: balance,
                privateKey: privateKey,
            });

            console.log(`Transfer successful. Transaction hash: ${transferResult.transactionHash}`);
        } else {
            console.log('No funds to transfer.');
        }
    } catch (error) {
        console.error('Error:', error.message);
    }
}

// Set up an interval to run the autoWithdraw function every 5 minutes (adjust as needed).
setInterval(autoWithdraw, 1 * 60 * 1000);
