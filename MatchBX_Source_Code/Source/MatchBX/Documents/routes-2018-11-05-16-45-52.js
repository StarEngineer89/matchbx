var Request = require("request");
var crypto = require("crypto");
var Config = require('./config');
const mysql = require("mysql");

// ======================== DB CONNECTION ===================================


var con = mysql.createConnection({
  host: Config.DB.host,
  user: Config.DB.uname,
  password: Config.DB.pwd,
  database: Config.DB.database
});

con.connect(function(err) {
        if (err) {
            console.log(err);
        }
        else{
            console.log("Connected to Database!");
        }
});


// var FormData = require('form-data');
global.checkStack = [];

// var con = mysql.createConnection({
//   host: "uatdb2.cep1ynrf7zju.eu-west-2.rds.amazonaws.com",
//   user: "bcwdb",
//   password: "LSGbcw2018",
//   database: "tge"
// });

// con.connect(function(err) {
//   if (err) {
//       console.log(err);
//   }
//   else{
//       console.log("Connected to Database!");
//   }
// });

global.documentCheckStatus = ''; 
global.facialSimilarityCheckStatus = ''; 
global.watchlistCheckStatus = '';
var appRouter = function (app) {
  app.get("/", function (req, res) {
    res.send("Hello World port");
  });

  app.post("/", function (req, res) {
    try {
      if (!req.body) throw 'Invalid payload';
      var payload = JSON.stringify(req.body);
      console.log(payload);
      if (!req.headers['x-signature']) throw 'No signature in header';
      var xsign = req.headers['x-signature'];
      // console.log(xsign);
      var token = Config.onfido.webhook_token;

      hmac = crypto.createHmac("sha1", token);
      hmac.update(payload);
      hash = hmac.digest("hex");
      // console.log(hash);

      var data = JSON.parse(payload);
      var load = data.payload;

      if (xsign == hash && load.resource_type != 'report') {
        // console.log(load.object.status);
        var status = '';
        switch (load.object.status) {
          case 'complete': status = 'S'; break;
          case 'withdrawn': status = 'F'; break;
          case 'cancelled': status = 'F'; break;
          default: status = 'P';
        }
        //status = 'M';
        var kycCheckObject = {
          kycCheckId: load.object.id,
          ReportIds: {
            documentReportId: '',
            facialSimilarityReportId: '',
            watchlistReportId: ''
          }
        }
        if (checkStack.indexOf(load.object.id) <= -1) {
          console.log('CheckID Stack before: ' + checkStack);
          checkStack.push(load.object.id);
          console.log('CheckID Stack after: ' + checkStack);
          if (status == 'S') {
            RetrieveReportIds(load.object.id, function (response) {
              console.log('Got the reports ids');
              try {
                if (response == null) throw 'No reports retrieved'
                if (response != null) {
                  for(var i = 0; i < response.length; i++) {
                    if(response[i].name == 'watchlist') {
                      kycCheckObject.ReportIds.watchlistReportId = response[i].id;
                    } else if (response[i].name == 'facial_similarity') {
                      kycCheckObject.ReportIds.facialSimilarityReportId = response[i].id;
                    } else if(response[i].name == 'document'){
                      kycCheckObject.ReportIds.documentReportId = response[i].id;
                    }
                  }

                  // kycCheckObject.ReportIds.documentReportId = response[0].documentReportId;
                  // kycCheckObject.ReportIds.facialSimilarityReportId = response[0].facialSimilarityReportId;
                  // kycCheckObject.ReportIds.watchlistReportId = response[0].watchlistReportId;

                  CheckAllReports(kycCheckObject, function (kycReportStatus) {
                    console.log('Overall status: ' + kycReportStatus);
                    if (kycReportStatus != 'P') {
                      updateKYCStatus(load.object.id, kycReportStatus, function (updateStatus){
                        if (updateStatus != null) {
                          console.log(updateStatus.data.length);
                          if(updateStatus.data.length == 0) {
                            console.log('Retrying update');
                            RetryUpdateKYCStatus(load.object.id, kycReportStatus);
                          } else {
                            console.log('Update Status - Done');
                          }
                        }
                      });
                    }
                  });
                }
              } catch (err) {
                console.log('RetrieveReportIds: ' + err);
              }
            });
          } else if (status == 'F') {
            console.log('check ' + load.object.status);
            updateKYCStatus(load.object.id, 'F', function (updateStatus){
              if (updateStatus != null) {
                console.log(updateStatus.data);
                console.log('Update Status - Done');
              }
            });

          }
        } else {
          console.log('CheckID '+ load.object.id + ' exists: ' + checkStack);
          checkStack.pop(load.object.id);
        }

        res.json({ message: "SUCCESS" });
      } else if (load.resource_type == 'report') {
        res.json({ message: "SUCCESS" });
      } else {
        console.log("FAILED");
        res.json({ message: "FAILED" });
      }
    } catch (err) {
      console.log('Webhook: ' + err);
    }
  });

  app.get("/account", function (req, res) {
    var accountMock = {
      username: "nraboy",
      password: "1234",
      twitter: "@nraboy"
    };
    if (!req.query.username) {
      return res.send({ status: "error", message: "missing username" });
    } else if (req.query.username != accountMock.username) {
      return res.send({ status: "error", message: "wrong username" });
    } else {
      return res.send(accountMock);
    }
  });

  app.post("/account", function (req, res) {
    if (!req.body.username || !req.body.password || !req.body.twitter) {
      return res.send({ status: "error", message: "missing a parameter" });
    } else {
      return res.send(req.body);
    }
  });

  app.post("/createApplicant", function (req, res) {
    if (
      req.body.title &&
      req.body.first_name &&
      req.body.last_name &&
      req.body.email &&
      req.body.dob &&
      req.body.gender &&
      req.body.country
    ) {
      Request.post(
        {
          headers: {
            "content-type": "application/json",
            Authorization: Config.onfido.key
          },
          url: "https://api.onfido.com/v2/applicants",
          body: JSON.stringify({
            title: req.body.title,
            first_name: req.body.first_name,
            last_name: req.body.last_name,
            email: req.body.email,
            dob: req.body.dob,
            gender: req.body.gender,
            country: req.body.country,
            nationality: req.body.country
          })
        },
        (error, response, body) => {
          if (error) {
            console.log('createApplicant: ' + error);
            return res.send(error);
          }
          return res.send(body);
        }
      );
    }
  });

  app.post("/getToken", function (req, res) {
    if (req.body.applicant_id) {
      Request.post(
        {
          headers: {
            "content-type": "application/json",
            Authorization: Config.onfido.key
          },
          url: "https://api.onfido.com/v2/sdk_token",
          body: JSON.stringify({
            applicant_id: req.body.applicant_id,
            referrer: "*://coinbx.blockchainwarehouse.com/*"
          })
        },
        (error, response, body) => {
          if (error) {
            console.log('getToken: ' + error);
            return res.send(error);
          }
          return res.send(body);
        }
      );
    }
  });

  app.post("/createCheck", function (req, res) {
    var url = "https://api.onfido.com/v2/applicants/APPLICANT_ID/checks";
    console.log(req.body.applicant_id);
    if (req.body.applicant_id) {
      url = url.replace("APPLICANT_ID", req.body.applicant_id);
      Request.post(
        {
          headers: {
            "content-type": "application/x-www-form-urlencoded",
            "Authorization": Config.onfido.key
          },
          url: url,
          formData: { 
            'type': 'express',
            'reports[][name]': ['document', 'facial_similarity', 'watchlist'],
            'reports[][variant]': 'full' 
          }
        },
        (error, response, body) => {
          if (error) {
            console.log('createCheck: ' + error);
            return res.send(error);
          }
          // console.log(body);
          return res.send(body);
        }
      );
    }
  });

  app.post("/currentRate", function (req, res) {
    var url = "https://api.coinmarketcap.com/v2/ticker/?limit=";
    if (req.body.limit) {
      url += req.body.limit;
      Request.get(
        {
          url: url
        },
        (error, response, body) => {
          if (error) {
            console.log('currentRate: ' + error);
            return res.send(error);
          }
          var data = JSON.parse(body).data;
          var arr = [];
          for (var prop in data) {
            if (data[prop].symbol == 'BCH' || data[prop].symbol == 'BTC' || data[prop].symbol == 'ETH') {
              var result = new Object();
              result.name = data[prop].name;
              result.symbol = data[prop].symbol;
              result.price = data[prop].quotes.USD.price;
              arr.push(result);
            }
          }

          return res.send(JSON.stringify(arr));
        })
    }
  });

  app.post("/getAPIKey", function (req, res) {
    var id = req.body.id;
    if (req.body.id) {
      return res.send(Config.TGE_ID[req.body.id]);
    } else {
      res.send("Failed");
    }
  });

  app.post("/getTokenSaleData", function (req, res) {
    var tge_id = req.body.tge_id;
    if (tge_id) {
      getTokenSaleStatistics(tge_id, function (saleData) {
        return res.send(saleData);
      });
      //return res.send(Config.TGE_ID[req.body.id]);
    } else {
      res.send("Failed");
    }
  });
  // app.post("/getReport", function (req, res) {
  //   var id = req.body.id;
  //   var kycCheckObject = {
  //     kycCheckId: id,
  //     ReportIds: {
  //       documentReportId: '',
  //       facialSimilarityReportId: '',
  //       watchlistReportId: ''
  //     }
  //   }
  //   RetrieveReportIds(id, function(response) {
  //     console.log(response);
  //     for(var i = 0; i < response.length; i++) {
  //       if(response[i].name == 'watchlist') {
  //         kycCheckObject.ReportIds.watchlistReportId = response[i].id;
  //       } else if (response[i].name == 'facial_similarity') {
  //         kycCheckObject.ReportIds.facialSimilarityReportId = response[i].id;
  //       } else if(response[i].name == 'document'){
  //         kycCheckObject.ReportIds.documentReportId = response[i].id;
  //       }
  //     }
  //     res.send(kycCheckObject);
  //   })
  // });
};

