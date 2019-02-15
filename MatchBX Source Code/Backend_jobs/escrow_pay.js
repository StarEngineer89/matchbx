const Web3 = require('web3');
const crypto = require('crypto');
const sql = require('mssql');
const Tx = require('ethereumjs-tx');
const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
var PropertiesReader = require('properties-reader');

var properties = process.env.NODE_ENV === 'production' ? PropertiesReader('./properties.prod.env') : PropertiesReader('./properties.prod.env');
const algorithm = properties.get('algorithm');
const password = properties.get('password');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.File({ filename: 'log/escrow-pay/escrow-token-error.log', level: 'error' }),
        new winston.transports.File({ filename: 'log/escrow-pay/escrow-token.log' }),
        new DailyRotateFile(
            {
                filename: 'log/escrow-pay/escrow-token-%DATE%.log',
                datePattern: 'YYYY-MM-DD-HH',
                zippedArchive: true,
                maxSize: '20m',
                maxFiles: '14d'
            }
        )]
});

var nonce = -2;

console.log(properties.get('web3_provider'));
const web3 = new Web3(new Web3.providers.HttpProvider(properties.get('web3_provider')));
// config for your database
var config = {
    user: properties.get('dbuser'),
    password: properties.get('dbpassword'),
    server: properties.get('dbserver'),
    database: properties.get('database')
};

var tokenAbi;
var token_address;
var tokenContract;
var tokenInstance;

var escrowAbi;
var escrow_address;
var escrowContract;
var escrowInstance;

var admin_address;
var enc_privKey;

function main() {
    loadContracts().then(function (contracts) {

        enc_privKey = contracts[0].PrivateKeyHash;
        admin_address = contracts[0].OwnerAddress;

        tokenAbi = JSON.parse(contracts[0].TokenABI);
        token_address = contracts[0].TokenAddress;
        tokenContract = web3.eth.contract(tokenAbi);
        tokenInstance = tokenContract.at(token_address);

        escrowAbi = JSON.parse(contracts[0].EscrowABI);
        escrow_address = contracts[0].EscrowAddress;
        escrowContract = web3.eth.contract(escrowAbi);
        escrowInstance = escrowContract.at(escrow_address);

        getAllPendingHashs().then(function (hash_list) {
            var i = 0;
            console.log("length: "+hash_list.length);
            function iterator() {
                if (i < hash_list.length) {

                    var trans_id = hash_list[i].TransactionDetailId;
                    var jobid = hash_list[i].JobId;
                    var userid = hash_list[i].UserId;
                    var process_type = hash_list[i].ProcessType;
                    var trans_type = hash_list[i].TransactionType;
                    console.log("p: "+process_type+" t: "+trans_type);
                    if (process_type == 'S' && 
                            (hash_list[i].Hash != null || hash_list[i].Hash.length > 0)) {
                        var address = hash_list[i].Hash;
                        RewardTokens(trans_id, address,function (res) {
                            console.log(res);
                            logger.info(res)
                            i++;
                            iterator();
                        });
                    }
                    else if (process_type == 'C' && trans_type == 'S') {
                        console.log("process_type == 'C' && trans_type == 'S'");
                        TransferToken(jobid, function (res) {
                            console.log(res);
                            logger.info(res)
                            i++;
                            iterator();
                        });
                    } else {
                        i++;
                        iterator();
                    }

                }
                else {
                    console.log("Process iteration Completed");
                    logger.info("Process iteration Completed");
                    process.exit();
                }
            }
            iterator();
            console.log("Process Completed");
            logger.info("Process Completed");
        });
    });
}


// ============ utility funcs ============================

function getAllPendingHashs() {
    logger.info("getting hashs");
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) logger.info(err);

            var query = "Select * from TransactionDetail Where IsApproved = 'N'";
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

