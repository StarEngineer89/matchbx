const Web3 = require('web3');
const crypto = require('crypto');
const Tx = require('ethereumjs-tx');
const express = require('express');
const sql = require('mssql');
const app = express();
var PropertiesReader = require('properties-reader');

var properties = process.env.NODE_ENV === 'production' ? PropertiesReader('./properties.prod.env') : PropertiesReader('./properties.prod.env');
const algorithm = properties.get('algorithm');
const password = properties.get('password');


// config for your database
var config = {
    user: properties.get('dbuser'),
    password: properties.get('dbpassword'),
    server: properties.get('dbserver'),
    database: properties.get('database')
};

console.log(properties.get('web3_provider'));
const web3 = new Web3(new Web3.providers.HttpProvider(properties.get('web3_provider')));


function decryptPrivKey(text) {
    console.log("inside decryptPrivKey");
    console.log(text);

    var decipher = crypto.createDecipher(algorithm, password);
    var dec = decipher.update(text, 'hex', 'utf8');
    dec += decipher.final('utf8');
    return dec;
}

var nonce = -2;

function BurnTokens() {

    loadContracts().then(function (contracts) {
        var tokenAbi = JSON.parse(contracts[0].TokenABI);
        var enc_privKey = contracts[0].PrivateKeyHash;
        var token_address = contracts[0].TokenAddress;
        var tokenContract = web3.eth.contract(tokenAbi);
        var tokenInstance = tokenContract.at(token_address);
        var admin_address = contracts[0].OwnerAddress;

        var feeAccount = contracts[0].FeeAccount;//'0xAA6700cc830BA8baaF248f90D4213F01084BF471';
//        var burnAmount = contracts[0].AmountToBurn*Math.pow(10, 18);//100000000000000000000;        
	
	var burnAmount = 500000 * Math.pow(10,18);
        var callData = tokenInstance.burnFrom.getData(feeAccount,burnAmount);

        nonce = web3.eth.getTransactionCount(admin_address);

        console.log(nonce);

        var transactionObject = {
            nonce: web3.toHex(nonce),
            from: admin_address,
            gasPrice: web3.toHex(web3.toWei('20', 'gwei')),
            gasLimit: web3.toHex(100000),
            value: '0x00',
            to: token_address,
            data: callData
        };

        console.log(transactionObject.toString());

        var dec_privKey = decryptPrivKey(enc_privKey);
        const privateKeyBuff = Buffer.from(dec_privKey, 'hex');

        var transaction = new Tx(transactionObject);
        transaction.sign(privateKeyBuff);
        var serializedTx = transaction.serialize().toString('hex');

        console.log(serializedTx);
        //process.exit();
        var ErcTxnHash = web3.eth.sendRawTransaction('0x' + serializedTx.toString('hex'));
        nonce++;
        console.log(ErcTxnHash);
        process.exit();
        
        // var d = new Date().toISOString();

        // var query = "UPDATE TransactionDetail SET Hash = '" + ErcTxnHash + "', ModifiedDate = '" + d + "' WHERE JobId = " + jobId.jobid + " AND ProcessType = 'C';"
        // sql.close();
        // sql.connect(config, function (err) {
        //     if (err) {
        //         console.log("Error while connecting database :- " + err);
        //     }
        //     else {
        //         // create Request object
        //         var request = new sql.Request();
        //         console.log(query);
        //         // query to the database
        //         request.query(query, function (err, res) {
        //             if (err) {
        //                 console.log("Error while querying database :- " + err);
        //             }
        //             else {
        //                 console.log(res);
        //             }
        //         });
        //     }
        // });

    });
}

function loadContracts() {
    console.log("getting hashs")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) console.log(err);

            var query = "Select * from ContractDetail";
            var request = new sql.Request();
            request.query(query, function (err, rows) {
                if (err) {
                    return reject(err);
                }
                resolve(rows.recordset);
            });

        });
    });
}

BurnTokens();
