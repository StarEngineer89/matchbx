const Web3 = require('web3');
const sql = require('mssql');
const Tx = require('ethereumjs-tx');
const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
var PropertiesReader = require('properties-reader');
var request = require('request');

var properties = process.env.NODE_ENV === 'production' ? PropertiesReader('./properties.prod.env') : PropertiesReader('./properties.prod.env');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.File({ filename: 'log/tx-validator/hash-gen-error.log', level: 'error' }),
        new winston.transports.File({ filename: 'log/tx-validator/hash-gen.log' }),
        new DailyRotateFile(
            {
                filename: 'log/tx-validator/log-%DATE%.log',
                datePattern: 'YYYY-MM-DD-HH',
                zippedArchive: true,
                maxSize: '20m',
                maxFiles: '14d'
            }
        )]
});


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

        var escrowAbi = JSON.parse(contracts[0].EscrowABI);
        var escrow_address = contracts[0].EscrowAddress;
        var escrowContract = web3.eth.contract(escrowAbi);
        var escrowInstance = escrowContract.at(escrow_address);

        getAllPendingHashs().then(function (job_list) {
            console.log('job_list: ' + job_list.length);
            var j = 0;
            function jobIterator() {
                if (j < job_list.length) {
                    var id = job_list[j].TransactionDetailId;
                    var jobid = job_list[j].JobId;
                    var process_type = job_list[j].ProcessType;
                    if (process_type == 'A' || process_type == 'C') {
                        console.log('approval');
                        logger.info('approval');
                        console.log('jobid: ' + jobid + ' for ' + process_type + ' found');
                        if (job_list[j].Hash != '') {

                            var txnHash = job_list[j].Hash;
                            console.log(txnHash);
                            logger.info(txnHash);
                            var receipt = web3.eth.getTransactionReceipt(txnHash);
                            var status = parseInt(receipt.status);

                            if (receipt == null) {
                                j++;
                                jobIterator();
                            } else if (status == 0) {
                                setFailedStatus(id, function (response) {
                                    logger.info("Falied Entry created for approval");
                                    updateFailedTx(jobid, txnHash).then(function () {
                                        j++;
                                        jobIterator();
                                    });

                                });
                            } else if (status == 1) {
                                console.log("Completed Entry creating for approval");
                                setCompletedStatus(id, function (response) {
                                    console.log("Completed Entry created for approval");
                                    logger.info("Completed Entry created for approval");
                                    j++;
                                    jobIterator();
                                });
                            }

                        } else {
                            j++;
                            jobIterator();
                        }
                    } else {
                        getJobHashs(job_list[j].JobId).then(function (hash_list) {
                            console.log('hash_list: ' + hash_list.length);
                            var i = 0;
                            function iterator() {
                                if (i < hash_list.length) {
                                    var id = hash_list[i].JobTransactionHashLogId;
                                    var jobid = hash_list[i].JobId;
                                    if (hash_list[i].Hash != '') {

                                        var txnHash = hash_list[i].Hash;
                                        console.log(txnHash);
                                        logger.info(txnHash);
                                        var receipt = web3.eth.getTransactionReceipt(txnHash);
                                        var status = parseInt(receipt.status);

                                        if (receipt == null) {
                                            i++;
                                            iterator();
                                        } else if (status == 0) {
                                            setFailedStatus(id, function (response) {
                                                logger.info("Falied Entry created ");                                                
                                                i++;
                                                iterator();
                                            });
                                        } else if (status == 1) {
                                            UpdateSuccessTransaction(jobid, txnHash).then(function () {
                                                logger.info("Completed Entry created ");
                                                console.log("Completed Entry created");
                                                getMailData(jobid).then(function (data) {
                                                    sendMail(data).then(function (mail_res) {
                                                        logger.info("Email sent");
                                                        j++;
                                                        jobIterator();
                                                    });
                                                });
                                            });
                                        }

                                    } else {
                                        i++;
                                        iterator();
                                    }
                                }
                                else {
                                    if(hash_list.length > 0){
                                        updateFailedTx(jobid, hash_list[i-1].Hash).then(function () {
                                            logger.info("updateFailedTx ");
                                            j++;
                                            jobIterator();
                                        });
                                    }else{
                                        j++;
                                            jobIterator();
                                    }
                                }
                            }
                            iterator();
                        });
                    }
                } else {
                    console.log("iteration Completed");
                    logger.info("iteration Completed");
                    process.exit();
                }
            }
            jobIterator();
            console.log("Process Completed");
            logger.info("Process Completed");
        });


    });
}


