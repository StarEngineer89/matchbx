const Web3 = require('web3');
const sql = require('mssql');
var PropertiesReader = require('properties-reader');
const abiDecoder = require('abi-decoder');
const https = require('https');
var request = require('request');

var properties = process.env.NODE_ENV === 'production' ? PropertiesReader('./properties.prod.env') : PropertiesReader('./properties.prod.env');

//var etherscanapi = require('etherscan-api').init(properties.get('etherscan_api'), 'ropsten', '3000');
var etherscan_url = properties.get('etherscan_url');
var etherscan_api = properties.get('etherscan_api');
console.log(properties.get('web3_provider'));
const web3 = new Web3(new Web3.providers.HttpProvider(properties.get('web3_provider')));

// config for your database
var config = {
    user: properties.get('dbuser'),
    password: properties.get('dbpassword'),
    server: properties.get('dbserver'),
    database: properties.get('database')
};


function main() {
    loadContracts().then(function (contracts) {
        //var args = process.argv.slice(2);

        //var account = args[0];

        var tokenAbi = JSON.parse(contracts[0].TokenABI);
        var token_address = contracts[0].TokenAddress;
        var tokenContract = web3.eth.contract(tokenAbi);
        var tokenInstance = tokenContract.at(token_address);

        var escrowAbi = JSON.parse(contracts[0].EscrowABI);
        var escrow_address = contracts[0].EscrowAddress;
        var escrowContract = web3.eth.contract(escrowAbi);
        var escrowInstance = escrowContract.at(escrow_address);

        var startblock = contracts[0].BlockNumberApproval;

        abiDecoder.addABI(escrowAbi);

        var api = 'api?module=account&action=txlist&address=' + token_address;
        var params = '&startblock=' + startblock + '&endblock=999999999&sort=desc';
        var apikey = '&apikey=' + etherscan_api;
        var url = etherscan_url + api + params + apikey;
        console.log(url);

        https.get(url, (resp) => {
            let data = '';

            resp.on('data', (chunk) => {
                data += chunk;
            });

            resp.on('end', () => {
                console.log(JSON.parse(data).result);
                var txlist = JSON.parse(data).result;
                updateBlockNumber(txlist[0].blockNumber).then(function () {
                    getAllPendingHashs().then(function (tx) {
                        var i = 0;
                        function iterator() {
                            if (i < tx.length) {
                                var jobid = tx[i].JobId;
                                var id = tx[i].TransactionDetailId;
                                var processType = tx[i].ProcessType;
                                var userId = tx[i].UserId;
                                var j = 0;
                                console.log('txId: '+id);
                                function hashFinder() {
                                    if (j < txlist.length) {
                                        if (txlist[j].to.toUpperCase() == token_address.toUpperCase()) {
                                            var decodedData = abiDecoder.decodeMethod(txlist[j].input);
                                            // console.log(txlist[j].input);
                                            // console.log(decodedData);
                                            if (typeof decodedData != 'undefined' && decodedData.hasOwnProperty('name')
                                                && decodedData.name == 'approve') {
                                                    console.log('inside approve');
                                                    console.log(jobid + ', '+txlist[j].from.toUpperCase() +':'+tx[i].Address.toUpperCase());
                                                    console.log(decodedData.params[0].value.toUpperCase() +':'+ escrow_address.toUpperCase());
                                                if (jobid == 0 && txlist[j].from.toUpperCase() == tx[i].Address.toUpperCase()
                                                    && decodedData.params[0].value.toUpperCase() == escrow_address.toUpperCase()) {
                                                    console.log(decodedData);
                                                    console.log(tx[i].Address);
                                                    console.log("approve value: " + decodedData.params[1].value);
                                                    if (processType == 'A') {
                                                        console.log('processType: A');
                                                        updateTxHash(id, txlist[j].hash).then(function (res) {
                                                            console.log('updateTxHash completed');
                                                            console.log('hash finder for ' + tx[i].Address + ' stopped');
                                                            i++;
                                                            iterator();
                                                        });
                                                    } else if (processType == 'R') {
                                                        console.log("processType R found");
                                                        console.log("value :"+decodedData.params[1].value);
                                                        if (decodedData.params[1].value == 0) {
                                                            var receipt = web3.eth.getTransactionReceipt(txlist[j].hash);
                                                            var status = parseInt(receipt.status);
                                                            if (receipt == null) {
                                                                i++;
                                                                iterator();
                                                            } else if (status == 1) {
                                                                console.log("transaction success");
                                                                updateResetTxHash(tx[i].Address).then(function (res) {
                                                                    console.log('updateTxHash completed');
                                                                    console.log('hash finder for ' + tx[i].Address + ' stopped');
                                                                    getMailData(userId).then(function (data) {
                                                                        sendMail(data).then(function (mail_res) {
                                                                            console.log("Email sent");
                                                                            i++;
                                                                            iterator();
                                                                        });
                                                                    });
                                                                });

                                                            }

                                                        }else{
                                                            i++;
                                                            iterator();
                                                        }
                                                    }
                                                } else {
                                                    j++;
                                                    hashFinder();
                                                }
                                            } else {
                                                j++;
                                                hashFinder();
                                            }
                                        } else {
                                            j++;
                                            hashFinder();
                                        }
                                    } else {
                                        console.log('hash finder for ' + tx[i].Address + ' iteration completed');
                                        i++;
                                        iterator();
                                    }

                                }
                                hashFinder();
                            } else {
                                process.exit();
                            }
                        }
                        iterator();
                        console.log("Process Completed");
                    });
                });

            }).on("error", (err) => {
                console.log("Error: " + err.message);
            });

        });





    });
}