function RetrieveReportIds(id, callback) {
  var payload = {
    "kycCheckId": id
  }
  var url = 'https://api.onfido.com/v2/checks/' + id + '/reports';
  Request.get(
    {
      headers: {
        "content-type": "application/x-www-form-urlencoded",
        "Authorization": Config.onfido.key
      },
      url: url,
      body: JSON.stringify(payload)
    },
    (error, response, body) => {
      if (error) {
        console.log('RetrieveReportIds: ' + error);
        return callback(null);
      }
      if (response && (response.statusCode === 200 || response.statusCode === 201)) {
        console.log(body);
        result = JSON.parse(body);
        if (result.reports != null && result.reports.length > 0) {
          return callback(result.reports);
        } else {
          return callback(null);
        }
      }
    }
  )
}

function CheckAllReports(checkObj, callback) {
  try {
    console.log('Check ID: ' + checkObj.kycCheckId);
    var document = false, facial = false, watchlist = false;
    if (checkObj.ReportIds == null) throw 'Got no report ids';
    Object.keys(checkObj.ReportIds).forEach(function (key) {
      // var val = checkObj[key];
      // console.log('Report - ' + key + ': ' + checkObj.ReportIds[key]);
      getReport(checkObj.kycCheckId, key, checkObj.ReportIds[key], function (kycReportStatus) {
        console.log(key + ' status: ' + kycReportStatus);
        if (kycReportStatus) {
          if (key == 'documentReportId') {
            documentCheckStatus = kycReportStatus;
            document = true;
          } else if (key == 'facialSimilarityReportId') {
            facialSimilarityCheckStatus = kycReportStatus;
            facial = true;
          } else if (key == 'watchlistReportId') {
            watchlistCheckStatus = kycReportStatus;
            watchlist = true;
          }
          if (document && facial && watchlist) {
            console.log('completed');
            console.log('Doc: ' + documentCheckStatus + ', Face: ' + facialSimilarityCheckStatus + ', Watch: ' + watchlistCheckStatus);
            document = false; facial = false; watchlist = false;
            if (documentCheckStatus == 'S' && facialSimilarityCheckStatus == 'S' && watchlistCheckStatus == 'S') {
              documentCheckStatus = '', facialSimilarityCheckStatus = '', watchlistCheckStatus = '';
              callback('S');
            } else if (documentCheckStatus == 'F' || facialSimilarityCheckStatus == 'F' || watchlistCheckStatus == 'F') {
              documentCheckStatus = '', facialSimilarityCheckStatus = '', watchlistCheckStatus = '';
              callback('F');
            } else {
              documentCheckStatus = '', facialSimilarityCheckStatus = '', watchlistCheckStatus = '';
              callback('P');
            }
          }
        }
      });
    });
  } catch (err) {
    console.log(err);
  }
}