// ============ utility funcs ============================

function getAllPendingHashs() {
    logger.info("getting hashs")
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

function getJobHashs(jobId) {
    console.log('getJobHashs: ' + jobId);
    logger.info("getting job hashs")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) logger.info(err);
            var query = "Select * from JobTransactionHashLog Where JobId = " + jobId + " AND Status = 'N'";
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

function setCompletedStatus(id, callback_setCstatus) {
    logger.info("inside completed");
    console.log("inside completed");
    var d = new Date().toISOString();

    var query = "UPDATE TransactionDetail SET IsApproved = 'Y', ModifiedDate = '" + d + "' WHERE TransactionDetailId = " + id + " ;"

    console.log(query);
    sql.close();
    sql.connect(config, function (err) {
        console.log("sql connect");
        if (err) {
            logger.info("Error while connecting database :- " + err);
        }
        else {
            // create Request object
            var request = new sql.Request();
            logger.info(query);
            // query to the database
            request.query(query, function (err, res) {
                if (err) {
                    logger.info(err.message);
                }
                else {
                    callback_setCstatus("done");
                }
            });
        }
    });
}

function updateFailedTx(jobId, txnHash) {
    logger.info("updateFailedTx")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) logger.info(err);

            var query = 'EXEC spUpdateFailedTransaction ' + jobId + ',' + txnHash;
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

function setFailedStatus(id, callback_setCstatus) {
    logger.info("inside fail");
    console.log("inside fail");
    var d = new Date().toISOString();

    var query = "UPDATE JobTransactionHashLog SET Status = 'F'  WHERE JobTransactionHashLogId = " + id + " ;";

    sql.close();
    sql.connect(config, function (err) {
        console.log("sql connect");
        if (err) {
            logger.info("Error while connecting database :- " + err);
        }
        else {
            // create Request object
            var request = new sql.Request();
            logger.info(query);
            // query to the database
            request.query(query, function (err, res) {
                if (err) {
                    logger.info(err.message);
                }
                else {
                    callback_setCstatus("done");
                }
            });
        }
    });
}

function getMailData(jobId) {
    logger.info("getMailData");
    console.log("getMailData");
    return new Promise(function (resolve, reject) {
        var query = 'EXEC spGetMailInfo ' + jobId;

        sql.close();
        sql.connect(config, function (err) {
            console.log("sql connect");
            if (err) {
                logger.info("Error while connecting database :- " + err);
                console.log("Error while connecting database :- " + err);
            }
            else {
                // create Request object
                var request = new sql.Request();
                logger.info(query);
                console.log(query);
                // query to the database
                request.query(query, function (error, res) {
                    if (error) {
                        logger.info(error.message);
                        return reject(error);
                    }
                    resolve(res.recordset);
                });
            }
        });
    });
}

function sendMail(data) {
    logger.info("sendMail");
    console.log("sendMail");
    console.log(data[0]);

    var mail = {
        'FullName': data[0].FullName,
        'UserName': data[0].UserName,
        'JobTitle': data[0].JobTitle,
        'JobId': data[0].JobId,
        'Email': data[0].Email,
        'BidAmount': data[0].BidAmount,
        'isInternal': false,
    };

    var options = {
        uri: 'https://matchbx.io/Mail/SendBidAcceptEmail',
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
                logger.info("Mail sent for JobId: " + data[0].JobId);
                resolve(body);
                console.log(body);
            } else {
                console.log('error: ' + error);
            }
        });
    });

}

function UpdateSuccessTransaction(jobId, txnHash) {
    console.log("UpdateSuccessTransaction");
    logger.info("UpdateSuccessTransaction")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) logger.info(err);

            var query = "EXEC spUpdateSuccessTransaction " + jobId + ",'" + txnHash + "'";
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
