const Web3 = require('web3');
const sql = require('mssql');
const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
var PropertiesReader = require('properties-reader');

var properties = process.env.NODE_ENV === 'production' ? PropertiesReader('./properties.prod.env') : PropertiesReader('./properties.prod.env');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.File({ filename: 'log/approval-log/apprv-error.log', level: 'error' }),
        new winston.transports.File({ filename: 'log/approval-log/apprv-val.log' }),
        new DailyRotateFile(
            {
                filename: 'log/approval-log/apprv-log-%DATE%.log',
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
        var tokenAbi = JSON.parse(contracts[0].TokenABI);
        var token_address = contracts[0].TokenAddress;
        var tokenContract = web3.eth.contract(tokenAbi);
        var tokenInstance = tokenContract.at(token_address);
        var escrow_address = contracts[0].EscrowAddress;

        getAllPendingHashs().then(function (hash_list) {
            var i = 0;
            function iterator() {
                if (i < hash_list.length) {
                    console.log(hash_list[i]);
                    var id = hash_list[i].TransactionDetailId;                   

                    if (hash_list[i].Hash == '') {
                        var address = hash_list[i].Address;
                        console.log(address);
                        var res = tokenInstance.allowance.call(address, escrow_address);
                        console.log(res.c[0] > 0);
                        if (res.c[0] > 0) {
                            setApproveStatus(id, res.c[0], function (response) {
                                logger.info("Completed Entry created")
                                i++;
                                iterator();
                            });
                        } else {
                            i++;
                            iterator();
                        }

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
    logger.info("getting hashs")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) logger.info(err);

            var query = "Select * from TransactionDetail Where IsApproved = 'N' AND ProcessType = 'A' ";
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

function setApproveStatus(id, amount, callback_setCstatus) {
    console.log("inside approved");
    logger.info("inside approved");
    var d = new Date().toISOString();

    var query = "UPDATE TransactionDetail SET IsApproved = 'Y', Amount = '" + amount + "', ModifiedDate = '" + d + "' WHERE TransactionDetailId = " + id + " ;"
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
                    logger.info(error.message);
                }
                else {
                    callback_setCstatus("done");
                }
            });
        }
    });
}

function setFailedStatus(jobid, callback_setCstatus) {
    logger.info("inside fail");
    console.log("inside fail");
    var d = new Date().toISOString();

    var query = "DELETE FROM TransactionDetail WHERE JobId = " + jobid + " AND ProcessType = 'A' ;"

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
                    logger.info(error.message);
                }
                else {
                    callback_setCstatus("done");
                }
            });
        }
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
