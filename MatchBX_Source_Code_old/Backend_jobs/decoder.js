const Web3 = require('web3');
const sql = require('mssql');
var PropertiesReader = require('properties-reader');
const abiDecoder = require('abi-decoder');
const https = require('https');

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

        var startblock = contracts[0].BlockNumberDeposit;

        abiDecoder.addABI(escrowAbi);

        var api = 'api?module=account&action=txlist&address=' + escrow_address;
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
                //console.log(JSON.parse(data).result);
                var txlist = JSON.parse(data).result;
                updateBlockNumber(txlist[txlist.length - 1].blockNumber).then(function () {
                    getAllPendingHashs().then(function (tx) {
                        var i = 0;
                        function iterator() {
                            if (i < tx.length) {
                                var jobid = tx[i].JobId;
                                var timestamp = tx[i].CreatedDate;
                                var j = 0;
                                console.log('jobid ' + jobid);
                                function hashFinder() {
                                    if (j < txlist.length) {
                                        var decodedData = abiDecoder.decodeMethod(txlist[j].input);
                                        if (typeof decodedData != 'undefined' && decodedData.hasOwnProperty('name')
                                            && decodedData.name == 'deposit' && jobid == decodedData.params[0].value) {
                                            console.log('found deposit for job ' + decodedData.params[0].name + " " + decodedData.params[0].value);
                                            console.log(' on ' + txlist[j].hash);
                                            updateTxHash(jobid, txlist[j].hash).then(function (res) {
                                                console.log('updateTxHash completed');
                                                console.log('hash finder for ' + jobid + ' stopped');
                                                j++;
                                                hashFinder();
                                            });

                                        } else {
                                            j++;
                                            hashFinder();
                                        }


                                    } else {
                                        console.log('hash finder for ' + jobid + ' iteration completed');
                                        var ts = Math.round(new Date(timestamp).getTime() / 1000)
                                        var now = Math.round(new Date().getTime() / 1000);
                                        console.log(timestamp + ' :' + ts);
                                        console.log('now ' + now);

                                        timeDifference(now, ts, function (days) {
                                            console.log(days);
                                            if (days > 1) {
                                                console.log('24 hours exceed');
                                                updateCancelledTx(jobid).then(function () {
                                                    i++;
                                                    iterator();
                                                });
                                            } else {
                                                i++;
                                                iterator();
                                            }
                                        });

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

            if (err) console.log(err);

            var query = "Select * from TransactionDetail Where ProcessType = 'D' And IsApproved = 'N'";
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

function updateBlockNumber(lastBlock) {
    console.log("updateBlockNumber")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) console.log(err);

            var query = "UPDATE ContractDetail SET BlockNumberDeposit = " + lastBlock;
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

function updateTxHash(jobId, txhash) {
    console.log("updateTxHash");
    //logger.info("updateTxHash")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) console.log(err);
            var d = new Date().toISOString();

            var query = "EXEC spAddEditJobTransactionHashLog 0," + jobId + ",'" + txhash + "'," + "'N'";
            var request = new sql.Request();
            console.log(query);

            request.query(query, function (err, rows) {
                if (err) {
                    return reject(err);
                }
                console.log(rows);
                resolve(rows.recordset);
            });

        });
    });
}

function updateCancelledTx(jobId) {
    console.log("updateCancelledTx");
    //logger.info("updateCancelledTx")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) console.log(err);

            var query = 'EXEC spUpdateCancelledTransaction ' + jobId;
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

function timeDifference(date1, date2, callback) {
    var difference = date1 - date2;

    var days = difference / (24 * 60 * 60);
    callback(days);
}

main();