function getAllPendingHashs() {
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err){
                // console.log(err);
            }else{
            var query = "Select * from TransactionDetail Where ProcessType IN ('A','R')  And IsApproved = 'N'";
            var request = new sql.Request();
            request.query(query, function (err, rows) {
                if (err) {
                    return reject(err);
                }
                resolve(rows.recordset);
            });
        }

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

function updateBlockNumber(lastBlock) {
    console.log("updateBlockNumber")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) console.log(err);
            console.log("updateBlockNumber")

            var query = "UPDATE ContractDetail SET BlockNumberApproval = " + lastBlock;
            console.log(query);
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

function updateTxHash(id, txhash) {
    console.log("updateTxHash")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err){}
            else{
                var d = new Date().toISOString();

            var query = "UPDATE TransactionDetail SET Hash = '" + txhash + "', ModifiedDate = '" + d + "' WHERE TransactionDetailId = " + id + ""
            var request = new sql.Request();
            console.log(query);

            request.query(query, function (err, rows) {
                if (err) {
                    return reject(err);
                }
                console.log(rows);
                resolve(rows.recordset);
            });
            } console.log(err);
            

        });
    });
}

function updateResetTxHash(address) {
    console.log("updateResetTxHash");
    return new Promise(function (resolve, reject) {
        var query = "EXEC spUpdateWalletReset '" + address +"'";

        sql.close();
        sql.connect(config, function (err) {

            if (err) {
                console.log(err);
            } else {
                // create Request object
                var request = new sql.Request();
                console.log(query);
                // query to the database
                request.query(query, function (error, res) {
                    if (error) {
                        console.log(error.message);
                        return reject(error);
                    }
                    resolve(res.recordset);
                });
            }

        });
    });

}

function getMailData(userId) {
    console.log("getMailData");
    return new Promise(function (resolve, reject) {
        var query = 'EXEC spUserMailInfo ' + userId;

        sql.close();
        sql.connect(config, function (err) {
            console.log("sql connect");
            if (err) {
                console.log("Error while connecting database :- " + err);
            }
            else {
                // create Request object
                var request = new sql.Request();
                console.log(query);
                // query to the database
                request.query(query, function (error, res) {
                    if (error) {
                        console.log(error.message);
                        return reject(error);
                    }
                    resolve(res.recordset);
                });
            }
        });
    });
}

function sendMail(data) {
    console.log("sendMail");
    console.log(data[0]);

    var mail = {
        'FullName': data[0].FullName,
        'Email': data[0].Email,
        'isInternal': false,
    };

    var options = {
        uri: 'https://matchbx.io/Mail/SendResetWalletConfirmationEmail',
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        json: mail
    };

    console.log(options);
    return new Promise(function (resolve, reject) {
        request(options, function (error, response, body) {
            console.log('response');
            console.log(response.statusCode);
            if (!error && response.statusCode == 200) {
                console.log("Mail sent for JobId: " + data[0].JobId);
                resolve(body);
                console.log(body);
            } else {
                console.log('error: ' + error);
            }
        });
    });

}



main();