function decryptPrivKey(text) {
    console.log("inside decryptPrivKey");
    console.log(text);

    var decipher = crypto.createDecipher(algorithm, password);
    var dec = decipher.update(text, 'hex', 'utf8');
    dec += decipher.final('utf8');
    return dec;
}

function sleep(seconds){
    var waitUntil = new Date().getTime() + seconds*1000;
    while(new Date().getTime() < waitUntil) true;
}

function TransferToken(jobid, callback) {

    console.log("TransferToken");

    console.log(jobid);

    var callData = escrowInstance.pay.getData(jobid);

    if(nonce == -2)
    {
    nonce = web3.eth.getTransactionCount(admin_address);
    }
    console.log(nonce);

    var transactionObject = {
        nonce: web3.toHex(nonce),
        from: admin_address,
        gasPrice: web3.toHex(web3.toWei('20', 'gwei')),
        gasLimit: web3.toHex(100000),
        value: '0x00',
        to: escrow_address,
        data: callData
    };

    console.log(transactionObject.toString());

    var dec_privKey = decryptPrivKey(enc_privKey);
    const privateKeyBuff = Buffer.from(dec_privKey, 'hex');

    var transaction = new Tx(transactionObject);
    transaction.sign(privateKeyBuff);
    var serializedTx = transaction.serialize().toString('hex');

    console.log(serializedTx);
    logger.info(serializedTx);
    //process.exit();
    var ErcTxnHash = web3.eth.sendRawTransaction('0x' + serializedTx.toString('hex'));
    nonce++;
    sleep(20);
    console.log(ErcTxnHash);
    logger.info(ErcTxnHash);

    var d = new Date().toISOString();

    var query = "UPDATE TransactionDetail SET Hash = '" + ErcTxnHash + "', ModifiedDate = '" + d + "', IsApproved = 'Y' WHERE JobId = " + jobid + " AND ProcessType = 'C';"
    sql.close();
    sql.connect(config, function (err) {
        if (err) {
            logger.info("Error while connecting database :- " + err);
            console.log("Error while connecting database :- " + err);
            callback('error');
        }
        else {
            // create Request object
            var request = new sql.Request();
            console.log(query);
            // query to the database
            request.query(query, function (err, res) {
                if (err) {
                    console.log("Error while querying database :- " + err);
                    callback('error');
                }
                else {
                    console.log(res);
                    callback('success');
                }
            });
        }
    });
}

function RewardTokens(transactionId, addr, callback) {

    console.log("RewardTokens");
    var instance = tokenContract.at(token_address);
    var tokenAmt = 5000;
    console.log(addr);
    var callData = instance.transfer.getData(addr, tokenAmt);

    if(nonce == -2)
    {
        nonce = web3.eth.getTransactionCount(admin_address);
    }


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


    var dec_privKey = decryptPrivKey(enc_privKey);
    const privateKeyBuff = Buffer.from(dec_privKey, 'hex');

    var transaction = new Tx(transactionObject);
    transaction.sign(privateKeyBuff);
    var serializedTx = transaction.serialize().toString('hex');

    console.log(serializedTx);
    var ErcTxnHash = web3.eth.sendRawTransaction('0x' + serializedTx.toString('hex'));
    nonce++;
    sleep(20);

    console.log(ErcTxnHash);

    var d = new Date().toISOString();

    var query = "UPDATE TransactionDetail SET Hash = '" + ErcTxnHash + "', ModifiedDate = '" + d + "', IsApproved = 'Y' WHERE TransactionDetailId = " + transactionId + " ;"
    sql.close();
    sql.connect(config, function (err) {
        if (err) {
            console.log("Error while connecting database :- " + err);
            callback('error');
        }
        else {
            // create Request object
            var request = new sql.Request();
            console.log(query);
            // query to the database
            request.query(query, function (err, res) {
                if (err) {
                    console.log("Error while querying database :- " + err);
                    callback('error');
                }
                else {
                    console.log(res);
                    callback('success');
                }
            });
        }
    });    

}

main();
