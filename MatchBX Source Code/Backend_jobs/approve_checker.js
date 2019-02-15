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
        var args = process.argv.slice(2);

        var account = args[0];

        var tokenAbi = JSON.parse(contracts[0].TokenABI);
        var token_address = contracts[0].TokenAddress;
        var tokenContract = web3.eth.contract(tokenAbi);
        var tokenInstance = tokenContract.at(token_address);

        var escrowAbi = JSON.parse(contracts[0].EscrowABI);
        var escrow_address = contracts[0].EscrowAddress;
        var escrowContract = web3.eth.contract(escrowAbi);
        var escrowInstance = escrowContract.at(escrow_address);

        tokenInstance.allowance.call(account, escrow_address, function (err, result) {
            console.log(result.toNumber());

            if (result.toNumber() > 15000 *  Math.pow(10, 18)) {
                console.log('approved: ' + result.toNumber());
                
            } 
	    process.exit(0);
            
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
