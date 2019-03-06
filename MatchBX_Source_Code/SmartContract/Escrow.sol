pragma solidity ^0.4.19;

contract ERC20 {
        function _transfer(address _from, address _to, uint256 _value) internal returns (bool);
        function transfer(address _to, uint256 _value) public returns (bool);
        function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
        function _burn(address _from, uint256 _value) internal returns (bool);
        function burn(uint256 _value) public returns (bool);
        function burnFrom(address _from, uint256 _value) public returns (bool);
        function approve(address _spender, uint256 _value) public returns (bool);
        function balanceOf(address _owner) public constant returns (uint256);
        function allowance(address _owner, address _spender) public constant returns (uint256);

        event Transfer(address indexed from, address indexed to, uint256 value);
        event Burn(address indexed _from, uint256 _value);
        event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


contract MatchBx
{
    ERC20 public token;

    address public feeAccount;
    address public founder;
    address public owner;

    uint fee_mul = 3;
    //uint fee_den = 100;

    struct Step {
        address from;
        address to;
        uint    amount;
        uint    fee;
    }

    mapping (uint => Step) public steps;

    modifier onlyOwner
    {
        require(msg.sender == owner);
        _;
    }

    function MatchBx(address token_address)
    {
        token = ERC20(token_address);
        founder = msg.sender;
        owner = msg.sender;
    }


    function transferOwnership(address newOwner)
    {
        require(msg.sender == founder);
        owner = newOwner;
    }

    function setFeeAccount (address new_account) onlyOwner
    {
        feeAccount = new_account;
    }

    function setFee (uint fee) onlyOwner
    {
        require(fee >= 0 && fee < 100);
        fee_mul = fee;
    }
    
    function approve(address _spender, uint256 _amount) {
        token.approve(_spender, _amount);
    }
    // What is the balance of a particular account?
      function balanceOf(address _owner) constant returns (uint256 balance) {
         return token.balanceOf(_owner);
      }

    function deposit (uint step_id, address from, address to, uint amount)
    {
        require(from != address(0));
        require(to != address(0));
        require(amount > 0);
        require(feeAccount != address(0));

        uint fee = (amount * fee_mul) / 100;
        require(token.balanceOf(from) >= amount + fee);

        Step storage step = steps[step_id];
        require(step.from == address(0));

        step.from = from;
        step.to = to;
        step.amount = amount;
        step.fee = fee;

        token.transferFrom(step.from, this, step.amount);    //transfer to escrow
        token.transferFrom(step.from, feeAccount, fee); //withdraw fee
    }

    function pay (uint step_id) onlyOwner
    {
        Step step = steps[step_id];
        require(step.from != address(0));

        token.transfer(step.to, step.amount - step.fee);
        token.transfer(feeAccount,step.fee);
        delete steps[step_id];
    }

    function refund (uint step_id) onlyOwner
    {
        Step step = steps[step_id];
        require(step.from != address(0));

        token.transfer(step.from, step.amount);
        delete steps[step_id];
    }
}