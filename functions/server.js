const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');

const app = express();

app.use(bodyParser.json());

// Replace these with your actual credentials/config from JazzCash
const JAZZCASH_MERCHANT_ID = 'MC59733';
const JAZZCASH_PASSWORD = 'f527214a21';
const JAZZCASH_API_URL = 'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/';

app.post('/initiate-payment', async (req, res) => {
    const { amount, orderId, etc } = req.body;

    // Generate parameters and secure hash
    const params = {
        pp_MerchantID: JAZZCASH_MERCHANT_ID,
        pp_Amount: amount,           // The total amount to be paid.
        pp_TxnRefNo: orderId,        // A unique order or transaction reference number.
        pp_TxnDateTime: new Date().toISOString(), // Transaction Date and Time.
        pp_BillReference: "billRef", // Billing reference if any.
        pp_Description: "Payment for order " + orderId, // Description of what the payment is for.
        pp_TxnCurrency: "PKR",       // Transaction currency, likely PKR for JazzCash.
        pp_Language: "EN",           // Language for the transaction.
        pp_Version: "1.1",           // API version.
        pp_Password: JAZZCASH_PASSWORD, // Merchant password or secret.
        // ... any other required parameters as per JazzCash's documentation
    };
    
    
    // Note: The secure hash generation process depends on JazzCash's documentation. Typically it involves some kind of hashing using a secret.

    try {
        const response = await axios.post(JAZZCASH_API_URL, params);
        
        // Handle the response from JazzCash
        if(response.data && response.data.redirectUrl) {
            return res.json({ redirectUrl: response.data.redirectUrl });
        } else {
            return res.status(400).json({ error: 'Failed to initiate payment' });
        }
    } catch (error) {
        console.error('Error initiating payment:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

app.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});
