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

function main() {

    loadContracts().then(function (contracts) {

        var args = process.argv.slice(2);
        var addr = args[0];
        var tokenAmt = args[1];

        var abi = JSON.parse(contracts[0].TokenABI);
        //console.log(JSON.parse(contracts[0].TokenABI).abi);
        var admin_address = contracts[0].OwnerAddress;
        var enc_privKey = contracts[0].PrivateKeyHash;
        var contract_address = contracts[0].TokenAddress;

        //var abi = contracts.TokenABI;
        var contract = web3.eth.contract(abi);
        var instance = contract.at(contract_address);
        console.log(addr);
        var callData = instance.transfer.getData(addr, tokenAmt);

        nonce = web3.eth.getTransactionCount(admin_address);

        console.log(nonce);

        var transactionObject = {
            nonce: web3.toHex(nonce),
            from: admin_address,
            gasPrice: web3.toHex(web3.toWei('20', 'gwei')),
            gasLimit: web3.toHex(100000),
            value: '0x00',
            to: contract_address,
            data: callData
        };


        var dec_privKey = decryptPrivKey(enc_privKey);
        const privateKeyBuff = Buffer.from(dec_privKey, 'hex');

        var transaction = new Tx(transactionObject);
        transaction.sign(privateKeyBuff);
        var serializedTx = transaction.serialize().toString('hex');

        console.log(serializedTx);
        var ErcTxnHash = web3.eth.sendRawTransaction('0x' + serializedTx.toString('hex'));
        nonce++;
        console.log(ErcTxnHash);

        process.exit(0);

        // var d = new Date().toISOString();

        // var query = 'INSERT INTO TransactionDetail VALUES (@user_id,@job_id,@txhash,@token_amt,@trans_type,@process_type,@status,@create_date,@modified_Date) ';

        // sql.close();
        // sql.connect(config, function (err) {
        //     if (err) {
        //         console.log("Error while connecting database :- " + err);
        //     }
        //     else {
        //         // create Request object
        //         var request = new sql.Request();
        //         console.log(query);
        //         request.input("user_id", userid);
        //         request.input("job_id", jobid);
        //         request.input("txhash", ErcTxnHash);
        //         request.input("token_amt", tokenAmt / 1000);
        //         request.input("trans_type", 'E');
        //         request.input("process_type", 'S');
        //         request.input("status", 'N');
        //         request.input("create_date", d);
        //         request.input("modified_Date", d);
        //         // query to the database
        //         request.query(query, function (err, res) {
        //             if (err) {
        //                 console.log(error.message);
        //             }
        //             else {
        //                 console.log(res);
        //                 //callback_setCstatus("done");
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

main();