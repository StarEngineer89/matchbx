const Web3 = require('web3');
const sql = require('mssql');
const Tx = require('ethereumjs-tx');
const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
var PropertiesReader = require('properties-reader');
var request = require('request');

var properties = process.env.NODE_ENV === 'production' ? PropertiesReader('./properties.prod.env') : PropertiesReader('./properties.prod.env');

// const logger = winston.createLogger({
//     level: 'info',
//     format: winston.format.json(),
//     transports: [
//         new winston.transports.File({ filename: 'hash-gen-error.log', level: 'error' }),
//         new winston.transports.File({ filename: 'hash-gen.log' }),
//         new DailyRotateFile(
//             {
//                 filename: 'log-%DATE%.log',
//                 datePattern: 'YYYY-MM-DD-HH',
//                 zippedArchive: true,
//                 maxSize: '20m',
//                 maxFiles: '14d'
//             }
//         )]
// });


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

        getAllUserAddress().then(function (address) {
            var i = 0;
            function iterator() {
                if (i < address.length) {
                    var id = address[i].TransactionDetailId;
                    var account = address[i].Hash;
                    console.log(account);
                    tokenInstance.allowance.call(account, escrow_address, function (err, result) {
                        console.log(result);

                        if (result.c[0] > 0) {
                            console.log('approved: ' + result.c[0]);
                            updateApprovedToken(id,result.c[0],function(response){
                                i++;
                                iterator();
                            })
                        } else {
                            i++;
                            iterator();
                        }
                        
                    });

                } else {
                    console.log("Process iteration Completed");
                    //logger.info("Process iteration Completed");
                    process.exit();
                }                
            }
            iterator();
            console.log("Process Completed");
            //logger.info("Process Completed");
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

function getAllUserAddress() {
    console.log("getting user address");
    //logger.info("getting user address")
    return new Promise(function (resolve, reject) {

        sql.close();
        sql.connect(config, function (err) {

            if (err) logger.info(err);

            var query = "Select * from TransactionDetail Where ProcessType = 'A'";
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


function updateApprovedToken(id, amount, callback_setCstatus) {
    console.log("inside updateApprovedToken");
    //logger.info("inside updateApprovedToken");
    var d = new Date().toISOString();

    var query = "UPDATE TransactionDetail SET Amount = '" + amount + "', ModifiedDate = '" + d + "' WHERE TransactionDetailId = " + id + " ;"
    sql.close();
    sql.connect(config, function (err) {
        console.log("sql connect");
        if (err) {
            console.log("Error while connecting database :- " + err);
            //logger.info("Error while connecting database :- " + err);
        }
        else {
            // create Request object
            var request = new sql.Request();
            //logger.info(query);
            // query to the database
            request.query(query, function (err, res) {
                if (err) {
                    console.log(error.message);
                    logger.info(error.message);
                }
                else {
                    callback_setCstatus("done");
                }
            });
        }
    });
}

main();