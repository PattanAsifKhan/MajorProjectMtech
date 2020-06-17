pragma solidity ^0.5.0;
contract Transfer{
    address owner;
    //setting the owner using the constructur
    constructor() public {
        owner = msg.sender;
    }
    //modifer to verify whether the owner is using the account or not
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "You must be the owner."
        );
        _;
    }
    //owner can self destroy the contract, as mentioned in the problem statement
    function close() public onlyOwner { 
         selfdestruct(msg.sender);
         //self destruct is the call that destroys the contract
    }
    //using byte32 data tyoe to reduce gas cost, string increases gas price heavily
    //if you are testing directly from solc please use hex value of string
    //example of a name 0x1234
    struct AccountHolder{
        bytes32 name;
        uint ethbalance;
        //uint altcoinbalance;
    }
    mapping(address=>AccountHolder) AccountHolders;
    address[] public HolderAccountsAdresses;
    //Depositing function
    function deposit(address _address,bytes32  _name,uint _ethbalance) public{
        AccountHolders[_address].name=_name;
        AccountHolders[_address].ethbalance=_ethbalance;
        HolderAccountsAdresses.push(_address);
    }
    //check function which verifies whether the eth amount is present in account  or not.
    function check(address _address,uint _amount) public view returns(bool){
        if(AccountHolders[_address].ethbalance-_amount >=0){
            return true;
        }
        return false;
    }
    //Transer amount eth, it takes two addresses as parameters and transfers eth from one account to another
    function transfereth(string address _address,string address _address1,uint _amount) public returns(bool){
      if(check(_address,_amount)==true){
          //not using the send method here directly to reduce gas cost, in real time this operation 
          //will be replaced using send or transfer methods
          for(uint i=0;i<100;i++){
            AccountHolders[_address].ethbalance-=_amount;
            AccountHolders[_address1].ethbalance+=_amount;
          }
            return true;
        }
        return false;
    }
    //takes address as parameter and returns ethbalance of that account
    function balanceinfo(address _address) public view returns(uint){
        return AccountHolders[_address].ethbalance;
    }
    
}
