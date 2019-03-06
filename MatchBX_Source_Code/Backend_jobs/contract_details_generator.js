const sql = require('mssql');
const path = require('path');
const fs = require('fs');
var crypto = require('crypto');
var PropertiesReader = require('properties-reader');

var properties = process.env.NODE_ENV === 'production' ? PropertiesReader('./properties.prod.env') : PropertiesReader('./properties.prod.env');
const algorithm = properties.get('algorithm');
const password = properties.get('password');


// ======================== DB CONNECTION ===================================


var config = {
    user: properties.get('dbuser'),
    password: properties.get('dbpassword'),
    server: properties.get('dbserver'),
    database: properties.get('database')
};

// ======================== MAIN / START ===================================




function main() {

    //connect to your database
    sql.close();
    sql.connect(config, function (err) {

        if (err) console.log(err);

        var request = new sql.Request();
        request.query('select * from ContractDetail', function (err, recordset) {
            if (err) console.log(err)
            // send records as a response
            console.log(recordset.rowsAffected[0]);
            if (recordset.rowsAffected[0] > 0) {
                console.log("rowsAffected > 0");
                sql.close();
                sql.connect(config, function (err) {
                    if (err) {
                        console.log("Error while connecting database :- " + err);
                    }
                    else {
                        // create Request object
                        var request = new sql.Request();
                        var query = "DELETE FROM ContractDetail ;";
                        console.log(query);
                        // query to the database
                        request.query(query, function (err, res) {
                            if (err) {
                                console.log("Error while querying database :- " + err);
                            }
                            else {
                                console.log(res);
                                insertAbiDetails();
                            }
                        });
                    }
                });

            } else {
                insertAbiDetails();
            }


        });

    });    //logger.info("Getting tge_id #Process2");


}

function insertAbiDetails() {
    var args = process.argv.slice(2);
    var token_addr = args[2];
    var escrow_addr = args[3];
    var owner_addr = args[0];
    var private_key = args[1];
    var token_abi_filename = args[6];
    var escrow_abi_filename = args[7];
    var fee_addr = args[4];
    var token_amt = args[5];

    var cipher = crypto.createCipher(algorithm, password);
    var crypted = cipher.update(private_key, 'utf8', 'hex');
    var enc_privateKey = crypted;
    enc_privateKey += cipher.final('hex');


    const tokenAbiPath = path.resolve(__dirname, 'abi', token_abi_filename);
    const tokenAbi = fs.readFileSync(tokenAbiPath, 'utf-8');    


    const escrowAbiPath = path.resolve(__dirname, 'abi', escrow_abi_filename);
    const escrowAbi = fs.readFileSync(escrowAbiPath, 'utf-8');    

    console.log("insertAbiDetails");
    var query = 'INSERT INTO ContractDetail VALUES (@token_addr,@escrow_addr,@tokenAbi,@escrowAbi,@owner_addr,@enc_privateKey,@fee_addr,@token_amt) ';

    sql.close();
    sql.connect(config, function (err) {
        if (err) {
            console.log("Error while connecting database :- " + err);
        }
        else {
            // create Request object
            var request = new sql.Request();
            console.log(query);
            request.input("token_addr", token_addr);
            request.input("escrow_addr", escrow_addr);
            request.input("tokenAbi", tokenAbi);
            request.input("escrowAbi", escrowAbi);
            request.input("owner_addr", owner_addr);
            request.input("enc_privateKey", enc_privateKey);
            request.input("fee_addr",fee_addr);
	    request.input("token_amt",token_amt);
            // query to the database
            request.query(query, function (error, res) {
                if (error) {
                    console.log(error.message);
                    process.exit(0);
                }
                else {
                    console.log(res);
                    process.exit(0);
                }
            });
        }
    });
}

main();