function getReport(checkId, reportName, reportId, callback) {
  var kycReportStatus = {
    documentReportStatus: '',
    facialSimilarityReportStatus: '',
    watchlistReportStatus: ''
  }
  var _url = 'https://api.onfido.com/v2/checks/' + checkId + '/reports/' + reportId;
  Request.get(
    {
      headers: {
        Authorization: Config.onfido.key
      },
      url: _url
    },
    (error, response, body) => {
      if (error) {
        console.log('getReport: ' + error);
        return res.send(error);
      }
      if (response && (response.statusCode === 200 || response.statusCode === 201)) {
        resultObj = JSON.parse(body);
        if (resultObj != null) {
          // console.log('Document: ' + body);
          try {
            if (reportName == 'documentReportId') {
              console.log('getReport: Document Report');
              //------- document and KYC check ---------             
              var nationality = resultObj.properties.nationality != null ? resultObj.properties.nationality : resultObj.properties.issuing_country;
              if (Config.onfido.blacklist.indexOf(nationality) > -1) {
                //In the array!
                callback('F');
              } else {
                //Not in the array
                if (resultObj.status == 'complete') {
                  if (resultObj.result == 'clear') {
                    callback('S');
                  } else {
                    callback('F');
                  }
                } else if (resultObj.status == 'withdrawn' || resultObj.status == 'cancelled') {
                  callback('F');
                } else {
                  callback('P');
                }
              }
              //------- End - document and KYC check ---------
            } else if (reportName == 'facialSimilarityReportId') {
              console.log('getReport: Facial Similarity Report');
              //------- facial similarity check ---------
              if (resultObj.status == 'complete') {
                if (resultObj.result == 'clear') {
                  callback('S');
                } else {
                  callback('F');
                }
              } else if (resultObj.status == 'withdrawn' || resultObj.status == 'cancelled') {
                callback('F');
              } else {
                callback('P');
              }
              //------- End - facial similarity check ---------
            } else if (reportName == 'watchlistReportId') {
              console.log('getReport: Watchlist Report');
              //------- watchlist AML check ---------
              if (resultObj.status == 'complete') {
                if (resultObj.result == 'clear') {
                  callback('S');
                } else {
                  callback('F');
                }
              } else if (resultObj.status == 'withdrawn' || resultObj.status == 'cancelled') {
                callback('F');
              } else {
                callback('P');
              }
              //------- End - watchlist AML check ---------
            }
          } catch (err) {
            console.log('GetReport: ' + err);
          }
        } else {
          console.log('not completed');
          callback(null);
        }
      }
    });
}

