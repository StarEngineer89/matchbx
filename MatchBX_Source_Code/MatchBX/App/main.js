App = {
     _BaseURL:null,
    web3Provider: null,
    contracts: {},
    tokenInstance:null,
    escrowInstance:null,
    tokenAddress: "",
    escrowAddress: "",
    _userid:"",

    init: function (url, userid, usertype) {
        
        _BaseURL = url;
        _userid = userid;        
        _usertype = usertype;

        return App.initWeb3();
    },

    initWeb3: function () {
        // Initialize web3 and set the provider to the testRPC.

        window.addEventListener('load', async () => {
            // Modern dapp browsers...
            if (window.ethereum) {
                window.web3 = new Web3(ethereum);
                try {
                    // Request account access if needed
                    await ethereum.enable();
                    // Acccounts now exposed
                      
                    web3.eth.getAccounts(function (error, accounts) {
                        if (error || accounts.length == 0) {
                            console.log(error);
                                          
                            //callback("undefined");
                            $('#metamask').addClass('header_loged_menua_metamask');
                            $('.balance').html('<span>Setup</span><span>MetaMask</span>');
                            localStorage.setItem("Metamask", "S");
                        } else {
                            var account = accounts[0];
                            var userid = _userid;

                            if (_usertype != 1) {

                                $.ajax({
                                    type: 'GET',
                                    cache: false,
                                    url: _BaseURL + '/Home/IsUserApproved',
                                    //url: '@Url.Action("GetContractDetails", "Jobs")',
                                    data: { 'UserId': userid, 'Address': account },
                                    success: function (data) {
                                                      
                                        // Get the necessary contract artifact file and instantiate it with truffle-contract.  
                                        localStorage.setItem("Address", account);
                                        if (data == "Failed") {
                                            tokenInstance.allowance.call(account, escrowAddress, function (error, remaining) {
                                                if (remaining.toNumber() > 0) {
                                                    $('#metamask').addClass('header_loged_menua_metamask');
                                                    $('.balance').html('<span>Reset</span><span>Wallet</span>');
                                                    localStorage.setItem("Metamask", "A");
                                                } else {
                                                    $('#metamask').addClass('header_loged_menua_metamask');
                                                    $('.balance').html('<span>Authorize</span><span>MetaMask</span>');
                                                    localStorage.setItem("Metamask", "A");
                                                }
                                            });                                           

                                        }
                                        else {
                                            if (data.IsApproved == "Y") {
                                                $('#metamask').removeClass('header_loged_menua_metamask');
                                                $('#metamask').attr('onclick', '');
                                                localStorage.setItem("Metamask", "C");
                                                App.handleBalanceOf();
                                            }
                                            else if (data.IsApproved == "N") {
                                                $('#metamask').addClass('header_loged_menua_metamask');
                                                $('.balance').html('<span>Authorisation </span><span>pending</span>');
                                                $('#metamask').attr('onclick', '');
                                                localStorage.setItem("Metamask", "P");
                                            }
                                            
                                        }
                                    },
                                    error: function (jqXHR, exception) {
                                        console.log(jqXHR.status);
                                        console.log(exception);
                                    }
                                });
                            }
                            else {
                                App.handleBalanceOf();
                                $('#metamask').removeClass('header_loged_menua_metamask');
                                $('#metamask').attr('onclick', '');
                                localStorage.setItem("Metamask", "C");
                            }
                        }

                    });

                    function callback(response) {
                                      
                    }
                    web3.currentProvider.publicConfigStore.on('update', callback);

                } catch (error) {
                    // User denied account access...
                }
            } else {
                $('#metamask').addClass('header_loged_menua_metamask');
                $('.balance').html('<span>Setup</span><span>MetaMask</span>');
                localStorage.setItem("Metamask", "S");
            }           

        });
        

        return App.initContract();
    },    

    initContract: function () {     
      

        $.ajax({
            type: 'GET',
            cache: false,
            dataType: "json",
            url: _BaseURL + '/Jobs/GetContractDetails',
            //url: '@Url.Action("GetContractDetails", "Jobs")',
            contentType: "application/json; charset=utf-8",
            data: '{}',
            success: function (data) {

                var tokenAbi = JSON.parse(data.TokenABI);
                tokenAddress = data.TokenAddress;
                var tokenContract = web3.eth.contract(tokenAbi);
                tokenInstance = tokenContract.at(tokenAddress);


                var escrowAbi = JSON.parse(data.EscrowABI);
                escrowAddress = data.EscrowAddress;
                var escrowContract = web3.eth.contract(escrowAbi);
                escrowInstance = escrowContract.at(escrowAddress);

                // Use our contract to retieve and mark the adopted pets.
                //App.handleBalanceOf();

            },
            error: function (jqXHR, exception) {
                console.log(jqXHR.status);
                console.log(exception);
            }
        });       
        
        return App.bindEvents();
    },

    bindEvents: function () {
        $(document).on('click', '#metamask', App.handleBalanceOf);
        $(document).on('click', '#btn_deposit', App.handleDeposit);
        $(document).on('click', '#btn_pay', App.handlePay);
        $(document).on('click', '#btn_refund', App.handleRefund);
        $(document).on('click', '#btn_approve', App.handleApprove);
    },

    handleAllowance: function (tokenAmount, callback) {
                      
        var account = "";
        if (typeof web3 == 'undefined') {
            callback("error","undefined");
        } else {
            web3.eth.getAccounts(function (error, accounts) {
                if (error || accounts.length == 0) {
                    console.log(error);
                    callback(account,"undefined");
                    return error;
                }

                account = accounts[0];

                tokenInstance.balanceOf.call(account, function (err, balance) {
                    if (err) {
                        console.log(err.message);
                        callback(account, "denied");
                    } else {
                        console.log(balance + " : " + balance.toNumber());
                        if (tokenAmount * Math.pow(10, 18) > balance.toNumber()) {
                            callback(account, "insufficient");
                        } else {
                            tokenInstance.allowance.call(account, escrowAddress, function (error, remaining) {
                                console.log(remaining.toNumber() + " : " + tokenAmount * Math.pow(10, 18));
                                if (remaining.toNumber() > tokenAmount * Math.pow(10, 18)) {
                                    callback(account, "approved");
                                } else {
                                    if (remaining.toNumber() == 0) {
                                        callback(account, "denied");
                                    } else if (balance.toNumber() > remaining.toNumber()) {
                                        callback(account, "reset");
                                    } else {
                                        callback(account, "insufficient");
                                    }
                                }
                            });
                        }
                    }
                });                
                
            });
        }
           
       
    },

    resetApproveBalance: function (callback) {
        var account = "";
        if (typeof web3 == 'undefined') {
            callback("error", "undefined");
        } else {
            web3.eth.getAccounts(function (error, accounts) {
                if (error || accounts.length == 0) {
                    console.log(error);
                    callback(account, "undefined");
                    return error;
                }

                account = accounts[0];
                tokenInstance.approve.sendTransaction(escrowAddress, 0, { from: account, gasPrice: web3.toHex(web3.toWei('20', 'gwei')), gasLimit: web3.toHex(100000) }, function (err, result) {
                    if (err) {
                        console.log(err.message);
                        callback("denied");
                    } else {
                        console.log(result);
                        callback("reset");
                    }
                });
            });
        }


        
    },

    checkBalance: function(callback){
        web3.eth.getAccounts(function (error, accounts) {
            if (error) {
                console.log(error);
            }

            var address = accounts[0];

            if (address != 'undefined') {
                web3.eth.getBalance(address, function (err_bal, ethBalance) {
                    if (err_bal) {
                        console.log(err.message);
                        callback("cancelled");
                    } else {
                        console.log(ethBalance);
                        if (ethBalance.c[0] > 0) {
                            tokenInstance.balanceOf.call(address, function (err, balance) {
                                if (err) {
                                    console.log(err.message);
                                    callback("cancelled");
                                } else {

                                    if (balance.c[0] > 0) {
                                        tokenInstance.allowance.call(address, escrowAddress, function (error, remaining) {
                                            if (remaining.toNumber() > 0) {
                                                callback("isApproved");
                                            } else {
                                                callback("isbalance");
                                            }
                                        });
                                    }
                                    else {
                                        callback("empty");
                                    }

                                }
                            });
                        } else {
                            callback("ethempty");
                        }                        
                    }
                    
                });                
            }


        });
    },

    

    handleApprove: function (callback) {
        

        web3.eth.getAccounts(function (error, accounts) {
            if (error) {
                console.log(error);
            }

            var address = accounts[0];

            if (address != 'undefined') {
                tokenInstance.balanceOf.call(address, function (err, balance) {
                    if (err) {
                        console.log(err.message);
                        callback("cancelled");
                    } else {

                        if (balance.c[0] > 0) {
                            tokenInstance.approve.sendTransaction(escrowAddress, balance, { from: address, gasPrice: web3.toHex(web3.toWei('20', 'gwei')),gasLimit: web3.toHex(100000) }, function (err, result) {
                                if (err) {
                                    console.log(err.message);
                                    callback("cancelled");
                                } else {
                                    console.log(result);
                                    callback(result);
                                }
                            });
                        }
                    }
                });
                
            }
            

        });
    },

    handleBalanceOf: function () {
        web3.eth.getAccounts(function (error, accounts) {
            if (error) {
                console.log(error);
            }

            var address = accounts[0];

            if (address != 'undefined') {
                var decimal = 3;
                var symbol = 'AXPR';


                tokenInstance.decimals.call(function (err, _decimal) {
                    decimal = _decimal.c[0];

                    tokenInstance.symbol.call(function (err, _symbol) {
                        symbol = _symbol;

                        tokenInstance.balanceOf.call(address, function (err, balance) {
                            if (err) {
                                console.log(err.message);
                                //window.App.setTransferStatus('Error: ' + error);
                            } else {

                                var bal = (balance / Math.pow(10, decimal)).toFixed(3);;
                                $('.balance_value').html(bal);
                                $('.balance_symbol').html(symbol);

                            }
                        });
                    })
                });
                
            } else {
                return "Metamask not loggedIn";
            }            

        });           
        
        

    },

    handlePay: function (jobId) {
        
        web3.eth.getAccounts(function (error, accounts) {
            if (error) {
                console.log(error);
            }

            var account = accounts[0];

            escrowInstance.pay.sendTransaction(jobId, { from: account }, function (result) {
                console.log(result);
            });
            
        });

    },

    handleDeposit: function (jobid, toAddr, tokenAmt,callback) {       

        web3.eth.getAccounts(function (error, accounts) {
            if (error) {
                callback("cancelled");
                console.log(error);
            }

            var account = accounts[0];
            var jobId = parseInt(jobid);

            escrowInstance.deposit.sendTransaction(jobId, account, toAddr, tokenAmt, { from: account, gasPrice: web3.toHex(web3.toWei('20', 'gwei')), gasLimit: web3.toHex(100000) }, function (error, result) {
                if (error) {
                    console.log(error.message);
                    callback("cancelled");
                } else {
                    console.log(result);
                    callback(result);
                }
                
            });
            
        });
    },


    handleRefund: function (event) {
        event.preventDefault();

        var stepId = $("input[id=stepRfdLabel]").val();

        web3.eth.getAccounts(function (error, accounts) {
            if (error) {
                console.log(error);
            }

            var account = accounts[0];
            escrowInstance.refund.sendTransaction(stepId, { from: account }, function (error, result) {
                if (error) {
                    console.log(error);
                } else {
                    console.log(result);
                }
            });
            
        });
    },

    getUserAddress: function (callback) {

        if (typeof web3 == 'undefined') {
            callback("error");
        }
        else {
            web3.eth.getAccounts(function (error, accounts) {
                if (error)
                {
                    console.log(error);
                    return error;
                }
                var account = "";
                if (accounts.length > 0)
                {
                    account = accounts[0];                    
                }
                callback(account);
            });
        }
        
    },


};


//$(function () {
//    $(window).load(function () {
//        App.init(Url);
//    });
//});