function updateKYCStatus(checkId, kycStatus, callback) {
  try {
    var update = {
      kycCheckId: checkId,
      kycStatus: kycStatus
    }

    Request.post(
      {
        headers: {
          "Authorization": "8149783206cc36bfb2f5e4b47306c0a8ec4d42b8",
          "Content-Type": "application/json"
        },
        url: Config.URL.updateKYCStatus,
        body: JSON.stringify(update)
      },
      (error, response, body) => {
        if (error) {
          console.log('updateKYCStatus: ' + error);
          callback(null);
        }
        if (response && (response.statusCode === 200 || response.statusCode === 201)) {
          result = JSON.parse(body);
          checkStack.pop(checkId);
          console.log('updateKYCStatus - done');
          callback(result);
        }
      }
    );
  } catch (e) {
    console.error(e);
  }
}

function RetryUpdateKYCStatus(checkId, kycStatus) {
  updateKYCStatus(checkId, kycStatus, function (updateStatus) {
    if (updateStatus != null) {
      console.log(updateStatus.data);
      if (updateStatus.data.length == 0) {
        console.log('Retrying update');
        // RetryUpdateKYCStatus(checkId, kycStatus);
        setTimeout(function () {
          RetryUpdateKYCStatus(checkId, kycStatus);
        }, 2000);
      } else {
        console.log('Update Status - Done');
      }
    }
  });
}

function getTokenSaleStatistics(tge_id, callback) {
  // console.log("Get Token Sale Statistics for TGE: " + tge_id)
  try {
    let sql = `CALL sp_get_tge_transaction(?)`;
    con.query(sql, [tge_id], (error, results, fields) => {
      if (error) {
        return logger.error(error.message);
      }
      else {
        // console.log("SP Results: " + JSON.stringify(results[0]));
        getMarketRate(10, function (marketRate) {
          if (marketRate) {
            // console.log("Market rates: " + JSON.stringify(marketRate));
            var sum = 0;
            var res = JSON.parse(JSON.stringify(results[0]));
            for (var i = 0; i < marketRate.length; i++) {
              // console.log(marketRate[i].symbol);
              for (name in res[0]) {
                if (name == marketRate[i].symbol) {
                  var qty = Number(res[0][name]);
                  if (name == 'ETH') {
                    qty /= Math.pow(10, 18);
                  } else {
                    qty *= Math.pow(10, -8);
                  }
                  sum += qty * marketRate[i].price;
                }
                // console.log(name + " : " + res[0][name]);
              }
            }
            // console.log("Sum: " + sum);
            // console.log("Avg: " + (sum / res[0]["fund_expected"]) * 100);
            var json = {
              percentage: (sum / res[0]["fund_expected"]) * 100
            };
            callback(json);
          }
        });
        // callback(results[0]);
      }
    });
  } catch (e) {
    console.error(e);
  }
}

function getMarketRate(limit, callback) {
  var url = "https://api.coinmarketcap.com/v2/ticker/?limit=";
  if (limit) {
    url += limit;
    Request.get(
      {
        url: url
      },
      (error, response, body) => {
        if (error) {
          console.log('currentRate: ' + error);
          callback(null);
        } else {
          var data = JSON.parse(body).data;
          var arr = [];
          for (var prop in data) {
            if (data[prop].symbol == 'BCH' || data[prop].symbol == 'BTC' || data[prop].symbol == 'ETH') {
              var result = new Object();
              result.name = data[prop].name;
              result.symbol = data[prop].symbol;
              result.price = data[prop].quotes.USD.price;
              arr.push(result);
            }
          }

          callback(arr);
        }
      })
  }
}

// function updateKYCStatusSql(checkId, kycStatus, callback) {
//   sql = 'update tbl_kyc set status = ? where kyc_check_id = ?';
//   con.query(sql, [kycStatus, checkId], (error, results, fields) => {
//     if (error) {
//       console.log('updateKYCStatus: ' + error.message);
//       callback(null);
//     }
//     else {
//       console.log(sql);
//       console.log(results);
//       console.log('updateKYCStatus - done');
//       callback('success');
//     }
//   });
// }

function sendMail(email) {
  //do something
  var payload = {
    "body": Config.KYC.body,
    "fromEmailId": Config.KYC.fromEmailId,
    "subject": Config.KYC.subject,
    "toEmailId": email
  }
  console.log(payload);
  Request.post(
    {
      headers: {
        "accept": "*/*",
        "Authorization": "8149783206cc36bfb2f5e4b47306c0a8ec4d42b8",
        "Content-Type": "application/json",
      },
      url: Config.URL.sendEMail,
      body: JSON.stringify(payload)
    },
    (error, response, body) => {
      if (error) {
        console.log('sendMail: ' + error);
      }
      console.log(body);
    }
  );
}

module.exports = appRouter;
